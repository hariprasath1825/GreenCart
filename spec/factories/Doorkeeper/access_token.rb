FactoryBot.define do
  factory :doorkeeper_access_token , class: 'Doorkeeper::AccessToken' do
    expires_in{4000}
    scopes{""}
  end
end