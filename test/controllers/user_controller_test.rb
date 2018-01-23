require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @otheruser = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited vie the web" do
    log_in_as(@otheruser)
    assert_not @otheruser.admin?
    patch user_path(@otheruser), params: {
                                   user: { password: 'password',
                                           password_confirmation: 'password',
                                           admin: true } }
    assert_not @otheruser.reload.admin?
  end

  test "should redirect index when no logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@otheruser)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin user" do
    log_in_as(@otheruser)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

end
