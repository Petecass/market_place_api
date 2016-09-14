FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password 'vivalavida'
    password_confirmation 'vivalavida'
    auth_token { Devise.friendly_token }
  end
end
