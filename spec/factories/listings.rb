FactoryBot.define do
  factory :listing do
    association :user, factory: [ :user, :host ]
    title         { Faker::Company.name + " Studio" }
    description   { Faker::Lorem.paragraphs(number: 2).join("\n\n") }
    category      { Listing::CATEGORIES.sample }
    city          { Listing::CITIES.sample }
    address       { Faker::Address.street_address }
    price_per_hour { rand(500..5000) }
    capacity      { rand(2..50) }
    amenities     { "WiFi, AC, Parking" }
    status        { "active" }

    trait :wellness  do category { "wellness" } end
    trait :creative  do category { "creative" } end
    trait :events    do category { "events" }   end
    trait :draft     do status { "draft" }      end
    trait :inactive  do status { "inactive" }   end
  end
end
