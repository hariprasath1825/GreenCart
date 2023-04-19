require 'rails_helper'

RSpec.describe Review , type: :model do

  describe "date" do
    before(:each) do
      review.validate
    end

    context "when value is present" do
      let(:review) {build(:review , date: "2023-04-16")}
      it "doesn't throw any error" do
        expect(review.errors).to_not include(:date)
      end
    end

    context "when value is nil " do
      let(:review) {build(:review, date: nil)}
      it "throws error" do
        expect(review.errors).to include(:date)
      end
    end
  end

  describe "rating" do
    before(:each) do
      review.validate
    end

    context "when value is present" do
      let(:review){build(:review , rating: 5)}
      it "doesn't throw any error" do
        expect(review.errors).to_not include(:rating)
      end
      end

    context "when value is nil" do
      let(:review){build(:review , rating: nil)}
      it "doesn't throw any error" do
        expect(review.errors).to include(:rating)
      end
      end

    context "when value is numeric" do
      let(:review){build(:review , rating: 4)}
      it "doesn't throw any error" do
        expect(review.errors).to_not include(:rating)
      end
      end

    context "when value is non numeric" do
      let(:review){build(:review , rating: "five")}
      it "throws error" do
        expect(review.errors).to include(:rating)
      end
      end

    context "when value is less than 0" do
      let(:review){build(:review , rating: -5)}
      it "throws error" do
        expect(review.errors).to include(:rating)
      end
      end

    context "when value is greater than -1" do
      let(:review){build(:review , rating: 4)}
      it "doesn't throw any error" do
        expect(review.errors).to_not include(:rating)
      end
      end

    context "when value is greater than 5" do
      let(:review){build(:review , rating: 7)}
      it "throws error" do
        expect(review.errors).to include(:rating)
      end
      end

    context "when value is less than 5" do
      let(:review){build(:review , rating: 3)}
      it "doesn't throw any error" do
        expect(review.errors).to_not include(:rating)
      end
    end
  end

  describe "customer_id" do
    before(:each) do
      review.validate
    end

    context "when value is nil" do
      let(:review) {build(:review , customer: nil)}
      it "throws error" do
        expect(review.errors).to include(:customer_id)
      end
      end

    context "when value is present" do
      let(:customer) {create(:customer)}
      let(:review) {build(:review , customer_id: customer.id)}
      it "doesn't throw any error" do
        expect(review.errors).to_not include(:customer_id)
      end
    end

    end

  describe "product_id" do
    before(:each) do
      review.validate
    end

    context "when value is nil" do
      let(:review) {build(:review , product: nil)}
      it "throws error" do
        expect(review.errors).to include(:product_id)
      end
      end

    context "when value is present" do
      let(:seller) {create(:seller)}
      let(:product) {create(:product ,seller_id: seller.id)}
      let(:review) {build(:review , product_id: product.id)}
      it "doesn't throw any error" do
        expect(review.errors).to_not include(:product_id)
      end
    end
  end
end
