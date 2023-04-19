FactoryBot.define do
  factory :order do
    total_price { 1000 }
    payment_status { "true" }
    order_date { "2023-04-12" }
    # customer

  end
end
