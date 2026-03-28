FactoryBot.define do
  factory :review do
    association :booking, :completed
    association :listing
    association :user

    rating { rand(3..5) }
    body   { Faker::Lorem.paragraph(sentence_count: 3) }
  end
end
