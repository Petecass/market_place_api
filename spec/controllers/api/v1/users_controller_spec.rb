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
      user_response = JSON.parse(response.body)
      expect(user_response['email']).to eq user.email
    end

    it { is_expected.to respond_with 200 }
  end

  describe 'POST #Create' do
    context 'when is successfully created' do
      let(:user_attributes) { attributes_for(:user) }
      before(:each) do
        post :create, params: { user: user_attributes }, format: :json
      end

      it 'renders the json representation for the user record just created' do
        user_response = JSON.parse(response.body, symobolize_names: true)
        expect(user_response['email']).to eq user_attributes[:email]
      end

      it { is_expected.to respond_with 201 }
    end

    context 'when is successfully created' do
      let(:invalid_attributes) { attributes_for(:user, email: '') }
      before(:each) do
        post :create, params: { user: invalid_attributes }, format: :json
      end

      it 'renders an error JSON' do
        user_response = JSON.parse(response.body, symobolize_names: true)
        expect(user_response).to have_key('errors')
      end

      it 'renders the json errors on why the user could not be created' do
        user_response = JSON.parse(response.body, symobolize_names: true)
        expect(user_response['errors']['email']).to include "can't be blank"
      end

      it { is_expected.to respond_with 422 }
    end
  end
end
