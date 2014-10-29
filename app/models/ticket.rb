class Ticket < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :activities
  belongs_to :status

  attr_accessor :status_key, :current_user_name

  accepts_nested_attributes_for :comments

  validates_presence_of :email

  default_scope { order(created_at: :desc) }
  scope :open, ->{ joins(:status).where('status_id is null or (status_id is not null and statuses.key not in (?))', Status.closed_status_keys) }
  scope :closed, ->{ joins(:status).where('status_id is not null and statuses.key in (?)', Status.closed_status_keys) }
  scope :unassigned, ->{ where(user_id:nil) }

  include FriendlyId
  friendly_id :generate_reference, use: :slugged

  after_initialize :set_defaults

  before_create :build_activity
  before_save :set_status

  after_create :notify_create

  def self.for_status(status_key)
    joins(:status).where(statuses: { key: status_key })
  end

  def self.user_name(email)
    where('email = ? and name is not null', email).first.try(:name)
  end

  def self.search(query)
    Ticket
    .where 'email like :query or subject like :query or body like :query or slug like :query', query: "%#{query}%"
  end

  def generate_reference
    sr = SecureRandom
    chrs = 3.times.map{ sr.urlsafe_base64(2) }
    hxs = 2.times.map{ sr.hex(1) }
    "#{chrs[0]}-#{hxs[0]}-#{chrs[1]}-#{hxs[1]}-#{chrs[2]}"
  end

  def reference
    self.slug
  end

  def is_open?
    self.status.nil? || (self.status && !Status.closed_status_keys.include?(self.status.key.to_s))
  end

  def is_assigned?
    self.user_id.present?
  end

  def take_ownership! owner
    self.user = owner
    self.activities.create! activity_type: :own, user_name: self.user.user_name 
    
    self.save!    
  end

  def notify_create
    CustomerMailer.ticket_create(self).deliver
  end

  private

  def set_defaults    
    if self.status
      self.status_key = self.status.key
    else
      self.status_key ||= :waiting_for_staff_response
    end
  end

  def build_activity
    activity = self.activities.build activity_type: :create, user_name: (self.name.present? ? self.name : self.email)
    raise "Activity not valid: #{activity.errors.messages}" if !activity.valid?
  end

  def set_status
    
    if self.status_key.present?

      current_status_key = self.status.try(:key)
      new_status = Status.find_or_create_by!(key: self.status_key.to_s)
      
      if current_status_key != new_status.key
        
        if self.persisted?
          self.activities.build activity_type: :status_change, user_name: self.current_user_name
 
          if self.is_open? && Status.closed_status_keys.include?(new_status.key)
            activity = self.activities.build activity_type: :close, user_name: self.current_user_name          
          end

          if !self.is_open? && !Status.closed_status_keys.include?(new_status.key)
            activity = self.activities.build activity_type: :open, user_name: self.current_user_name          
          end

          raise "Activity not valid: #{activity.errors.messages}" if activity && !activity.valid?
        end

        self.status = new_status

      end

    end
  end
end
