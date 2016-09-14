require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe 'GET #show' do
    before(:each) do
      @product = create(:product)
      get :show, params: { id: @product.id }
    end

    it 'returns the informaiton about a reporter on a hash' do
      product_response = json_response
      expect(product_response['title']).to eq @product.title
    end

    it { is_expected.to respond_with 200 }
  end
  describe 'GET #index' do
    before(:each) do
      4.times { create(:product) }
      get :index
    end

    it 'returns 4 records from the database' do
      product_response = json_response

      expect(product_response.count).to eq 4
    end

    it { is_expected.to respond_with 200 }
  end

  describe 'POST #create' do
    context 'when product is successfully created' do
      before(:each) do
        user = create(:user)
        @product_attributes = attributes_for(:product)
        api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @product_attributes }
      end

      it 'renders the json representation of the product just created' do
        expect(json_response['title']).to eq @product_attributes[:title]
      end

      it { is_expected.to respond_with 201 }
    end

    context 'when product is not created' do
      before(:each) do
        user = create(:user)
        @invalid_product_attributes = { title: 'Chocolate', price: 'two dollars'}
        api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @invalid_product_attributes }
      end

      it 'renders the json representation of the product just created' do
        expect(json_response['errors']['price']).to include 'is not a number'
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe 'PUTS/PATCH #update' do
    before(:each) do
      @user = create(:user)
      @product = create(:product, user: @user)
      api_authorization_header @user.auth_token
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, params: { user_id: @user.id, id: @product.id,
                                 product: { title: 'Some new title' } }
      end

      it 'renders the json representation for the updated user' do
        expect(json_response['title']).to eq 'Some new title'
      end

      it { is_expected.to respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, params: { user_id: @user.id, id: @product.id,
                                 product: { price: 'two hundred dollars' } }
      end

      it 'renders an error JSON' do
        expect(json_response).to have_key('errors')
      end

      it 'renders the json errors on why the user could not be updated' do
        expect(json_response['errors']['price']).to include 'is not a number'
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = create(:user)
      @product = create(:product, user: @user)
      api_authorization_header @user.auth_token
      delete :destroy, params: { user_id: @user.id, id: @product.id }
    end

    it { is_expected.to respond_with 204 }
  end
end
