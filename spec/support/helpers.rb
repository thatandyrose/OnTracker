require 'support/helpers/session_helpers'
require 'support/helpers/mailer_helpers'

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include MailerHelpers
end
