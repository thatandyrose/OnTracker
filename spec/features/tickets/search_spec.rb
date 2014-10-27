feature 'Ticket search' do
  before do
    @ticket1 = FactoryGirl.create :ticket, body: 'this the first ticket', subject: 'hello', email: 'andy@mail.com'
    @ticket2 = FactoryGirl.create :ticket, body: 'this the second ticket', subject: 'goodbye', email: 'harry@mail.com'

    @user = FactoryGirl.create(:user)
    signin(@user.email, @user.password)
  end

  context 'when I visit the tickets page' do
    
    before do
      visit tickets_path
    end

    it 'should have a link to start searching' do
      expect(page).to have_selector "a[href='#{search_tickets_path}']"
    end
  end

  context 'when I search' do
    before do
      visit search_tickets_path
    end

    it 'should search by body' do
      fill_in :query, with: 'first'
      click_on 'Search'

      expect(page).to have_content 'hello'
      expect(all('.ticket-row').count).to eq 1
    end

    it 'should search by subject' do
      fill_in :query, with: 'goodbye'
      click_on 'Search'

      expect(page).to have_content 'goodbye'
      expect(all('.ticket-row').count).to eq 1
    end

    it 'should search by reference' do
      fill_in :query, with: @ticket2.slug
      click_on 'Search'

      expect(page).to have_content 'goodbye'
      expect(all('.ticket-row').count).to eq 1
    end

    it 'should search by email' do
      fill_in :query, with: 'harry'
      click_on 'Search'

      expect(page).to have_content 'goodbye'
      expect(all('.ticket-row').count).to eq 1
    end

    it 'should search for multiples' do
      fill_in :query, with: 'this the'
      click_on 'Search'

      expect(page).to have_content 'goodbye'
      expect(page).to have_content 'hello'
      
      expect(all('.ticket-row').count).to eq 2
    end

  end
end