FactoryGirl.define do
  factory :user do
    email                 'test@example.com'
    password              'password'
    password_confirmation 'password'
  end

  factory :identity do
    username              'test@example.com'
    password              'password'
    password_confirmation 'password'
  end
end
