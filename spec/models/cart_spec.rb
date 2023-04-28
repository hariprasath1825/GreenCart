require 'rails_helper'

RSpec.describe Cart, type: :model do

  describe "total_price" do
    before(:each) do
      cart.validate
    end

    context "when value is present" do
      let(:cart) {build(:cart , total_price: 1000)}
      it "doesnt throw any error" do
        expect(cart.errors).to_not include(:total_price)
      end
    end

    context "when value is nil" do
      let(:cart) {build(:cart , total_price: nil)}
      it "throws error" do
        expect(cart.errors).to include(:total_price)
      end
    end

    context "when value is numeric" do
      let(:cart) {build(:cart , total_price: 100)}
      it "doesnt throw any error" do
        expect(cart.errors).to_not include(:total_price)
      end
    end

    context "when value is not numeric" do
      let(:cart) {build(:cart , total_price: "abc")}
      it "throws error" do
        expect(cart.errors).to include(:total_price)
      end
    end

    context "when value is greater than -1" do
      let(:cart) {build(:cart , total_price: 100)}
      it "doesnt throw any error" do
        expect(cart.errors).to_not include(:total_price)
      end
    end

    context "when value is less than 0" do
      let(:cart) {build(:cart , total_price: -100)}
      it "throws error" do
        expect(cart.errors).to include(:total_price)
      end
    end
  end

  describe "cart association" do

    context "has_many" do

      [:cartitems , :products].each do |each|
        it each.to_s.humanize do
          association = Cart.reflect_on_association(each).macro
          expect(association).to be(:has_many)
        end
      end
    end


    context "belongs_to"  do
      let(:customer) {create(:customer)}
      let(:cart) {build(:cart , customer: customer)}
      it "customer is true" do
        expect(cart.customer).to be_an_instance_of(Customer)
      end
    end

    context "destroy dependency" do
      context "when cart is destroyed" do
        let(:customer) {create(:customer)}
        let(:cart) {build(:cart , customer: customer)}
        let(:product) {create(:product)}
        let(:cartitem) {create(:cartitem , product: product , cart: cart)}
        it "cartitems are also deleted" do
          cart.delete
          cartitems = Cartitem.find_by(cart_id: cart.id)
          expect(cartitems).to be_nil
        end
      end
    end
  end

end
