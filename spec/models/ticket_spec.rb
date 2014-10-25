feature Ticket do
  context 'when you create a ticket' do
    before do
      @ticket = Ticket.create! email: 'someuser@where.com'
    end

    it 'should generate a 17 long reference' do
      expect(@ticket.reference).to be_present
      expect(@ticket.reference.length).to eq 17
    end

    it 'should email the user with a note and link' do
      expect(last_email.to.first).to eq 'someuser@where.com'
      expect(last_email.body.to_s).to include ticket_path(@ticket)
      expect(last_email.body.to_s).to include 'http://'

    end
  end
end