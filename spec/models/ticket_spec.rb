describe Ticket do
  context 'when you create a ticket' do
    before do
      @ticket = Ticket.create!
    end

    it 'should generate a 17 long reference' do
      expect(@ticket.reference).to be_present
      expect(@ticket.reference.length).to eq 17
    end
  end
end