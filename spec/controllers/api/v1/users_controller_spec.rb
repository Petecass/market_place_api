require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) do
    request.headers['Accept'] = 'application/vnd.marketplace.v1'
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    before(:each) do
      get :show, params: { id: user.id }, format: :json
    end

    it 'returns the info about reporter on a hash' do
      user_response = JSON.parse(response.body, symbolize_name: true)
      expect(user_response['email']).to eq user.email
    end

    it { is_expected.to respond_with 200 }
  end
end
