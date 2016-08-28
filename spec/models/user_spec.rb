require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = build(:user)
    create(:user)
  end

  subject { @user }

  it 'is a valid user' do
    is_expected.to respond_to(:email)
    is_expected.to respond_to(:password)
    is_expected.to respond_to(:password_confirmation)
    is_expected.to respond_to(:auth_token)
    # is_expected.to be_valid
    is_expected.to validate_presence_of(:email)
    # is_expected.to validate_uniqueness_of(:email)
    is_expected.to validate_uniqueness_of(:auth_token)
    # is_expected.to validate_confirmation_of(:password)
    is_expected.to allow_value('wookie@chewy.com').for(:email)
  end

  describe '#generate_authentication_token!' do
    let(:token) { 'uniquetoken123' }
    it 'generates a unique token' do
      Devise.stub(:friendly_token).and_return(token)
      @user.generate_authentication_token!
      expect(@user.auth_token).to eq token
    end

    it 'generates another token when one has already been taken' do
      existing_user = create(:user, auth_token: token)
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to be nil
      expect(@user.auth_token).not_to eq existing_user.auth_token
    end
  end
end
