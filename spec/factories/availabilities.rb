FactoryBot.define do
  factory :availability do
    association :listing
    date        { 7.days.from_now.to_date }
    start_time  { "09:00" }
    end_time    { "17:00" }
    is_available { true }
  end
end
