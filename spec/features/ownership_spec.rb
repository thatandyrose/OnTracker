feature 'Ticket Ownership' do
  before do
    @user = FactoryGirl.create(:user)
    signin(@user.email, @user.password)
  end

  context 'when listing' do
    
    it 'should list open tickets' do
      FactoryGirl.create :ticket, subject: 'some open ticket'
      visit open_tickets_path

      expect(page).to have_content 'some open ticket'
    end

    it 'not list owned tickets' do
      FactoryGirl.create :ticket, subject: 'some owned ticket', user: @user
      visit open_tickets_path

      expect(page).to_not have_content 'some owned ticket'
    end

  end

  context 'when taking ownership' do

    before do
      @ticket = FactoryGirl.create :ticket, body: 'some open ticket'
      visit open_tickets_path

      click_on 'Own!'

      @user.reload
      @ticket.reload
    end

    it 'should assing the ticket to the user' do
      expect(@user.tickets.count).to eq 1
      expect(@ticket.user).to eq @user
    end

    it 'should take you to the ticket details page' do
      expect(current_path).to eq ticket_path(@ticket)
    end

  end
end