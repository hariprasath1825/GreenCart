FactoryBot.define do
  factory :cartitem do
    cart_id {1}
    quantity { 2 }
    price { 100 }
    # product
  end
end
