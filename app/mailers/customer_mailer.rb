class CustomerMailer < ActionMailer::Base
  default from: ENV['ADMIN_EMAIL']

  def ticket_create(ticket)
    @ticket = ticket
    @name = @ticket.name.present? ? @ticket.name : @ticket.email
    mail to: @ticket.email, subject: "Your ticket has been received. Thanks!"
  end

  def comment_create(comment)
    @ticket = comment.ticket
    @comment = comment
    
    @name = @ticket.name.present? ? @ticket.name : @ticket.email
    mail to: @ticket.email, subject: "Your ticket has a new comment!"
  end
end
