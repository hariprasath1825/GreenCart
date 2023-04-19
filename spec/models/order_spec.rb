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

    context "has_many" do
      it "is true" do
        association = Order.reflect_on_association(:orderitems).macro
        expect(association).to be(:has_many)
      end
      end

    context "has_one" do
      it "is true" do
        association = Order.reflect_on_association(:payment).macro
        expect(association).to be(:has_one)
      end
    end
  end
end
