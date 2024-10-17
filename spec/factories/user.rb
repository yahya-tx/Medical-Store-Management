FactoryBot.define do
    factory :user do
      name { "MyName" }
      sequence(:email) { |n| "user#{n}@example.com" }
      sequence(:phone_number) { |n| "123456789#{n}" }
      password {"password"}
    end
end