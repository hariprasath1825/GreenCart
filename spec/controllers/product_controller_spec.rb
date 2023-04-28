require 'rails_helper'

RSpec.describe ProductController  do

  let(:admin) {create(:admin_user)}
  let(:customer) {create(:customer)}
  let(:seller) {create(:seller)}
  let(:customer_user) {create(:user ,  :for_customer , role: "customer")}
  let(:seller_user) {create(:user ,  :for_seller )}
  let(:product) {create(:product , seller: seller_user.accountable)}


  describe "get/products #index " do
    context "when user not signed in" do
      it "redirects to login page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user signed in as customer" do
      it "shows lists of products" do
        sign_in customer_user
        get :index
        expect(response).to render_template :index
      end
    end

    context "when user signed in as seller" do
      it "shows lists of products" do
        sign_in seller_user
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe "get/product #show " do
    context "when user not signed in" do
      it "redirects to login page" do
        get :show, params:{id: product.id}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user signed in as customer" do
      it "shows product details" do
        sign_in customer_user
        get :show, params:{id: product.id}
        expect(response).to render_template :show
      end
    end

    context "when user signed in as seller" do
      it "shows product details" do
        sign_in seller_user
        get :show , params:{id: product.id}
        expect(response).to render_template :show
      end
    end
  end

  describe "post/product #new " do
    context "when user not signed_in" do
      it "redirects to login page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user signed_in as customer" do
      it "redirects to login page" do
        sign_in customer_user
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user signed_in as seller" do
      it "renders new page" do
        sign_in seller_user
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe "post/product #create" do
    context "creating a product" do

      context "when user not signed_in" do
        it "redirects to login page" do
          get :create
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when user signed_in as customer" do
        it "redirects to login page" do
          sign_in customer_user
          get :create
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when user signed_in as seller with valid params" do
        it "creates new product" do
          sign_in seller_user
          get :create  , params:{product:{name: "apple", price: 100 , description: "Fresh and tasty" , available_quantity: 20 , category: "fruits"}}
          expect(flash[:notice]).to eq("Product saved successfully !")
        end
      end

      context "when user signed_in as seller with invalid params" do
        it "renders new page" do
          sign_in seller_user
          get :create  , params:{product:{name: "apple", price: nil , description: "Fresh and tasty" , available_quantity: 20 , category: "fruits"}}
          expect(response).to render_template :new
        end
      end

      context "when user signed_in as seller with invalid params" do
        it "fails to create new product" do
          sign_in seller_user
          get :create  , params:{product:{name: "apple", price: nil , description: "Fresh and tasty" , available_quantity: 20 , category: "fruits"}}
          expect(flash[:notice]).to eq("Failed to save new product !")
        end
      end
    end
  end

  describe "put/product #edit" do
    context "editing a product" do
      context "when user not signed_in" do
        it "redirects to login page" do
          get :edit , params:{id: product.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when user signed_in as customer" do
        it "redirects to login page" do
          get :edit , params:{id: product.id}
          sign_in customer_user
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when user signed_in as seller" do
        it "renders edit page" do
          sign_in seller_user
          get :edit , params:{id: product.id}
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe "patch/product #update" do
    context "updating a product" do

      context "when user not signed_in" do
        it "redirects to login page" do
          get :update , params:{id: product.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when user signed_in as customer" do
        it "redirects to login page" do
          sign_in customer_user
          get :update , params:{id: product.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when user signed_in as seller with valid params" do
        it "updates product" do
          sign_in seller_user
          get :update  , params:{id: product.id, product:{name: "apple", price: 100 , description: "Fresh and tasty" , available_quantity: 20 , category: "fruits"}}
          expect(flash[:notice]).to eq("Successfully updated the product !")
        end
      end

      context "when user signed_in as seller with invalid params" do
        it "renders edit page" do
          sign_in seller_user
          get :update  , params:{id: product.id, product:{name: "apple", price: nil , description: "Fresh and tasty" , available_quantity: 20 , category: "fruits"}}
          expect(response).to render_template :edit
        end
      end

      context "when user signed_in as seller with invalid params" do
        it "fails to update product" do
          sign_in seller_user
          get :update  , params:{id: product.id , product:{name: "apple", price: nil , description: "Fresh and tasty" , available_quantity: 20 , category: "fruits"}}
          expect(flash[:notice]).to eq("Failed to update product !")
        end
      end
    end
  end

  describe "delete/product #destroy" do
    context "deleting a product" do

      context "when user not signed_in" do
        it "redirects to login page" do
          get :destroy , params:{id: product.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when user signed_in as customer" do
        it "redirects to login page" do
          sign_in customer_user
          get :destroy , params:{id: product.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when user signed_in as seller" do
        it "redirects to products index" do
          sign_in seller_user
          get :destroy , params:{id: product.id}
          expect(response).to redirect_to(product_index_path)
        end
      end

      context "when user signed_in as seller" do
        it "deletes the product" do
          sign_in seller_user
          get :destroy , params:{id: product.id}
          expect(flash[:notice]).to eq("Product deleted successfully !")
        end
      end
    end
  end

end
