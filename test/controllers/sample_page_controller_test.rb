require "test_helper"

class SamplePageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sample_page_index_url
    assert_response :success
  end
end
