require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user_response) { json_response }
  before(:each) do
    request.headers['Accept'] = 'application/vnd.marketplace.v1'
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    before(:each) do
      get :show, params: { id: user.id }, format: :json
    end

    it 'returns the info about reporter on a hash' do
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
        expect(user_response).to have_key('errors')
      end

      it 'renders the json errors on why the user could not be created' do
        expect(user_response['errors']['email']).to include "can't be blank"
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    let(:user) { create(:user) }
    context 'when is successfully updated' do
      before(:each) do
        patch :update, params: { id: user.id,
                                 user: { email: 'new@email.com' } }, format: :json
      end

      it 'renders the json representation of the updated user' do
        expect(user_response['email']).to eq 'new@email.com'
      end

      it { is_expected.to respond_with 200 }
    end

    context 'when is not created' do
      before(:each) do
        patch :update, params: { id: user.id,
                                 user: { email: 'bademail.com' } }, format: :json
      end

      it 'renders an error' do
        expect(user_response).to have_key('errors')
      end

      it 'renders the json errors on why the user could not be updated' do
        expect(user_response['errors']['email']).to include 'is invalid'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    before(:each) do
      delete :destroy, { id: user.id }, format: :json
    end

    it { is_expected.to respond_with 204 }
  end
end
