require 'rails_helper'

RSpec.describe Api::OrdersController , type: :request do
  # describe "Api::OrdersController"  do

  let(:customer_user) { create(:user , :for_customer) }
  let(:seller) {create(:seller )}
  let!(:product) {create(:product ,seller_id: seller.id )}
  let!(:cart) {create(:cart, customer_id: customer_user.accountable.id)}
  let!(:cartitem) {create(:cartitem , cart_id: cart.id , product_id: product.id)}
  let(:order) {create(:order , customer_id: customer_user.accountable.id)}
  let!(:orderitem) {create(:orderitem , order_id: order.id , product_id: product.id)}
  let(:customer_token) {create(:doorkeeper_access_token , resource_owner_id: customer_user.id)}
  let(:review) {create(:review , product_id: product.id)}
  let(:seller_user) {create(:user ,:for_seller)}
  let(:seller_token) {create(:doorkeeper_access_token , resource_owner_id: seller_user.id)}

  describe 'get/orders' do
    context 'show without authorization' do
      it 'returns status 401' do
        get "/api/carts/#{cart.id}/orders/#{order.id}"
        expect(response).to have_http_status(401)
      end
    end

    context 'show with seller authorization' do
      it 'returns status 401' do
        get "/api/carts/#{cart.id}/orders/#{order.id}" , params: {access_token: seller_token.token}
        expect(response).to have_http_status(401)
      end
    end

    context 'show with customer authorization and valid id' do
      it 'returns status 200' do
        get "/api/carts/#{cart.id}/orders/#{order.id}" , params: {access_token: customer_token.token}
        expect(response).to have_http_status(200)
      end
    end

    context 'show with customer authorization and invalid cart_id' do
      it 'returns status 401' do
        get "/api/carts/#{cart.id+100}/orders/#{order.id}" , params: {access_token: seller_token.token}
        expect(response).to have_http_status(401)
      end
    end

    context 'show with customer authorization and invalid order_id' do
      it 'returns status 401' do
        get "/api/carts/#{cart.id}/orders/#{order.id+100}" , params: {access_token: seller_token.token}
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "post/orders" do
    context "create without authentication" do
      it "returns status 410" do
        post "/api/carts/#{cart.id}/orders"
        expect(response).to have_http_status(401)
      end
    end

    context "create with authentication" do
      it "returns status 200" do
        post "/api/carts/#{cart.id}/orders" , params: {access_token: customer_token.token}
        expect(response).to have_http_status(200)
      end
    end

    context "create with seller authentication" do
      it "returns status 401" do
        post "/api/carts/#{cart.id}/orders" , params: {access_token: seller_token.token}
        expect(response).to have_http_status(401)
      end
    end

    context "create with false authentication" do
      it "returns status 200" do
        post "/api/carts/#{cart.id}/orders" , params: {access_token: customer_token.token}
        expect(response).to have_http_status(200)
      end
    end

  end

end