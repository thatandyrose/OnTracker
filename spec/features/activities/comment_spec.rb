feature 'Comment activities' do

  before do
    @ticket = FactoryGirl.create :ticket
  end

  context 'when an admin is logged in' do

    before do
      @user = FactoryGirl.create(:user)
      signin(@user.email, @user.password)

      visit ticket_path(@ticket)
    end

    context 'and creates a new comment' do

      before do
        fill_in :ticket_comments_attributes_0_text, with: 'some stuff about this ticket'
        click_on 'Add comment'
      end

      it 'should create a new comment create activity' do
        expect(Activity.count).to eq 3
        expect(Activity.where(activity_type: :create).count).to eq 2
        expect(Activity.where(activity_type: :create).where('comment_id is not null').count).to eq 1
        
        expect(Activity.where(activity_type: :create).where(comment_id: Comment.first.id).first.ticket).to eq @ticket
        expect(Activity.where(activity_type: :create).where(comment_id: Comment.first.id).first.comment).to eq Comment.first
      end

      it 'should create a new status change activity' do
        expect(Activity.count).to eq 3
        expect(Activity.where(activity_type: :status_change).count).to eq 1
        
        expect(Activity.find_by_activity_type(:status_change).ticket).to eq @ticket
        
        expect(page).to have_content 'Test User changed the ticket status to Waiting For Customer Response'
      end

    end
  end

  context 'when an no one is logged in' do

    before do
      visit ticket_path(@ticket)
    end

    context 'and creates a new comment' do

      before do
        @ticket.update_attributes! status_key: 'on_hold'
        Activity.destroy_all

        fill_in :ticket_comments_attributes_0_text, with: 'some stuff about this ticket'
        fill_in :ticket_comments_attributes_0_email, with: 'someemail@fortheticket.com'
        click_on 'Add comment'
      end

      it 'should create a new comment create activity' do
        expect(Activity.count).to eq 2
        expect(Activity.where(activity_type: :create).count).to eq 1
        
        expect(Activity.where(comment_id: Comment.first.id).first.ticket).to eq @ticket
        expect(Activity.where(comment_id: Comment.first.id).first.comment).to eq Comment.first
      end

      it 'should create a new status change activity' do
        expect(Activity.count).to eq 2
        expect(Activity.where(activity_type: :status_change).count).to eq 1
        
        expect(Activity.find_by_activity_type(:status_change).ticket).to eq @ticket
        
        expect(page).to have_content 'someone changed the ticket status to Waiting For Staff Response'
      end

    end
  end

end