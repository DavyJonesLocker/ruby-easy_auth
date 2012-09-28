FactoryGirl.define do
  factory :user do
    email                 'test@example.com'
    password              'password'
    password_confirmation 'password'
  end

  factory :password_identity do
    username              'test@example.com'
    password              'password'
    password_confirmation 'password'
  end
end
