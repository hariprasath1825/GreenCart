require 'rails_helper'

RSpec.describe ReviewController , type: :controller  do
  # describe "ReviewController" do

  let(:admin) {create(:admin_user)}
  let(:customer_user) {create(:user ,  :for_customer , role: "customer")}
  let(:cart) {create(:cart, customer: customer_user.accountable)}
  let(:seller_user) {create(:user ,  :for_seller )}
  let(:product) {create(:product , seller: seller_user.accountable)}
  let(:order) {create(:order , customer_id: customer_user.accountable.id)}
  let(:orderitem) {create(:orderitem , order_id: order.id, product_id: product.id)}


  describe "get/review #new" do
    context "user not signed_in" do
      it "redirects to login page" do
        get :new , params:{cart_id: cart.id , order_id: order.id}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "user signed_in as seller" do
      it "redirects to login page" do
        sign_in seller_user
        get :new , params:{cart_id: cart.id , order_id: order.id}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "user signed_in as customer" do
      it "renders new page" do
        sign_in customer_user
        get :new , params:{cart_id: cart.id , order_id: order.id}
        expect(response).to render_template :new , params:{cart_id: cart.id , order_id: order.id}
      end
    end
  end

  describe "post/review #create" do
    context "creating a review" do

      context "when user not signed_in" do
        it "redirects to login page" do
          post :create ,params:{cart_id: cart.id , order_id: order.id , review:{rating: 5 , comment: "Good product" ,product_id: product.id }}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when user signed_in as seller" do
        it "redirects to login page" do
          sign_in seller_user
          post :create ,params:{cart_id: cart.id , order_id: order.id ,review:{rating: 5 , comment: "Good product" ,product_id: product.id}}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when user signed_in as customer with valid params" do
        it "renders new page" do
          sign_in customer_user
          post :create , params:{cart_id: cart.id , order_id: order.id ,review:{rating: 5 , comment: "Good product" ,product_id: product.id ,id: order.id}}
          expect(flash[:notice]).to eq("Review added successfully !")
        end
      end

      context "when user signed_in as customer with invalid params" do
        it "fails to create review" do
          sign_in customer_user
          post :create , params:{cart_id: cart.id , order_id: order.id ,review:{rating: nil , comment: "Good product" ,product_id: product.id}}
          expect(flash[:notice]).to eq("Failed to post comment !")
        end
      end

      context "when user signed_in as customer with invalid params" do
        it "renders new page" do
          sign_in customer_user
          post :create , params:{cart_id: cart.id , order_id: order.id ,review:{rating: nil , comment: "Good product" ,product_id: product.id}}
          expect(response).to render_template :new , params:{cart_id: cart.id , order_id: order.id}
        end
      end
    end
  end
end
