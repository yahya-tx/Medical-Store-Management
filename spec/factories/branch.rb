FactoryBot.define do
  factory :branch do
    name { "MyBranch" }
    location { "MyLocation" }
    association :user
  end
end