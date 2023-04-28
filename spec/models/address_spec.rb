require 'rails_helper'

RSpec.describe Address, type: :model do

  describe "door_no" do
    before(:each) do
      address.validate
    end

    context "when value is present" do
      let(:address) {build(:address , door_no: "182/4")}
      it "doesnt throw any error" do
        expect(address.errors).to_not include(:door_no)
      end
    end

    context "when value is nil" do
      let(:address) {build(:address , door_no: nil)}
      it "throws error" do
        expect(address.errors).to include(:door_no)
      end
    end

  end

  describe "street" do
    before(:each) do
      address.validate
    end

    context "when value is present" do
      let(:address) {build(:address , street: "rag nagar")}
      it "doesnt throw any error" do
        expect(address.errors).to_not include(:street)
      end
    end

    context "when value is nil" do
      let(:address) {build(:address , street: nil)}
      it "throws error" do
        expect(address.errors).to include(:street)
      end
    end
  end

  describe "district" do
    before(:each) do
      address.validate
    end

    context "when value is present" do
      let(:address) {build(:address , district: "coimbatore")}
      it "doesnt throw any error" do
        expect(address.errors).to_not include(:district)
      end
    end

    context "when value is nil" do
      let(:address) {build(:address , district: nil)}
      it "throws error" do
        expect(address.errors).to include(:district)
      end
    end

    context "when value is alphabetic" do
      let(:address) {build(:address , district: "Coimbatore")}
      it "doesnt throw any error" do
        expect(address.errors).to_not include(:district)
      end
    end

    context "when value is not alphabetic" do
      let(:address) {build(:address , district: "Coimbatore123")}
      it "throws error" do
        expect(address.errors).to include(:district)
      end
    end

  end

  describe "state" do
    before(:each) do
      address.validate
    end

    context "when value is present" do
      let(:address) {build(:address , state: "Tamil Nadu")}
      it "doesnt throw any error" do
        expect(address.errors).to_not include(:state)
      end
    end

    context "when value is nil" do
      let(:address) {build(:address , state: nil)}
      it "throws error" do
        expect(address.errors).to include(:state)
      end
    end

    context "when value is alphabetic" do
      let(:address) {build(:address , state: "Tamil Nadu")}
      it "doesnt throw any error" do
        expect(address.errors).to_not include(:state)
      end
    end

    context "when value is not alphabetic" do
      let(:address) {build(:address , state: "Tamil Nadu 123")}
      it "throws error" do
        expect(address.errors).to include(:state)
      end
    end

  end

  describe "pincode" do
    before(:each) do
      address.validate
    end

    context "when value is present" do
      let(:address) {build(:address , pincode: 654321)}
      it "can be saved" do
        expect(address.save).to be_truthy
      end
    end

    context "when value is nil" do
      let(:address) {build(:address , pincode: nil)}
      it "cannot be saved" do
        expect(address.save).to be_falsy
      end
    end

    context "when value is non numeric" do
      let(:address) {build(:address , pincode: "abcdef")}
      it "cannot be saved" do
        expect(address.errors).to include(:pincode)
      end
    end


    context "when length is equal to 6" do
      let(:address) {build(:address , pincode: 654321)}
      it "doesn't throw any error" do
        expect(address.errors).to_not include(:pincode)
      end
    end

    context "when length is less than 6" do
      let(:address) {build(:address , pincode: 6543)}
      it "throws error" do
        expect(address.errors).to include(:pincode)
      end
    end

    context "when length is greater than 6" do
      let(:address) {build(:address , pincode: 87654321)}
      it "throws error" do
        expect(address.errors).to include(:pincode)
      end
    end
  end

  # describe "association" do
  #   context "belongs_to" do
  #     # let(:customer) {create(:customer)}
  #     let!(:address) {create(:address , :for_customer)}
  #     it "customer is true" do
  #       expect(address.customer).to be_an_instance_of(Customer)
  #     end
  #     end
  #
  #   context "belongs_to" do
  #     let(:address) {create(:address , :for_seller)}
  #     it "seller is true" do
  #       expect(address.seller).to eq("seller")
  #     end
  #   end
  # end

end
