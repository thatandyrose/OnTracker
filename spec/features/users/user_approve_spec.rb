include Warden::Test::Helpers
Warden.test_mode!

# Feature: User approve
#   As a user
#   I can approve other users
#   So that they can log in
feature 'User approve', :devise do

  after(:each) do
    Warden.test_reset!
  end

  before do
    @unapproved = FactoryGirl.create :user, email: 'notapproved@somewhere.com', approved: false
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit unapproved_users_path
  end

  it 'should list the unpproved user' do
    expect(page).to have_content 'notapproved@somewhere.com'
  end

  it 'should let me approve the user' do
    click_on 'Approve'
    @unapproved.reload
    
    expect(@unapproved.approved?).to be_truthy

    expect(page).to have_content "User #{@unapproved.email} approved"
  end

end
