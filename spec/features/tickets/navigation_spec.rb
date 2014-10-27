feature 'Ticket naviagation' do
  before do
    @user = FactoryGirl.create(:user)
    signin(@user.email, @user.password)
  end

  context 'when I go to any page' do
    before do
      visit '/'
    end

    it 'should show me a link to tickets' do
      expect(page).to have_selector "a[href='#{tickets_path}']"
    end
  end

  context 'when I visit tickets listing' do
    before do
      FactoryGirl.create :ticket, subject: 'tick 1', status_key: :waiting_for_staff_response
      FactoryGirl.create :ticket, subject: 'tick 2', status_key: :waiting_for_customer_response, user: @user
      FactoryGirl.create :ticket, subject: 'tick 3', status_key: :on_hold, user: @user
      FactoryGirl.create :ticket, subject: 'tick 4', status_key: :cancelled
      FactoryGirl.create :ticket, subject: 'tick 5', status_key: :completed, user: @user

      visit tickets_path
    end

    it 'should show all tickets' do
      expect(all('.ticket-row').count).to eq 5

      expect(page).to have_content 'tick 1'
      expect(page).to have_content 'tick 2'
      expect(page).to have_content 'tick 3'
      expect(page).to have_content 'tick 4'
      expect(page).to have_content 'tick 5'
    end

    it 'should show me filter links' do
      expect(page).to have_selector(:link_or_button, 'Unassigned')
      expect(page).to have_selector(:link_or_button, 'Open')
      expect(page).to have_selector(:link_or_button, 'On Hold')
      expect(page).to have_selector(:link_or_button, 'Closed')
    end

    it 'should filter Unassigned' do
      click_on 'Unassigned'

      expect(page).to have_content 'tick 1'
      expect(page).to have_content 'tick 4'

      expect(all('.ticket-row').count).to eq 2
    end

    it 'should filter Open' do
      click_on 'Open'

      expect(page).to have_content 'tick 1'
      expect(page).to have_content 'tick 2'
      expect(page).to have_content 'tick 3'

      expect(all('.ticket-row').count).to eq 3
    end

    it 'should filter On Hold' do
      click_on 'On Hold'

      expect(page).to have_content 'tick 3'

      expect(all('.ticket-row').count).to eq 1
    end

    it 'should filter Closed' do
      click_on 'Closed'

      expect(page).to have_content 'tick 4'
      expect(page).to have_content 'tick 5'

      expect(all('.ticket-row').count).to eq 2
    end

  end
end