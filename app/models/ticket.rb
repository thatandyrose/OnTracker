class Ticket < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  belongs_to :status

  attr_accessor :status_key

  accepts_nested_attributes_for :comments

  validates_presence_of :email

  default_scope { order(created_at: :desc) }
  scope :open, ->{ joins(:status).where('status_id is null or (status_id is not null and statuses.key not in (?))', Status.closed_status_keys) }
  scope :closed, ->{ joins(:status).where('status_id is not null and statuses.key in (?)', Status.closed_status_keys) }
  scope :unassigned, ->{ where(user_id:nil) }

  include FriendlyId
  friendly_id :generate_reference, use: :slugged

  after_create :notify_create
  before_save :set_status
  after_initialize :set_defaults

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

  def set_status
    self.status = Status.find_or_create_by!(key: status_key) if self.status_key.present?
  end
end
