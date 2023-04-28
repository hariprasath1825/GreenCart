require 'rails_helper'

RSpec.describe CartController do

  let(:admin) {create(:admin_user)}
  let(:customer_user) {create(:user ,  :for_customer , role: "customer")}
  let!(:cart) {create(:cart, customer_id: customer_user.accountable.id)}
  let(:seller_user) {create(:user ,  :for_seller )}
  let!(:product) {create(:product , seller: seller_user.accountable)}
  # let(:order) {create(:order , customer_id: customer_user.accountable.id)}
  let(:cartitem) {create(:cartitem , cart_id: cart.id, product_id: product.id)}

  describe "get/cart #index" do
    context "accessing index" do
      context "when user not signed_in" do
        it "redirects to login page" do
          get :index
          expect(response).to redirect_to new_user_session_path
        end
      end

      context "when signed_in as seller" do
        it "redirects to login page" do
          sign_in seller_user
          get :index
          expect(response).to redirect_to new_user_session_path
        end
      end

      context "when signed_in as customer" do
        it "redirects to login page" do
          sign_in customer_user
          get :index
          expect(response).to render_template :index
        end
      end
    end
  end

  describe "get/carts #new" do
    context "accessing new" do
      context "when user not signed_in" do
        it "redirects_to login page" do
          get :new
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as seller" do
        it "redirects_to login page" do
          sign_in seller_user
          get :new
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as customer" do
        it "redirects_to login page" do
          sign_in customer_user
          get :new , params:{product_id: product.id}
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "post/cart #create" do
    context "creating cartitem" do
      context "when user not signed_in" do
        it "redirects_to login page" do
          post :create , params:{ cartitem:{ product_id: product.id , quantity: 2} }
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as seller" do
        it "redirects_to login page" do
          sign_in seller_user
          post :create , params:{cartitem:{ product_id: product.id , quantity: 2}}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as customer and invalid params" do
        it "renders new page" do
          sign_in customer_user
          post :create , params:{cartitem:{ product_id: product.id , quantity: nil}}
          expect(response).to redirect_to(new_cart_path(product_id: product.id))
        end
      end

      context "when signed_in as customer and invalid params" do
        it "puts a fail notice " do
          sign_in customer_user
          post :create , params:{cartitem:{ product_id: product.id , quantity: nil}}
          expect(flash[:notice]).to eq("Quantity cannot be 0 !")
        end
      end

      context "when signed_in as customer and valid params" do
        it "redirects_to cart index page" do
          sign_in customer_user
          post :create , params:{cartitem:{ product_id: product.id , quantity: 2}}
          expect(response).to redirect_to(cart_index_path)
        end
      end

      context "when signed_in as customer and valid params" do
        it "puts a success notice " do
          sign_in customer_user
          post :create , params:{cartitem:{ product_id: product.id , quantity: 2}}
          expect(flash[:notice]).to eq("Product added to cart successfully !")
        end
      end
    end
  end

  describe "put/cart #edit" do
    context "accessing edit page" do
      context "when user not signed_in" do
        it "redirects_to login page" do
          put :edit , params:{id: cartitem.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as seller" do
        it "redirects_to login page" do
          sign_in seller_user
          put :edit , params:{id: cartitem.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as customer" do
        it "renders edit page" do
          sign_in customer_user
          put :edit , params:{id: cartitem.id}
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe "patch/cart #update" do
    context "updating cartitem" do
      context "when user not signed_in" do
        it "redirects_to login page" do
          put :update , params:{id: cartitem.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as seller" do
        it "redirects_to login page" do
          sign_in seller_user
          put :update , params:{id: cartitem.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as customer and valid params" do
        it "redirects to cart index page" do
          sign_in customer_user
          put :update , params:{id: cartitem.id , cartitem:{quantity: 2 }}
          expect(response).to redirect_to(cart_index_path)
        end
      end

      context "when signed_in as customer and valid params" do
        it "puts a success notice" do
          sign_in customer_user
          put :update , params:{id: cartitem.id , cartitem:{quantity: 2}}
          expect(flash[:notice]).to eq("Product updated successfully !")
        end
      end

    end
  end

end