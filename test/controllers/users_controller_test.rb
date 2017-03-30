require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post signup_url, params: { user: {name: 'test', password: 'qwerty', password_confirmation: 'qwerty',
                                email: 'test@example.com'}}
    end

    assert_redirected_to root_path
  end

  # test "should get edit" do
  #   get users_edit_url
  #   assert_response :success
  # end
  #
  # test "should get update" do
  #   get users_update_url
  #   assert_response :success
  # end

end
