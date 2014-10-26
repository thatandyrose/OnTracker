class Comment < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user

  validates_presence_of :text, message: 'A comment cannot be empty.'
  validates_presence_of :email, message: 'Your email is required.', if: ->(comment){ comment.user.nil? }

  default_scope { order(created_at: :asc) }

  after_create :notify_create, :update_ticket_status

  def submitter_name
    self.user ? self.user.name : Ticket.user_name(self.email)
  end

  def submitter_email
    self.user ? self.user.email : self.email
  end

  def notify_create
    CustomerMailer.comment_create(self).deliver if self.user || self.email != self.ticket.email
  end

  def update_ticket_status
    
    if self.user.nil? && self.email == self.ticket.email
      self.ticket.update_attributes! status_key: :waiting_for_staff_response
    end

    if self.user
      self.ticket.update_attributes! status_key: :waiting_for_customer_response
    end

  end
end
