feature 'Ticket statuses' do

  before do
    @ticket = FactoryGirl.create :ticket
  end

  context 'when you set the status to cancelled or completed' do

    it 'should close the ticket if status is cancelled' do
      @ticket.update_attributes! status_key: :cancelled
      expect(@ticket.is_open?).to be_falsey
    end

    it 'should close the ticket if status is completed' do
      @ticket.update_attributes! status_key: :completed

      expect(@ticket.is_open?).to be_falsey
    end

  end

  context 'when you create a ticket' do

    it 'should have a Waiting for Staff Response status' do
      expect(@ticket.status.label).to eq 'Waiting For Staff Response'
    end

    it 'should have be open' do
      expect(@ticket.is_open?).to be_truthy
    end

  end

  context 'when a logged in user creates a comment' do

    before do
      @user = FactoryGirl.create(:user)
      signin(@user.email, @user.password)

      visit ticket_path(@ticket)

      fill_in :ticket_comments_attributes_0_text, with: 'some stuff about this ticket'
      click_on 'Add comment'
      @ticket.reload
    end

    it 'should change the status to Waiting for Customer Response' do
      expect(@ticket.status.label).to eq 'Waiting For Customer Response'
    end
  end

  context 'when the ticket user creates a comment' do

    before do
      visit ticket_path(@ticket)

      fill_in :ticket_comments_attributes_0_text, with: 'some stuff about this ticket'
      fill_in :ticket_comments_attributes_0_email, with: @ticket.email
      click_on 'Add comment'
      @ticket.reload
    end

    it 'should change the status to Waiting for Staff Response' do
      expect(@ticket.status.label).to eq 'Waiting For Staff Response'
    end
  end

  context 'when I visit the ticket as a logged in user' do
    
    before do
      @user = FactoryGirl.create(:user)
      signin(@user.email, @user.password)

      visit ticket_path(@ticket)
    end

    it 'should let me change the status to on hold' do
      select 'On Hold', from: :ticket_status_key
      click_on 'Update status'
      @ticket.reload

      expect(@ticket.status.key).to eq 'on_hold'
    end

    it 'should have the options for all defaut statuses' do
      expect(page).to have_selector "option[value='waiting_for_staff_response']"
      expect(page).to have_selector "option[value='waiting_for_customer_response']"
      expect(page).to have_selector "option[value='on_hold']"
      expect(page).to have_selector "option[value='cancelled']"
      expect(page).to have_selector "option[value='completed']"
    end

  end

  context 'when I visit the ticket as a non logged in user' do
    before do
      visit ticket_path(@ticket)
    end

    it 'should not have the update options' do
      expect(page).to_not have_selector 'select'
    end

    it 'should not have the options for all defaut statuses' do
      expect(page).to_not have_selector "option[value='waiting_for_staff_response']"
      expect(page).to_not have_selector "option[value='waiting_for_customer_response']"
      expect(page).to_not have_selector "option[value='on_hold']"
      expect(page).to_not have_selector "option[value='cancelled']"
      expect(page).to_not have_selector "option[value='completed']"
    end

  end

  context 'editing statuses' do

    before do
      @user = FactoryGirl.create(:user)
      signin(@user.email, @user.password)
    end

    context 'creating new statuses' do

      before do
        visit statuses_path
        click_on 'Add new status'
      end

      it 'should validate missing values' do
        click_on 'Save status'

        expect(page).to have_content 'Key or label required.'
      end 

      it 'should create new status' do
        fill_in :status_label, with: 'My new status'
        click_on 'Save status'
        
        expect(current_path).to eq statuses_path

        new_status = Status.last
        expect(new_status.label).to eq 'My new status'
        expect(new_status.key).to eq 'my_new_status'
      end      

    end

    context 'edit status' do

      before do
        @status = Status.find_by_key('waiting_for_staff_response')
        
        visit edit_status_path(@status)

        fill_in :status_label, with: 'A brand new name'
        click_on 'Save status'

        @status.reload
      end

      it 'should change the label but not the other values' do
        expect(@status.label).to eq 'A brand new name'
        expect(@status.key).to eq 'waiting_for_staff_response'
      end

    end

  end
end