module MailerHelpers
  def first_email
    ActionMailer::Base.deliveries.first
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def second_last_email
    ActionMailer::Base.deliveries[-2]
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end

  def delivered_emails
    ActionMailer::Base.deliveries
  end
end
