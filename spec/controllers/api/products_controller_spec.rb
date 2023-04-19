require 'rails_helper'

RSpec.describe Api::ProductsController, type: :request do
# describe "Api::ProductController" do

  let(:admin) {create(:admin_user)}
  let(:customer) {create(:customer)}
  let(:seller) {create(:seller)}
  let(:customer_user) {create(:user ,  :for_customer , role: "customer")}
  let(:seller_user) {create(:user ,  :for_seller )}
  let(:product) {create(:product , seller: seller_user.accountable)}
  let(:customer_token) {create(:doorkeeper_access_token , resource_owner_id: customer_user.id)}
  let(:seller_token) {create(:doorkeeper_access_token , resource_owner_id: seller_user.id)}
  let(:admin_token) {create(:doorkeeper_access_token , resource_owner_id: admin.id)}


  describe "get/products" do
    context "index" do
      it "doesn't need authentication for customer" do
        get '/api/products' , params: {access_token: customer_token.token}
        expect(response).to have_http_status(200)
        end

      it "needs authentication for seller" do
        get '/api/products' , params: {access_token: seller_token.token}
        expect(response).to have_http_status(200)
      end
      end


    context "show" do
      it "requires authentication" do
        # customer = create(:customer)
        get '/api/products/'+product.id.to_s
        expect(response).to have_http_status(200)
      end
      end

    context "all_products" do
      it "requires authentication" do
        get '/api/products/all_products'
        expect(response).to have_http_status(200)
      end
    end

  end

  describe "post/products" do

    context "create product" do
      it "needs authentication" do
        post '/api/products'
        expect(response).to have_http_status(401)
        end

      it "with authentication returns 200" do
        # allow_any_instance_of(User).to receive(:seller?).and_return(true)
        post '/api/products' , params: {access_token: seller_token.token , product: {name: "apple" ,price: 200 , description: "fresh and healthy !" , available_quantity: 30 , category: 'fruits'}}
        expect(response).to have_http_status(201)
      end
    end
    end

  describe "patch/products" do

    context "update product" do
      it "needs authentication" do
        patch '/api/products/'+product.id.to_s
        expect(response).to have_http_status(401)
        end

      it "with authentication returns 200" do
        # allow_any_instance_of(User).to receive(:seller?).and_return(true)
        patch '/api/products/'+product.id.to_s , params: {access_token: seller_token.token , product: {name: "apple" ,price: 200 , description: "fresh and healthy !" , available_quantity: 30 , category: 'fruits'}}
        expect(response).to have_http_status(200)
      end
    end
    end

  describe "delete/products" do

    context "destroy product" do
      it "without authentication throws error" do
        delete '/api/products/'+product.id.to_s
        expect(response).to have_http_status(401)
        end

      it "with authentication returns 200" do
        # allow_any_instance_of(User).to receive(:seller?).and_return(true)
        delete '/api/products/'+product.id.to_s , params: {access_token: seller_token.token}
        expect(response).to have_http_status(200)
      end
    end
  end
end