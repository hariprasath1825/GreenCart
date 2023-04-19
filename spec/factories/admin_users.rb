FactoryBot.define do
  factory :admin_user do
    email { "admin1@gmail.com" }
    encrypted_password { "123456" }
    reset_password_token { "123456" }
    reset_password_sent_at { "2023-04-12 12:09:50" }
    remember_created_at { "2023-04-12 12:09:50" }
  end
end
