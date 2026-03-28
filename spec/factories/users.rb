FactoryBot.define do
  factory :user do
    name  { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
    role  { "guest" }
    city  { Listing::CITIES.sample }

    trait :host do
      role          { "host" }
      host_approved { true }
      bio           { Faker::Lorem.sentence }
    end

    trait :admin do
      role { "admin" }
    end
  end
end
