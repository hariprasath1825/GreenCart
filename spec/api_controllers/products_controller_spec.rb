require 'rails_helper'

RSpec.describe Api::ProductsController, type: :request do

  let(:admin) {create(:admin_user)}
  let(:customer) {create(:customer)}
  let(:seller) {create(:seller)}
  let(:customer_user) {create(:user ,  :for_customer , role: "customer")}
  let(:seller_user) {create(:user ,  :for_seller )}
  let(:invalid_seller_user) {create(:user ,  :for_seller )}
  let(:product) {create(:product , seller: seller_user.accountable)}
  let(:customer_token) {create(:doorkeeper_access_token , resource_owner_id: customer_user.id)}
  let(:seller_token) {create(:doorkeeper_access_token , resource_owner_id: seller_user.id)}
  let(:invalid_seller_token) {create(:doorkeeper_access_token , resource_owner_id: invalid_seller_user.id)}
  let(:admin_token) {create(:doorkeeper_access_token , resource_owner_id: admin.id)}


  describe "get/products #index" do
    context "when user not signed_in" do
      it "returns status 401" do
        get '/api/products'
        expect(response).to have_http_status(401)
      end
    end

    context "when customer signed_in" do
      it "returns status 200" do
        get '/api/products' , params: {access_token: customer_token.token}
        expect(response).to have_http_status(200)
      end
    end

    context "when seller signed_in" do
      it "returns status 200" do
        get '/api/products' , params: {access_token: seller_token.token}
        expect(response).to have_http_status(200)
      end
    end
  end


  describe "get/products #show" do

    context "when user not signed_in " do
      it "returns status 401" do
        get '/api/products/'+product.id.to_s
        expect(response).to have_http_status(401)
      end
    end

    context "when customer signed_in with valid params" do
      it "returns status 200" do
        get '/api/products/'+product.id.to_s , params:{access_token: customer_token.token}
        expect(response).to have_http_status(200)
      end
    end

    context "when customer signed with invalid params" do
      it "returns status 404" do
        get '/api/products/0' , params:{access_token: customer_token.token}
        expect(response).to have_http_status(404)
      end
    end

    context "when valid seller signed with invalid params" do
      it "returns status 404" do
        get '/api/products/0' , params:{access_token: seller_token.token}
        expect(response).to have_http_status(404)
      end
    end

    context "when valid seller signed with valid params" do
      it "returns status 200" do
        get '/api/products/'+product.id.to_s , params:{access_token: seller_token.token}
        expect(response).to have_http_status(200)
      end
    end

    context "when invalid seller signed with valid params" do
      it "returns status 403" do
        get '/api/products/'+product.id.to_s , params:{access_token: invalid_seller_token.token}
        expect(response).to have_http_status(403)
      end
    end
  end


  describe "post/products #create" do
    context "creating product" do
      context "when user not signed_in"  do
        it "returns status 401" do
          post '/api/products'
          expect(response).to have_http_status(401)
        end
      end

      context "when customer signed_in"  do
        it "returns status 401" do
          post '/api/products' , params: {access_token: customer_token.token , product: {name: "apple" ,price: 200 , description: "fresh and healthy !" , available_quantity: 30 , category: 'fruits'}}
          expect(response).to have_http_status(401)
        end
      end

      context "when seller signed_in with valid params"  do
        it "returns status 201" do
          post '/api/products' , params: {access_token: seller_token.token , product: {name: "apple" ,price: 200 , description: "fresh and healthy !" , available_quantity: 30 , category: 'fruits'}}
          expect(response).to have_http_status(201)
        end
      end

      context "when seller signed_in with invalid params"  do
        it "returns status 422" do
          post '/api/products' , params: {access_token: seller_token.token , product: {name: "apple" ,price: nil , description: "fresh and healthy !" , available_quantity: 30 , category: 'fruits'}}
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  describe "patch/products #update" do

    context "updating product" do
      context "when user not signed_id" do
        it "returns status 401" do
          patch '/api/products/'+product.id.to_s
          expect(response).to have_http_status(401)
        end

        context "when customer signed_id" do
          it "returns status 401" do
            patch '/api/products/'+product.id.to_s , params: {access_token: customer_token.token , product: {name: "apple" ,price: 200 , description: "fresh and healthy !" , available_quantity: 30 , category: 'fruits'}}
            expect(response).to have_http_status(401)
          end
        end

        context "when seller signed_id with valid params" do
          it "returns status 200" do
            patch '/api/products/'+product.id.to_s , params: {access_token: seller_token.token , product: {name: "apple" ,price: 200 , description: "fresh and healthy !" , available_quantity: 30 , category: 'fruits'}}
            expect(response).to have_http_status(200)
          end
        end

        context "when seller signed_id with invalid params" do
          it "returns status 422" do
            patch '/api/products/'+product.id.to_s , params: {access_token: seller_token.token , product: {name: "apple" ,price: nil , description: "fresh and healthy !" , available_quantity: 30 , category: 'fruits'}}
            expect(response).to have_http_status(422)
          end
        end
      end
    end
  end

  describe "delete/products #destroy" do
    context "deleting product" do

      context "when user not signed_in" do
        it "returns status 401" do
          delete '/api/products/'+product.id.to_s
          expect(response).to have_http_status(401)
        end
      end

      context "when customer signed_in" do
        it "returns status 401" do
          delete '/api/products/'+product.id.to_s , params: { access_token: customer_token.token }
          expect(response).to have_http_status(401)
        end
      end

      context "when invalid seller signed_in" do
        it "returns status 401" do
          delete '/api/products/'+product.id.to_s , params: {access_token: invalid_seller_token.token }
          expect(response).to have_http_status(401)
        end
      end

      context "when valid seller signed_in" do
        it "returns status 200" do
          delete '/api/products/'+product.id.to_s , params: {access_token: seller_token.token }
          expect(response).to have_http_status(200)
        end
      end

    end
  end

  describe "custom action" do
    context "all_products" do
      it "requires authentication" do
        get '/api/products/all_products' , params: {access_token: customer_token.token}
        expect(response).to have_http_status(200)
      end
    end
  end
end
