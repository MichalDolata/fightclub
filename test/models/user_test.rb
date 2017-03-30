require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Test user', password: 'qwerty',
                     password_confirmation: 'qwerty', email: 'user@example.com')
  end

  test 'name should exist' do
    @user.name = ''
    assert_not @user.valid?
  end

  test 'length of name should be between 4 and 33' do
    @user.name = 'abc'
    assert_not @user.valid?

    @user.name = 'a' * 33
    assert_not @user.valid?

    @user.name = 'abcd'
    assert @user.valid?
  end

  test 'email should be present and valid' do
    @user.email = ''
    assert_not @user.valid?

    @user.email = 'itisntavaildemail'
    assert_not @user.valid?

    @user.email = 'test@example.com'
    assert @user.valid?
  end

  test 'password and password_confirmation should be provided and be equal' do
    @user.password = ''
    @user.password_confirmation = ''
    assert_not @user.valid?

    @user.password = 'qwerty'
    assert_not @user.valid?

    @user.password_confirmation = 'qwerty'
    assert @user.valid?
  end

  test 'email should be unique' do
    second_user = @user.dup
    assert @user.save
    assert_not second_user.save
  end
end
