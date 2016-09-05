require 'rails_helper'

class Authentication
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe '#current_user' do
    before(:each) do
      @user = create(:user)
      request.headers['Authorization'] = @user.auth_token
      allow(authentication).to receive(:request) { request }
      # authentication.stub(:request).and_return(request)
    end

    xit 'returns the user from the authorization header' do
      expect(authentication.current_user.auth_token).to eq @user.auth_token
    end
  end
end