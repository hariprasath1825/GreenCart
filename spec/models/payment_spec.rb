require 'rails_helper'

RSpec.describe Payment, type: :model do

  describe "paid_amount" do
    before(:each) do
      payment.validate
    end

    context "when value is present" do
      let(:payment) {build(:payment , paid_amount: 1000)}
      it "doesnt throw any error" do
        expect(payment.errors).to_not include(:paid_amount)
      end
      end

    context "when value is nil" do
      let(:payment) {build(:payment , paid_amount: nil)}
      it "throws error" do
        expect(payment.errors).to include(:paid_amount)
      end
      end

    context "when value is numeric" do
      let(:payment) {build(:payment , paid_amount: 1000.50)}
      it "doesnt throw any error" do
        expect(payment.errors).to_not include(:paid_amount)
      end
      end

    context "when value is not numeric" do
      let(:payment) {build(:payment , paid_amount: "abc")}
      it "throws error" do
        expect(payment.errors).to include(:paid_amount)
      end
    end
  end

  describe "order_id" do
    before(:each) do
      payment.validate
    end

    context "when value is nil" do
      let(:payment) {build(:payment , order_id: nil)}
      it "throws error" do
        expect(payment.errors).to include(:order_id)
      end
    end

    context "when value is present" do
      let(:order) {build(:order)}
      let(:payment) {build(:payment , order_id: order.id)}
      it "throws error" do
        expect(payment.errors).to include(:order_id)
      end
    end
  end

  # describe "association" do
  #   context "belongs_to" do
  #     # before(:each) do
  #     #   payment.validate
  #     # end
  #     let(:customer) {create(:customer)}
  #     let(:cart) {create(:cart , customer: customer)}
  #     let(:product) {create(:product)}
  #     let(:cartitems) {create(:cartitem , product: product , cart: cart)}
  #     let(:order) {create(:order , customer: customer)}
  #     let(:orderitems) {create(:orderitem , product: product , order: order)}
  #     let(:payment) {create(:payment , order: order)}
  #     it "Order" do
  #       expect(payment.order).to eq(order)
  #     end
  #   end
  # end



end
