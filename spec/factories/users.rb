FactoryBot.define do

  factory :user do

    sequence :email do |n|
      "test#{n}@gmail.com"
    end
    password {123456}
    password_confirmation {123456}

    role {"customer"}
    for_customer

    trait :for_customer do
      association :accountable , factory: :customer
      role  {"customer"}
      end

    trait :for_seller do
      association :accountable , factory: :seller
      role  { "seller" }
      end

  end


end
