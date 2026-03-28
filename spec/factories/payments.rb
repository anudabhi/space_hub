FactoryBot.define do
  factory :payment do
    association :booking

    gateway    { "razorpay" }
    order_id   { "order_#{SecureRandom.hex(8)}" }
    payment_id { "pay_#{SecureRandom.hex(8)}" }
    amount     { booking&.total_price || 1000 }
    currency   { "INR" }
    status     { "captured" }

    trait :stripe  do gateway { "stripe" } end
    trait :failed  do status { "failed" }  end
  end
end
