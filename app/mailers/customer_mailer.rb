class CustomerMailer < ActionMailer::Base
  default from: ENV['ADMIN_EMAIL']

  def ticket_create(ticket)
    @ticket = ticket
    @name = @ticket.name.present? ? @ticket.name : @ticket.email
    mail to: @ticket.email, subject: "Your ticket has been received. Thanks!"
  end
end
