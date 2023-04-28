require 'rails_helper'

RSpec.describe Product, type: :model do

  describe "name" do
    before(:each) do
      product.validate
    end

    context "when value is present" do
      let(:product) {build(:product , name: "apple")}
      it "doesnt throw any error" do
        expect(product.errors).to_not include(:name)
      end
    end

    context "when value is nil" do
      let(:product) {build(:product , name: nil)}
      it "fails if not exists" do
        expect(product.errors).to include(:name)
      end
    end

    context "when value is alphabetic" do
      let(:product) {build(:product , name: "apple")}
      it "doesnt throw any error" do
        expect(product.errors).to_not include(:name)
      end
    end

    context "when value is not alphabetic" do
      let(:product) {build(:product , name: "apple123")}
      it "throws error" do
        expect(product.errors).to include(:name)
      end
    end
  end

  describe "price" do
    before(:each) do
      product.validate
    end

    context "when value is present" do
      let(:product) {build(:product , price: 100)}
      it "doesnt throw any error" do
        expect(product.errors).to_not include(:price)
      end
    end

    context "when value is nil" do
      let(:product) {build(:product , price: nil)}
      it "throws error" do
        expect(product.errors).to include(:price)
      end
    end

    context "when value is greater than 0" do
      let(:product) {build(:product , price: 100)}
      it "doesnt throw any error" do
        expect(product.errors).to_not include(:price)
      end
    end

    context "when value is less than 0" do
      let(:product) {build(:product , price: -100)}
      it "throws error" do
        expect(product.errors).to include(:price)
      end
    end
  end

  describe "description" do

    before(:each) do
      product.validate
    end

    context "when value is present" do
      let(:product) {build(:product ,description: "it s a valid description")}
      it "doesnt throw any error" do
        expect(product.errors).to_not include(:description)
      end
    end

    context "when value is nil" do
      let(:product) {build(:product ,description: nil)}
      it "throws error" do
        expect(product.errors).to include(:description)
      end
    end

    context "when value is greater than 10 characters" do
      let(:product) {build(:product ,description: "It is a valid length description")}
      it "doesnt throw any error" do
        expect(product.errors).to_not include(:description)
      end
    end

    context "when value is less than 10 characters" do
      let(:product) {build(:product ,description: "123456789")}
      it "throws error" do
        expect(product.errors).to include(:description)
      end
    end

    context "when value is less than 100 characters" do
      let(:product) {build(:product ,description: "It is a valid length description")}
      it "throws error" do
        expect(product.errors).to_not include(:description)
      end
    end

    context "when value is greater than 100 characters" do
      let(:product) {build(:product ,description: "pFuBf0ZJF2iP6CKwboPMFuLsz1tQI4AsxHz5swqmUxe08kEF37M2rcQQtloFyeo2Wa0TYKCLbPIQixAh1mWN5x1zPDX8qGXgGVfY12345")}
      it "throws error" do
        expect(product.errors).to include(:description)
      end
    end

  end

  describe "available_quantity" do
    before(:each) do
      product.validate
    end

    context "when value is present" do
      let(:product) {build(:product , available_quantity: 10)}
      it "doesnt throw any error" do
        expect(product.errors).to_not include(:available_quantity)
      end
    end

    context "when value is nil" do
      let(:product) {build(:product , available_quantity: nil)}
      it "throws error" do
        expect(product.errors).to include(:available_quantity)
      end
    end

    context "when value is greater than 0" do
      let(:product) {build(:product , available_quantity: 100)}
      it "doesnt throw any error" do
        expect(product.errors).to_not include(:available_quantity)
      end
    end

    context "when value is less than 0" do
      let(:product) {build(:product , available_quantity: -100)}
      it "throws error" do
        expect(product.errors).to include(:available_quantity)
      end
      end

    context "when value is numeric" do
      let!(:product) {build(:product , available_quantity: 100)}
      it "it doesn't throw any error" do
        expect(product.errors).to_not include(:available_quantity)
      end
      end

    context "when value is non numeric" do
      let(:product) {build(:product , available_quantity: "hundred")}
      it "it doecn't throw any error" do
        expect(product.save).to be_falsy
      end
    end
  end

  describe "associations" do

    context "has_many" do
      [:cartitems , :orderitems , :reviews].each do |each|
        it each.to_s.humanize do
          association = Product.reflect_on_association(each).macro
          expect(association).to be(:has_many)
        end
      end

    end

    context "belongs_to " do
      let(:seller) {create(:seller)}
      let(:product) { build(:product , seller_id: seller.id) }
      it "seller" do
        expect(product.seller).to be_an_instance_of(Seller)
      end
    end
  end

  describe "destroy dependency" do

    context "when product is deleted" do
      let(:product) {create(:product)}
      let(:review) {create(:review , product_id: product.id)}
      it "reviews are deleted" do
        product.destroy
        expect(Review.find_by(product_id: product.id)).to be(nil)
      end
      end

    context "when product is deleted" do
      let(:product) {create(:product)}
      let(:cartitem) {create(:cartitem , product_id: product.id )}
      it "cartitems are deleted" do
        # p Cartitem.find_by(product_id: product.id)
        product.destroy
        expect(Cartitem.find_by(product_id: product.id)).to be(nil)
      end
      end

    context "when product is deleted" do
      let(:product) {create(:product)}
      let(:cartitem) {create(:cartitem , product_id: product.id )}
      it "cartitems are deleted" do
        # p Cartitem.find_by(product_id: product.id)
        product.destroy
        expect(Cartitem.find_by(product_id: product.id)).to be(nil)
      end
    end

  end

end
