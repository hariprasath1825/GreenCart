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

end
