feature 'Ticket activities' do

  before do
    @ticket = FactoryGirl.create :ticket
  end

  context 'when a ticket is created' do

    it 'should create a create activity for the ticket' do
      expect(Activity.count).to eq 1
      expect(Activity.first.activity_type).to eq 'create'
      expect(Activity.first.ticket).to eq @ticket
    end

    it 'should show the activity on the page' do
      visit ticket_path(@ticket)

      expect(page).to have_content 'someone created a new ticket'
    end

  end

  context 'when an admin is logged in' do

    before do
      @user = FactoryGirl.create(:user)
      signin(@user.email, @user.password)

      visit ticket_path(@ticket)
    end

    context 'and takes ownership of a ticket' do
      
      before do
        click_on 'Own!'
      end

      it 'should create an own actvity for the ticket' do
        expect(Activity.count).to eq 2
        expect(Activity.last.activity_type).to eq 'own'
        expect(Activity.first.ticket).to eq @ticket
      end

      it 'should show the activity on the page' do
        expect(page).to have_content 'Test User took ownership of the ticket'
      end

    end

    context 'and changes the status of a ticket' do

      before do
        select 'On Hold', from: :ticket_status_key
        click_on 'Update status'
      end

      it 'should create a status change actvity for the ticket' do
        expect(Activity.count).to eq 2
        expect(Activity.last.activity_type).to eq 'status_change'
        expect(Activity.first.ticket).to eq @ticket
      end

      it 'should show the activity on the page' do
        expect(page).to have_content 'Test User changed the ticket status to On Hold'
      end      

    end

    context 'and changes the status of a ticket and closes ticket' do

      before do
        select 'Cancelled', from: :ticket_status_key
        click_on 'Update status'

        @ticket.reload
      end

      it 'should create a status change actvity for the ticket' do
        expect(Activity.count).to eq 3
        expect(Activity.where(activity_type: :status_change).count).to eq 1
        
        expect(Activity.find_by_activity_type(:status_change).ticket).to eq @ticket
        expect(Activity.find_by_activity_type(:status_change).user_name).to eq 'Test User'
      end

      it 'should create a close activity for the ticket' do
        expect(Activity.count).to eq 3
        expect(Activity.where(activity_type: :close).count).to eq 1
        
        expect(Activity.find_by_activity_type(:close).ticket).to eq @ticket
        expect(Activity.find_by_activity_type(:close).user_name).to eq 'Test User'
      end

      it 'should show the activities on the page' do
        expect(page).to have_content 'Test User changed the ticket status to Cancelled'
        expect(page).to have_content 'Test User closed the ticket'
      end      

    end

    context 'and changes the status of a closed ticket and opens the ticket' do

      before do
        @ticket.update_attributes! status_key: :cancelled
        Activity.destroy_all

        select 'On Hold', from: :ticket_status_key
        click_on 'Update status'

        @ticket.reload
      end

      it 'should create a status change actvity for the ticket' do
        expect(Activity.count).to eq 2
        expect(Activity.where(activity_type: :status_change).count).to eq 1
        
        expect(Activity.find_by_activity_type(:status_change).ticket).to eq @ticket
        expect(Activity.find_by_activity_type(:status_change).user_name).to eq 'Test User'
      end

      it 'should create a close activity for the ticket' do
        expect(Activity.where(activity_type: :open).count).to eq 1
        
        expect(Activity.find_by_activity_type(:open).ticket).to eq @ticket
        expect(Activity.find_by_activity_type(:open).user_name).to eq 'Test User'
      end

      it 'should show the activities on the page' do
        expect(page).to have_content 'Test User changed the ticket status to On Hold'
        expect(page).to have_content 'Test User opened the ticket'
      end      

    end
  end
  
end