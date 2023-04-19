require 'rails_helper'

RSpec.describe Api::CartsController , type: :request do
# describe "Api::CartsController" do

  let(:customer_user) {create(:user , :for_customer , role: "customer")}
  let(:seller) {create(:seller )}
  let(:product) {create(:product ,seller_id: seller.id )}
  let!(:cart) {create(:cart, customer_id: customer_user.accountable.id)}
  let(:cartitem) {create(:cartitem , cart_id: cart.id , product_id: product.id)}
  let(:customer_token) {create(:doorkeeper_access_token , resource_owner_id: customer_user.id)}


  describe "get/carts" do
    context "index without authentication" do
      it "returns status 401" do
        get '/api/carts'
        expect(response).to have_http_status(401)
      end
    end

    context "index with authentication" do
      it "returns status 200" do
        # allow_any_instance_of(User).to receive(:customer?).and_return(true)
        get '/api/carts' , params: {access_token: customer_token.token}
        expect(response).to have_http_status(200)
      end
    end
  end

    describe "post/carts" do
      context "create without authentication" do
        it "returns status 401" do
          post '/api/carts'
          expect(response).to have_http_status(401)
        end
      end

      context "create with authentication" do
        it "returns status 200" do
          # allow_any_instance_of(User).to receive(:customer?).and_return(true)
          post '/api/carts' , params: {access_token: customer_token.token , cartitem: {product_id: product.id , quantity: 3}}
          expect(response).to have_http_status(200)
        end
        end

    end

    describe "patch/carts" do
      context "update without authentication" do
        it "returns status 401" do
          patch '/api/carts/'+cart.id.to_s
          expect(response).to have_http_status(401)
        end
        end

      context "update authentication" do
        it "returns status 200" do
          patch '/api/carts/'+cart.id.to_s , params: {access_token: customer_token.token , cartitem:{ id: cartitem.id , quantity: 4}}
          expect(response).to have_http_status(200)
        end
      end
      end

    describe "delete/carts" do
      context "delete without authentication" do
        it "returns status 401" do
          delete '/api/carts/'+cart.id.to_s
          expect(response).to have_http_status(401)
        end
        end
    end

end