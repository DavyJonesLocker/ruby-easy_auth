FactoryGirl.define do
  factory :user do
    email                 'test@example.com'
    password              'password'
    password_confirmation 'password'
  end

  factory :identity, :class => EasyAuth::Identity do
    username              'test@example.com'
    password              'password'
    password_confirmation 'password'
  end
end
