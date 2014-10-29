class Comment < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  has_many :activities

  validates_presence_of :text, message: 'A comment cannot be empty.'
  validates_presence_of :email, message: 'Your email is required.', if: ->(comment){ comment.user.nil? }

  default_scope { order(created_at: :asc) }

  before_save :handle_activities
  after_create :notify_create, :update_ticket_status

  def submitter_name
    self.user ? self.user.user_name : Ticket.user_name(self.email)
  end

  def submitter_email
    self.user ? self.user.email : self.email
  end

  def notify_create
    CustomerMailer.comment_create(self).deliver if self.user || self.email != self.ticket.email
  end

  def update_ticket_status
    
    if self.user.nil? && self.email == self.ticket.email
      self.ticket.update_attributes! status_key: :waiting_for_staff_response, current_user_name: self.submitter_name
    end

    if self.user
      self.ticket.update_attributes! status_key: :waiting_for_customer_response, current_user_name: self.submitter_name
    end

  end

  private

  def handle_activities
    
    if self.new_record?
      activity = self.activities.build activity_type: :create, user_name: self.submitter_name, ticket_id: self.ticket_id
      raise "Activity not valid: #{activity.errors.messages}" if !activity.valid?
    end
    
  end
end
