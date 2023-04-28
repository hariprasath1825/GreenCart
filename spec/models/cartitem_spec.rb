require 'rails_helper'

RSpec.describe Cartitem , type: :model do

  describe "quantity" do
    let(:product) {create(:product)}

    # before(:each) do
    #   cartitem.validate
    # end

    context "when value is present" do
      let(:cartitem) {build(:cartitem ,product_id: product.id, quantity: 10)}
      it "doesn't throw any error" do
        cartitem.validate
        expect(cartitem.errors).to_not include(:quantity)
      end
    end

    context "when value is numeric" do
      let(:cartitem) {build(:cartitem ,product_id: product.id, quantity: 10)}
      it "throws error" do
      cartitem.validate
        expect(cartitem.errors).to_not include(:quantity)
      end
    end

    context "when value is non numeric" do
      let(:cartitem) {build(:cartitem ,product_id: product.id, quantity: "ten")}
      it "throws error" do
      cartitem.validate
        expect(cartitem.errors).to include(:quantity)
      end
    end

    context "when value is greater than 0" do
      let(:cartitem) {build(:cartitem ,product_id: product.id, quantity: 5)}
      it "doesn't throw any error" do
        cartitem.validate
        expect(cartitem.errors).to_not include(:quantity)
      end
    end

    context "when value is less than 0" do
      let(:cartitem) {build(:cartitem ,product_id: product.id, quantity: -5)}
      it "doesn't throw any error" do
        cartitem.validate
        expect(cartitem.errors).to include(:quantity)
      end
    end
  end


  describe "product_id" do
    before(:each) do
      cartitem.validate
    end

    context "when value is present" do
      let(:product) {create(:product)}
      let(:cartitem) {build(:cartitem , product_id: product.id)}
      it "doesn't throw any error" do
        expect(cartitem.errors).to_not include(:product_id)
      end
    end
  end

  describe "cartitem association" do
    context "belongs_to cart" do
      let(:customer) {create(:customer)}
      let(:product) {create(:product)}
      let(:cart) {create(:cart , customer_id: customer.id)}
      let(:cartitem) {create(:cartitem , cart_id: cart.id , product_id: product.id)}
      it "is true" do
        expect(cartitem.cart).to be_an_instance_of(Cart)
      end
      end

    context "belongs_to product" do
      let(:customer) {create(:customer)}
      let(:product) {create(:product)}
      let(:cart) {create(:cart , customer_id: customer.id)}
      let(:cartitem) {create(:cartitem , cart_id: cart.id , product_id: product.id)}
      it "is true" do
        expect(cartitem.product).to be_an_instance_of(Product)
      end
    end
  end

  describe "custom methods " do
    context "set_price" do
      let(:product) {create(:product)}
      let(:cartitem) {build(:cartitem , product_id: product.id , quantity: 3)}
      it "sets price as 300" do
        cartitem.set_price
        expect(cartitem.price.to_i).to eq(300)
      end
    end

    context "set_updated_price" do
      let(:product) {create(:product)}
      let(:cartitem) {build(:cartitem , product_id: product.id , quantity: 4)}
      it "sets price as 400" do
        cartitem.set_updated_price
        expect(cartitem.price.to_i).to eq(400)
      end
    end
  end
end
