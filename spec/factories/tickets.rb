FactoryGirl.define do
  factory :ticket do
    user nil
    body "some body for the ticket"
    email "someemail@fortheticket.com"
    name "someone"
    subject "some subject for the ticket"
    department "some dept for the ticket"
    current_user_name 'test runner'
  end
end
