FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password 'vivalavida'
    password_confirmation 'vivalavida'
  end
end
