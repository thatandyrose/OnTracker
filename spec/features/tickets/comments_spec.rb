feature 'Ticket comments' do
  
  before do
    @ticket = FactoryGirl.create :ticket
  end

  context 'when user is not logged in' do

    before do
      visit ticket_path(@ticket)
    end

    context 'and the user adds a comments without any data' do
      
      before do
        click_on 'Add comment'
        @ticket.reload
      end

      it 'should validate the lack of content and email' do
        expect(page).to have_content 'A comment cannot be empty.'
        expect(page).to have_content 'Your email is required.'
      end

      it 'should not save any comments' do
        expect(@ticket.comments.count).to eq 0
        expect(Comment.count).to eq 0
      end

    end

    context 'and the user adds a comment with content and email' do

      before do
        fill_in :ticket_comments_attributes_0_text, with: 'some stuff about this ticket'
        fill_in :ticket_comments_attributes_0_email, with: 'someemail@fortheticket.com'
        click_on 'Add comment'
        @ticket.reload
      end

      it 'should show the comment on the page' do
        expect(page).to have_content 'some stuff about this ticket'
      end

      it 'should add the comment to the ticket' do
        expect(@ticket.comments.count).to eq 1
        expect(@ticket.comments.first.text).to eq 'some stuff about this ticket'
      end

      it 'should add not logged in details to the comment' do
        expect(@ticket.comments.first.email).to eq 'someemail@fortheticket.com'
        expect(@ticket.comments.first.user).to be_nil
      end

      it 'should not notify the customer of a new comment' do
        expect(delivered_emails.second).to be_nil
      end

    end    

  end

  context 'when user is logged in' do
    
    before do
      @user = FactoryGirl.create(:user)
      signin(@user.email, @user.password)

      visit ticket_path(@ticket)
    end

    context 'and the user adds a comments without any content' do

      before do
        click_on 'Add comment'
        @ticket.reload
      end

      it 'should validate the lack of content' do
        expect(page).to have_content 'A comment cannot be empty.'
      end

      it 'should not save any comments' do
        expect(@ticket.comments.count).to eq 0
        expect(Comment.count).to eq 0
      end

    end

    context 'and the user adds a comment with content' do

      before do
        fill_in :ticket_comments_attributes_0_text, with: 'some stuff about this ticket'
        click_on 'Add comment'
        @ticket.reload
      end

      it 'should show the comment on the page' do
        expect(page).to have_content 'some stuff about this ticket'
      end

      it 'should add the comment to the ticket' do
        expect(@ticket.comments.count).to eq 1
        expect(@ticket.comments.first.text).to eq 'some stuff about this ticket'
      end

      it 'should add comment to the current user' do
        expect(@ticket.comments.first.user).to eq @user
      end

      it 'should notify the customer of a new comment' do
        expect(delivered_emails.second).to_not be_nil
        expect(delivered_emails.second.to.first).to eq 'someemail@fortheticket.com'
        expect(delivered_emails.second.subject.to_s).to include 'Your ticket has a new comment'
        expect(delivered_emails.second.body.to_s).to include ticket_path(@ticket)
        expect(delivered_emails.second.body.to_s).to include 'http://'
      end

    end

  end

end