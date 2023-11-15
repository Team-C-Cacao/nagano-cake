require "test_helper"

class Public::OdersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_oders_new_url
    assert_response :success
  end

  test "should get index" do
    get public_oders_index_url
    assert_response :success
  end

  test "should get show" do
    get public_oders_show_url
    assert_response :success
  end
end
