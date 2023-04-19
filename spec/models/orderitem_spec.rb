require 'rails_helper'

RSpec.describe Orderitem, type: :model do

  describe "quantity" do
    before(:each) do
      orderitem.validate
    end

    context "when value is present" do
      let(:orderitem) {build(:orderitem , quantity: 3)}
      it "doesn't throw any error" do
        expect(orderitem.errors).to_not include(:quantity)
      end
    end

    context "when value is nil" do
      let(:orderitem) {build(:orderitem , quantity: nil)}
      it "throws error" do
        expect(orderitem.errors).to include(:quantity)
      end
    end

    context "when value is numeric" do
      let(:orderitem) {build(:orderitem , quantity: 10)}
      it "doesn't throw any error" do
        expect(orderitem.errors).to_not include(:quantity)
      end
    end

    context "when value is non numeric" do
      let(:orderitem) {build(:orderitem , quantity: "ten")}
      it "throws error" do
        expect(orderitem.errors).to include(:quantity)
      end
    end

    context "when value is greater than 0" do
      let(:orderitem) {build(:orderitem , quantity: 3)}
      it "doesn't throw any error" do
        expect(orderitem.errors).to_not include(:quantity)
      end
    end

    context "when value is less than 0" do
      let(:orderitem) {build(:orderitem , quantity: -3)}
      it "throws error" do
        expect(orderitem.errors).to include(:quantity)
      end
    end
  end

  describe "price" do
    before(:each) do
      orderitem.validate
    end

    context "when value is present" do
      let(:orderitem) {build(:orderitem , price: 100)}
      it "doesn't throw any error" do
        expect(orderitem.errors).to_not include(:price)
      end
    end

    context "when value is nil" do
      let(:orderitem) {build(:orderitem , price: nil)}
      it "throws error" do
        expect(orderitem.errors).to include(:price)
      end
    end

    context "when value is numeric" do
      let(:orderitem) {build(:orderitem , price: 100)}
      it "doesn't throw any error" do
        expect(orderitem.errors).to_not include(:price)
      end
    end

    context "when value is non numeric" do
      let(:orderitem) {build(:orderitem , price: "hundred")}
      it "throws error" do
        expect(orderitem.errors).to include(:price)
      end
    end

    context "when value is greater than 0" do
      let(:orderitem) {build(:orderitem , price: 200)}
      it "doesn't throw any error" do
        expect(orderitem.errors).to_not include(:price)
      end
    end

    context "when value is less than 0" do
      let(:orderitem) {build(:orderitem , price: -200)}
      it "throws error" do
        expect(orderitem.errors).to include(:price)
      end
    end
  end

  describe "product_id" do
    before(:each) do
      orderitem.validate
    end

    context "when value is present" do
      let(:product) {create(:product)}
      let(:orderitem) {build(:orderitem , product_id: product.id)}
      it "doesn't throw any error" do
        expect(orderitem.errors).to_not include(:product_id)
      end
    end

    context "when value is nil" do
      let(:orderitem) {build(:orderitem , product_id: nil)}
      it "throws error" do
        expect(orderitem.errors).to include(:product_id)
      end
    end
  end

  describe "association" do
    context "belongs_to" do
      let(:customer) {create(:customer)}
      let(:order) {create(:order , customer_id: customer.id)}
      let(:orderitem) {build(:orderitem , order_id: order.id)}
      it "is true with order" do
        expect(orderitem.order).to be_an_instance_of(Order)
      end
    end

    context "belongs_to" do
      let(:product) {create(:product)}
      let(:orderitem) {build(:orderitem , product_id: product.id)}
      it "is true with product" do
        expect(orderitem.product).to be_an_instance_of(Product)
      end
    end
  end
end
