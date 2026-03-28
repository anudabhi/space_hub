FactoryBot.define do
  sequence(:booking_day) { |n| n + 10 }

  factory :booking do
    association :listing
    association :user

    transient do
      day { generate(:booking_day) }
    end

    start_time    { day.days.from_now.change(hour: 10) }
    end_time      { day.days.from_now.change(hour: 12) }
    hours         { 2 }
    total_price   { listing&.price_per_hour.to_f * 2 }
    status        { "pending" }
    payment_gateway { "razorpay" }

    trait :confirmed  do status { "confirmed" } end
    trait :completed  do status { "completed" } end
    trait :cancelled  do status { "cancelled" } end
    trait :stripe     do payment_gateway { "stripe" } end
  end
end
