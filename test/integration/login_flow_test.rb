require 'test_helper'

class LoginFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:admin)
  end

  test 'successful login' do
    get '/'
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', signup_path
    get login_path
    assert_template 'sessions/new'
    log_in_as @user

    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You have been successfully logged in'
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', signup_path, count: 0
  end

  test 'logout' do
    log_in_as @user
    get '/'
    assert_select 'a[href=?]', logout_path
    delete logout_path
    assert_not is_logged_in?

    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You have been successfully logged out'
  end
end
