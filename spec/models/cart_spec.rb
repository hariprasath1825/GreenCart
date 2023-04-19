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

  context "has_many" do

    [:cartitems , :products].each do |each|
      it each.to_s.humanize do
        association = Cart.reflect_on_association(each).macro
        expect(association).to be(:has_many)
      end
    end
  end


  # context "belongs_to" do
  #
  #   it "customer" do
  #     cart = build(:cart)
  #     expect(cart.customer).to be_an_instance_of(Customer)
  #   end
  #
  # end

end
