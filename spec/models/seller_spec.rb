require 'rails_helper'

RSpec.describe Seller, type: :model do

  describe "name" do
    before(:each) do
      seller.validate
    end
    context "when value is present" do
      let(:seller) {build(:seller , name: "seller")}
      it "doesnt throw any error" do
        expect(seller.errors).to_not include(:name)
      end
    end

    context "when value is nil" do
      let(:seller) {build(:seller , name: nil)}
      it "throws error" do
        expect(seller.errors).to include(:name)
      end
    end

    context "when value is valid" do
      let(:seller) {build(:seller , name: "seller")}
      it "doesnt throw any error" do
        expect(seller.errors).to_not include(:name)
      end
    end

    context "when value is invalid" do
      let(:seller) {build(:seller , name: "seller123")}
      it "throws error" do
        expect(seller.errors).to include(:name)
      end
    end
  end

  describe "mbl_no" do
    before(:each) do
      seller.validate
    end
    context "when value is present" do
      let(:seller) {build(:seller , mbl_no: "9876543210")}
      it "doesnt throw error" do
        expect(seller.errors).to_not include(:mbl_no)
      end
    end
    context "when value is nil" do
      let(:seller) {build(:seller , mbl_no: nil)}
      it "throws error" do
        expect(seller.errors).to include(:mbl_no)
      end
    end

    context "when value with valid length is given" do
      let(:seller) {build(:seller , mbl_no: "9876543210")}
      it "doesnt throw any error" do
        expect(seller.errors).to_not include(:mbl_no)
      end
    end

    context "when value with invalid length is given" do
      let(:seller) {build(:seller , mbl_no: "98765")}
      it "throws error" do
        expect(seller.errors).to include(:mbl_no)
      end
    end

    context "when non numberic value is given" do
      let(:seller) {build(:seller , mbl_no: "abcdefghij")}
      it "throws error" do
        expect(seller.errors).to include(:mbl_no)
      end
    end
  end


  describe "age" do
    before(:each) do
      seller.validate
    end
    context "when value is present" do
      let(:seller) {build(:seller , age: 30)}
      it "doesnt throw" do
        expect(seller.errors).to_not include(:age)
      end
    end

    context "when value is nil" do
      let(:seller) {build(:seller , age: nil)}
      it "throws error" do
        expect(seller.errors).to include(:age)
      end
    end

    context "when value is greater than 17" do
      let(:seller) {build(:seller , age: 30)}
      it "doesnt throw any error" do
        expect(seller.errors).to_not include(:age)
      end
    end

    context "when value is less than 17" do
      let(:seller) {build(:seller , age: 16)}
      it "throws error" do
        expect(seller.errors).to include(:age)
      end
    end

    context "when value is less than 100" do
      let(:seller) {build(:seller , age: 30)}
      it "doesnt throw any error" do
        expect(seller.errors).to_not include(:age)
      end
    end

    context "when value is greater than 100" do
      let(:seller) {build(:seller , age: 200)}
      it "throws error" do
        expect(seller.errors).to include(:age)
      end
    end
  end

  describe "association" do

    context "has_many" do
      [:products , :addresses].each do |model|
        it model.to_s.humanize do
          association = Seller.reflect_on_association(model).macro
          expect(association).to be(:has_many)
        end
      end
    end

    context "has_one" do
      it "User" do
        association = Seller.reflect_on_association(:user).macro
        expect(association).to be(:has_one)
      end
    end
  end

  describe "destroy dependency" do
    context "when seller is deleted" do
      before(:each) do
        seller.delete
      end
      let(:seller) {create(:seller)}
      let(:product) {create(:product , seller_id: seller.id)}
      it "product is also deleted" do
        expect(Product.find_by(seller_id: seller.id)).to be_nil
      end
    end

    context "when seller id deleted" do
      let(:seller) {create(:seller)}
      let(:address) {create(:address , seller: seller)}
      it "address is also deleted" do
        expect(Address.find_by(addressable_id: seller.id)).to be_nil
      end
    end
  end
end
