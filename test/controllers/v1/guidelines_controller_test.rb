require "test_helper"

class V1::GuidelinesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get v1_guidelines_index_url
    assert_response :success
  end
end
