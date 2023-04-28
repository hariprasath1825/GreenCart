require 'rails_helper'

RSpec.describe Order, type: :model do

  describe "total_price" do
    before(:each) do
      order.validate
    end

    context "when value is present" do
      let(:order) {build(:order , total_price: 1000)}
      it "doesn't throw any error" do
        expect(order.errors).to_not include(:total_price)
      end
    end

    context "when value is nil" do
      let(:order) {build(:order , total_price: nil)}
      it "throws error" do
        expect(order.errors).to include(:total_price)
      end
    end

    context "when value is numeric" do
      let(:order) {build(:order , total_price: 1000)}
      it "doesn't throw any error" do
        expect(order.errors).to_not include(:total_price)
      end
    end

    context "when value is non numeric" do
      let(:order) {build(:order , total_price: "hundred")}
      it "throws error" do
        expect(order.errors).to include(:total_price)
      end
    end

    context "when value is greater than 0" do
      let(:order) {build(:order , total_price: 100)}
      it "doesn't throw any error" do
        expect(order.errors).to_not include(:total_price)
      end
    end

    context "when value is less than 0" do
      let(:order) {build(:order , total_price: -100)}
      it "throws error" do
        expect(order.errors).to include(:total_price)
      end
    end
  end

  describe "customer_id" do
    before(:each) do
      order.validate
    end

    context "when value is present" do
      let(:customer) {create(:customer)}
      let(:order) {build(:order , customer_id: customer.id)}
      it "doesn't throw any error" do
        expect(order.errors).to_not include(:customer_id)
      end
    end

    context "when value is nil" do
      let(:order) {build(:order , customer_id: nil)}
      it "throws error" do
        expect(order.errors).to include(:customer_id)
      end
    end
  end

  describe "order_date" do
    before(:each) do
      order.validate
    end

    context "when value is present" do
      let(:order) {build(:order , order_date: "2023/04/16")}
      it "doesn't throw any error" do
        expect(order.errors).to_not include(:order_date)
      end
    end

    context "when value is nil" do
      let(:order) {build(:order , order_date: nil)}
      it "doesn't throw any error" do
        expect(order.errors).to include(:order_date)
      end
    end
  end


  describe "association" do

    context "has_many orderitems" do
      it "is true" do
        association = Order.reflect_on_association(:orderitems).macro
        expect(association).to be(:has_many)
      end
    end

    context "has_one payment" do
      it "is true" do
        association = Order.reflect_on_association(:payment).macro
        expect(association).to be(:has_one)
      end
    end

    # context "has_many_through" do
    #   it "is true" do
    #     expect(Order.reflect_on_association(:products).macro).to be(:has_many_through)
    #   end
    # end
  end

  describe "destroy dependency" do
    before(:each) do
      order.delete
    end
    context "when order is deleted" do
      let(:customer) {create(:customer)}
      let(:order) {create(:order , customer: customer)}
      let(:payment) {create(:payment , order_id: order.id)}
      it "payment is also deleted" do
        expect(Payment.find_by(order_id: order.id)).to be_nil
      end
    end

    context "when order is deleted" do
      let(:customer) {create(:customer)}
      let(:order) {create(:order , customer: customer)}
      let(:product) {create(:product)}
      let(:orderitem) {create(:orderitem , order: order , product: product)}
      it "orderitem is also deleted" do
        expect(Orderitem.where(order_id: order.id)).to be_empty
      end
    end
  end
end
