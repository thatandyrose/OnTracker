describe Api::V1::TicketsController do
  render_views

  context 'create ticket' do
    
    context 'validating' do
      before do
        post :create, {ticket:{subject: 'whatevs', body: 'something', name: 'whoever'}}
      end

      it 'should give me a 400' do
        expect(response.code). to eq '400'
      end
    end

    context 'create' do
      before do
        post :create, {ticket:{subject: 'whatevs', body: 'something', name: 'whoever', email: 'me@world.com'}}

        @ticket_response = JSON.parse(response.body)
      end

      it 'should return a 200' do
        expect(response.code). to eq '200'
      end

      it 'should return the new ticket' do
        expect(@ticket_response['reference']).to eq Ticket.first.reference
      end

      it 'should create a new ticket' do
        expect(Ticket.count).to eq 1
        expect(Ticket.first.subject).to eq 'whatevs'
        expect(Ticket.first.body).to eq 'something'
        expect(Ticket.first.name).to eq 'whoever'
        expect(Ticket.first.email).to eq 'me@world.com'
      end
    end

  end
end