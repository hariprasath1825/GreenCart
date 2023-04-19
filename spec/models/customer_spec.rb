require 'rails_helper'

RSpec.describe Customer, type: :model do

  describe "name" do
    before(:each) do
      customer.validate
    end
    context "when value is present" do
      let(:customer) {build(:customer , name: "Customer")}
      it "doesnt throw any error" do
        expect(customer.errors).to_not include(:name)
      end
    end

    context "when value is nil" do
      let(:customer) {build(:customer , name: nil)}
      it "throws error" do
        expect(customer.errors).to include(:name)
      end
    end

    context "when value is valid" do
      let(:customer) {build(:customer , name: "Customer")}
      it "doesnt throw any error" do
        expect(customer.errors).to_not include(:name)
      end
    end

    context "when value is invalid" do
      let(:customer) {build(:customer , name: "Customer123")}
      it "throws error" do
        expect(customer.errors).to include(:name)
      end
    end
  end

  describe "mbl_no" do
    before(:each) do
      customer.validate
    end
    context "when value is present" do
      let(:customer) {build(:customer , mbl_no: "9876543210")}
      it "doesnt throw error" do
        expect(customer.errors).to_not include(:mbl_no)
      end
    end
    context "when value is nil" do
      let(:customer) {build(:customer , mbl_no: nil)}
      it "throws error" do
        expect(customer.errors).to include(:mbl_no)
      end
    end

    context "when value with valid length is given" do
      let(:customer) {build(:customer , mbl_no: "9876543210")}
      it "doesnt throw any error" do
        expect(customer.errors).to_not include(:mbl_no)
      end
    end

    context "when value with invalid length is given" do
      let(:customer) {build(:customer , mbl_no: "98765")}
      it "throws error" do
        expect(customer.errors).to include(:mbl_no)
      end
    end

    context "when non numberic value is given" do
      let(:customer) {build(:customer , mbl_no: "abcdefghij")}
      it "throws error" do
        expect(customer.errors).to include(:mbl_no)
      end
    end
  end


  describe "age" do
    before(:each) do
      customer.validate
    end
    context "when value is present" do
      let(:customer) {build(:customer , age: 30)}
      it "doesnt throw" do
        expect(customer.errors).to_not include(:age)
      end
    end

    context "when value is nil" do
      let(:customer) {build(:customer , age: nil)}
      it "throws error" do
        expect(customer.errors).to include(:age)
      end
    end

    context "when value is greater than 17" do
      let(:customer) {build(:customer , age: 30)}
      it "doesnt throw any error" do
        expect(customer.errors).to_not include(:age)
      end
    end

    context "when value is less than 17" do
      let(:customer) {build(:customer , age: 16)}
      it "throws error" do
        expect(customer.errors).to include(:age)
      end
    end

    context "when value is less than 100" do
      let(:customer) {build(:customer , age: 30)}
      it "doesnt throw any error" do
        expect(customer.errors).to_not include(:age)
      end
    end

    context "when value is greater than 100" do
      let(:customer) {build(:customer , age: 200)}
      it "throws error" do
        expect(customer.errors).to include(:age)
      end
    end
  end

  describe "association" do

    context "has_many" do
      [:orders , :addresses , :reviews].each do |model|
        it model.to_s.humanize do
          association = Customer.reflect_on_association(model).macro
          expect(association).to be(:has_many)
        end
      end
    end

    context "has_one" do
      [:cart , :user].each do |model|
        it model.to_s.humanize do
          association = Customer.reflect_on_association(model).macro
          expect(association).to be(:has_one)
        end
      end
    end

  end
end
