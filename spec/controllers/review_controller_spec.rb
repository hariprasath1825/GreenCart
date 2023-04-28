require 'rails_helper'

RSpec.describe ReviewController , type: :controller  do

  let(:admin) {create(:admin_user)}
  let(:customer_user) {create(:user ,  :for_customer , role: "customer")}
  let(:cart) {create(:cart, customer: customer_user.accountable)}
  let(:seller_user) {create(:user ,  :for_seller )}
  let(:product) {create(:product , seller: seller_user.accountable)}
  let(:order) {create(:order , customer_id: customer_user.accountable.id)}
  let(:orderitem) {create(:orderitem , order_id: order.id, product_id: product.id)}
  let(:review) {create(:review , product_id: product.id, customer_id: customer_user.accountable.id)}
  let(:invalid_customer_user) {create(:user, :for_customer)}

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

  describe "review#destroy" do

    context "deleting a review" do

      context "when user not signed_in" do
        it "redirects to login page" do
          get :destroy , params:{id: review.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when seller signed_in" do
        it "redirects to login page" do
          sign_in seller_user
          get :destroy , params:{id: review.id}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when invalid customer signed_in" do
        it "redirects to product show page" do
          sign_in invalid_customer_user
          get :destroy , params:{id: review.id}
          expect(response).to redirect_to(product_path(id: review.product.id))
        end
      end

      context "when customer signed_in with valid params" do
        it "puts a success notice" do
          sign_in customer_user
          get :destroy , params:{id: review.id}
          expect(flash[:notice]).to eq("Review deleted successfully !")
        end
      end

      context "when customer signed_in with invalid params" do
        it "redirects to product index page" do
          sign_in customer_user
          get :destroy , params:{id: 1000}
          expect(response).to redirect_to(product_index_path)
        end
      end
    end
  end

end
