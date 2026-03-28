FactoryBot.define do
  factory :gateway_config do
    association :user, factory: [:user, :host]
    gateway    { "razorpay" }
    key_id     { "rzp_test_#{SecureRandom.hex(8)}" }
    key_secret { "secret_#{SecureRandom.hex(16)}" }
    active     { true }

    trait :stripe do
      gateway { "stripe" }
      key_id  { "pk_test_#{SecureRandom.hex(8)}" }
    end

    trait :inactive do
      active { false }
    end
  end
end
