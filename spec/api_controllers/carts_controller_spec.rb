require 'rails_helper'

RSpec.describe Api::CartsController , type: :request do

  let(:customer_user) {create(:user , :for_customer )}
  let(:seller_user) {create(:user , :for_seller )}
  let(:seller) {create(:seller )}
  let(:product) {create(:product ,seller_id: seller.id )}
  let!(:cart) {create(:cart, customer_id: customer_user.accountable.id)}
  let(:cartitem) {create(:cartitem , cart_id: cart.id , product_id: product.id)}
  let(:customer_token) {create(:doorkeeper_access_token , resource_owner_id: customer_user.id)}
  let(:seller_token) {create(:doorkeeper_access_token , resource_owner_id: seller_user.id)}


  describe "get/carts #index" do
    context "index without authentication" do
      it "returns status 401" do
        get '/api/carts'
        expect(response).to have_http_status(401)
      end
    end

    context "index with seller authentication" do
      it "returns status 401" do
        # allow_any_instance_of(User).to receive(:customer?).and_return(true)
        get '/api/carts' , params: {access_token: seller_token.token}
        expect(response).to have_http_status(401)
      end
    end

    context "index with customer authentication" do
      it "returns status 200" do
        # allow_any_instance_of(User).to receive(:customer?).and_return(true)
        get '/api/carts' , params: {access_token: customer_token.token}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "post/carts #create" do
    context "create without authentication" do
      it "returns status 401" do
        post '/api/carts'
        expect(response).to have_http_status(401)
      end
    end

    context "create with seller authentication" do
      it "returns status 401" do
        # allow_any_instance_of(User).to receive(:customer?).and_return(true)
        post '/api/carts' , params: {access_token: seller_token.token , cartitem: {product_id: product.id , quantity: 3}}
        expect(response).to have_http_status(401)
      end
    end

    context "create with customer authentication" do
      context "with valid params" do
        it "returns status 200" do
          # allow_any_instance_of(User).to receive(:customer?).and_return(true)
          post '/api/carts' , params: {access_token: customer_token.token , cartitem: {product_id: product.id , quantity: 3}}
          expect(response).to have_http_status(200)
        end
      end

      context "with invalid params" do
        it "returns status 404" do
          # allow_any_instance_of(User).to receive(:customer?).and_return(true)
          post '/api/carts' , params: {access_token: customer_token.token , cartitem: {product_id: 1000 , quantity: 3}}
          expect(response).to have_http_status(404)
        end
      end
    end

  end

  describe "patch/carts #update" do
    context "update without authentication" do
      it "returns status 401" do
        put "/api/carts/#{cart.id}"
        expect(response).to have_http_status(401)
      end
    end

    context "update with seller authentication" do
      it "returns status 401" do
        put "/api/carts/#{cart.id}" , params: {access_token: seller_token.token , cartitem:{ id: cartitem.id , quantity: 4}}
        expect(response).to have_http_status(401)
      end
    end

    context "update with customer authentication" do
      context "with valid cart_id and cartitem_id" do

        it "returns status 200" do
          put "/api/carts/#{cart.id}" , params: {access_token: customer_token.token, cartitem:{ id: cartitem.id , quantity: 4}}
          expect(response).to have_http_status(200)
        end
      end

      context "with invalid cart_id" do
        it "returns status 404" do
          put "/api/carts/#{1000}" , params: {access_token: customer_token.token, cartitem:{ id: cartitem.id , quantity: 4}}
          expect(response).to have_http_status(404)
        end
      end

      context "with invalid cartitem_id" do
        it "returns status 404" do
          put "/api/carts/#{cart.id}" , params: {access_token: customer_token.token, cartitem:{ id: 1000 , quantity: 4}}
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe "delete/carts #destroy" do
    context "delete without authentication" do
      it "returns status 401" do
        delete "/api/carts/#{cart.id}" , params:{ cartitem:{id: cartitem.id}}
        expect(response).to have_http_status(401)
      end
    end

    context "delete with seller authentication" do
      it "returns status 401" do
        delete "/api/carts/#{cart.id}" , params:{ access_token: seller_token.token, cartitem:{id: cartitem.id}}
        expect(response).to have_http_status(401)
      end
    end

    context "delete with customer authentication" do
      context "with valid params" do
        it "returns status 200" do
          delete "/api/carts/#{cart.id}" , params:{ access_token: customer_token.token, cartitem:{id: cartitem.id}}
          expect(response).to have_http_status(200)
        end
      end

      context "with invalid params" do
        it "returns status 404" do
          delete "/api/carts/#{cart.id}" , params:{ access_token: customer_token.token, cartitem:{id: 1000}}
          expect(response).to have_http_status(404)
        end
      end
    end
  end

end
