require 'rails_helper'

RSpec.describe OrderController , type: :controller do

  let(:admin) {create(:admin_user)}
  let(:customer_user) {create(:user ,  :for_customer , role: "customer")}
  let(:cart) {create(:cart, customer: customer_user.accountable)}
  let(:seller_user) {create(:user ,  :for_seller )}
  let(:product) {create(:product , seller: seller_user.accountable)}
  let(:order) {create(:order , customer_id: customer_user.accountable.id)}
  let(:orderitem) {create(:orderitem , order_id: order.id, product_id: product.id)}

  describe "get/orders #show" do
    context "accessing show" do
      context "when user not signed_in" do
        it "redirects_to login page" do
          get :show , params:{id: order.id , cart_id: cart.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as seller" do
        it "redirects_to login page" do
          sign_in seller_user
          get :show , params:{id: order.id , cart_id: cart.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as customer" do
        it "redirects_to login page" do
          sign_in customer_user
          get :show , params:{id: order.id , cart_id: cart.id}
          expect(response).to render_template :show
        end
      end
    end
  end

  describe "get/orders #new" do
    context "accessing new" do
      context "when user not signed_in" do
        it "redirects_to login page" do
          get :new , params:{ cart_id: cart.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as seller" do
        it "redirects_to login page" do
          sign_in seller_user
          get :new , params:{ cart_id: cart.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as customer" do
        it "redirects_to login page" do
          sign_in customer_user
          get :new , params:{cart_id: cart.id}
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "post/order #create" do
    context "creating order" do
      context "when user not signed_in" do
        it "redirects_to login page" do
          post :create , params:{ cart_id: cart.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as seller" do
        it "redirects_to login page" do
          sign_in seller_user
          post :create , params:{ cart_id: cart.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when signed_in as customer" do
        it "redirects_to login page" do
          sign_in customer_user
          post :create , params:{cart_id: cart.id}
          expect(response).to redirect_to(cart_order_index_path)
        end
      end
    end
  end

  describe "get/orders #order_history" do
    context "when user not signed_in" do
      it "redirects to login page" do
        get :order_history
        expect(response).to redirect_to(new_user_session_path)
      end
      end

    context "when signed_in as seller" do
      it "redirects to login page" do
        sign_in seller_user
        get :order_history
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed_in as customer" do
      it "redirects to login page" do
        sign_in customer_user
        get :order_history
        expect(response).to render_template :order_history
      end
    end
  end
end