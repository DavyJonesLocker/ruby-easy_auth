FactoryGirl.define do
  factory :user do
    email      'test@example.com'
    identities { [TestIdentity.new] }
  end
end
