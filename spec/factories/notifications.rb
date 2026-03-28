FactoryBot.define do
  factory :notification do
    association :user
    message { Faker::Lorem.sentence }
    kind    { Notification::KINDS.sample }
    link    { "/guest/bookings/#{rand(1..100)}" }
    read    { false }

    trait :read do
      read { true }
    end
  end
end
