feature 'Ticket Show' do
  
  context 'when no user is logged in' do
    before do
      @ticket = FactoryGirl.create :ticket
      visit ticket_path(@ticket)
    end

    it 'should allow me to view the ticket' do
      expect(page).to have_content 'some body for the ticket'
    end

    it 'should not allow me to own the ticket' do
      expect(page).to_not have_selector "a[href='#{own_ticket_path(@ticket)}']"
    end
  end
end