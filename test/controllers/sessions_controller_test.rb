require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:admin)
  end

  test "should get new" do
    get sessions_new_url
    assert_response :success
  end

  test 'should log in and log out' do
    log_in_as @user
    assert is_logged_in?
    delete logout_url
    assert_not is_logged_in?
  end

  test 'should display notice when data for login doesnt match' do
    log_in_as @user, password: 'wrong_password'
    assert_not is_logged_in?
    assert_select 'div.alert', 'Invalid email/password combination'
  end

end
