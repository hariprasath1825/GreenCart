FactoryBot.define do
  factory :product do
    name { "Apple" }
    price { 100 }
    description { "good product and healthy !" }
    available_quantity { 20 }
    category { "Fruits" }
    seller
  end
end
