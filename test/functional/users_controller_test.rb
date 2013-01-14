require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:users)
  # end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    @user2 = FactoryGirl.build(:user)
    assert_difference('User.count') do
      post :create, user: { email: @user2.email, first_name: @user2.first_name, last_name: @user2.last_name, user_type: @user2.user_type, password: "password", password_confirmation: "password" }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  # test "should show user" do
  #   get :show, id: @user
  #   assert_response :success
  # end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: { email: @user.email, first_name: @user.first_name, last_name: @user.last_name, user_type: @user.user_type }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
