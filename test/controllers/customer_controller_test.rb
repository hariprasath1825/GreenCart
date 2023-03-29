require "test_helper"

class CustomerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customer_index_url
    assert_response :success
  end
end
