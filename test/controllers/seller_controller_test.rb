require "test_helper"

class SellerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get seller_index_url
    assert_response :success
  end
end
