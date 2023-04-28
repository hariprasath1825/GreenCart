require 'rails_helper'


RSpec.describe Api::ReviewsController , type: :request do
# describe "Api::ReviewController" do

  let(:customer_user) { create(:user , :for_customer) }
  let(:seller) {create(:seller )}
  let!(:product) {create(:product ,seller_id: seller.id )}
  let!(:cart) {create(:cart, customer_id: customer_user.accountable.id)}
  let(:cartitem) {create(:cartitem , cart_id: cart.id , product_id: product.id)}
  let(:order) {create(:order , customer_id: customer_user.accountable.id)}
  let!(:orderitem) {create(:orderitem , order_id: order.id , product_id: product.id)}
  let(:customer_token) {create(:doorkeeper_access_token , resource_owner_id: customer_user.id)}
  let(:review) {create(:review , product_id: product.id)}
  let(:seller_user) {create(:user ,:for_seller)}
  let(:seller_token) {create(:doorkeeper_access_token , resource_owner_id: seller_user.id)}


  describe "post/reviews" do
    context "create without authentication" do
      it "returns status 401" do
        post "/api/carts/#{cart.id}/orders/#{order.id}/reviews"
        expect(response).to have_http_status(401)
      end
      end

    context "create with false authentication and valid params" do
      it "returns status 200" do
        post "/api/carts/#{cart.id}/orders/#{order.id}/reviews" , params: {access_token: seller_token.token , review:{rating: 5, comment: "Good product..." , product_id: product.id}}
        expect(response).to have_http_status(401)
      end
    end

    context "create with customer authentication and valid params" do
      it "returns status 200" do
        post "/api/carts/#{cart.id}/orders/#{order.id}/reviews" , params: {access_token: customer_token.token , review:{rating: 5, comment: "Good product..." , product_id: product.id}}
        expect(response).to have_http_status(200)
      end
      end


    context "create with authentication and invalid params" do
      it "returns status 422" do
        post "/api/carts/#{cart.id}/orders/#{order.id}/reviews" , params: {access_token: customer_token.token , review:{rating: nil, comment: "Good product..." , product_id: product.id}}
        expect(response).to have_http_status(422)
      end
    end

    context "create with authentication and invalid cart id " do
      it "returns status 422" do
        post "/api/carts/#{cart.id+100}/orders/#{order.id}/reviews" , params: {access_token: customer_token.token , review:{rating: 5, comment: "Good product..." , product_id: product.id}}
        expect(response).to have_http_status(401)
      end
      end

    context "create with authentication and invalid order id " do
      it "returns status 422" do
        post "/api/carts/#{cart.id}/orders/#{order.id+100}/reviews" , params: {access_token: customer_token.token , review:{rating: nil, comment: "Good product..." , product_id: product.id}}
        expect(response).to have_http_status(404)
      end
    end

  end

end