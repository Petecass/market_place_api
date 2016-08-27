require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = build(:user) }

  subject { @user }

  it 'is a valid user' do
    is_expected.to respond_to(:email)
    is_expected.to respond_to(:password)
    is_expected.to respond_to(:password_confirmation)
    is_expected.to be_valid
  end
end
