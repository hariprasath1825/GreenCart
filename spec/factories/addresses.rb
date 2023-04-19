FactoryBot.define do
  factory :address do
    door_no { "123" }
    street { "raj nagar" }
    district { "Coimbatore" }
    state { "Tamil Nadu" }
    pincode { 654321 }
    for_customer

    trait :for_customer do
      association :addressable , factory: :customer
      end

    trait :for_seller do
      association :addressable , factory: :seller
    end

  end
end
