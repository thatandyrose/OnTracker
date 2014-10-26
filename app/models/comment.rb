class Comment < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user

  validates_presence_of :text, message: 'A comment cannot be empty.'
  validates_presence_of :email, message: 'Your email is required.', if: ->(comment){ comment.user.nil? }

  default_scope { order(created_at: :asc) }

  after_create :notify_create

  def submitter_name
    user ? user.name : Ticket.user_name(email)
  end

  def submitter_email
    user ? user.email : email
  end

  def notify_create
    CustomerMailer.comment_create(self).deliver if user || email != ticket.email
  end
end
