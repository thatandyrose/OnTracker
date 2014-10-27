describe Api::V1::DepartmentsController do
  render_views

  context 'list departments' do
    before do
      get :index

      @departments_response = JSON.parse(response.body)
    end

    it 'should return a 200' do
      expect(response.code). to eq '200'
    end

    it 'should return departments' do
      expect(@departments_response.count).to eq 2
      expect(@departments_response[0]).to eq 'Sales'
      expect(@departments_response[1]).to eq 'Marketing'
    end

  end
end