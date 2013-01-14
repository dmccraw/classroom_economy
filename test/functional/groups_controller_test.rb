require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
#   setup do
#     @user = FactoryGirl.create(:user)
#     @group = FactoryGirl.create(:group, user_id: @user.id)
#     sign_in @user
#   end

#   test "should get index" do
#     get :index
#     assert_response :success
#     assert_not_nil assigns(:groups)
#     assert_equal assigns(:groups), [@group]
#   end

#   test "admin should get all groups on index" do
#     @admin = FactoryGirl.create(:admin)
#     @group2 = FactoryGirl.create(:group, user_id: @user.id)
#     sign_in @admin

#     get :index
#     assert_response :success
#     assert_not_nil assigns(:groups)
#     assert_equal assigns(:groups), [@group, @group2]
#   end

#   test "student should only get his groups on index" do
#     @student = FactoryGirl.create(:student)
#     FactoryGirl.create(:membership, user_id: @student.id, group_id: @group.id)

#     get :index
#     assert_response :success
#     assert_not_nil assigns(:groups)
#     assert_equal assigns(:groups), [@group]
#   end

#   test "should get new" do
#     get :new
#     assert_response :success
#   end

#   test "should create group" do
#     assert_difference('Group.count') do
#       post :create, group: { name: @group.name, user_id: @group.user_id }
#     end
#     assert_redirected_to root_path
#   end

#   test "student shouldn't be able to create a group" do
#     @student = FactoryGirl.create(:student)
#     sign_in @student

#     post :create, group: { name: @group.name, user_id: @group.user_id }
#     assert_redirected_to groups_path
#   end

#   test "teacher should show group" do
#     get :show, id: @group
#     assert_response :success
#   end

#   test "admin should show group" do
#     @admin = FactoryGirl.create(:admin)
#     sign_in @admin
#     get :show, id: @group
#     assert_response :success
#   end

#   test "student shouldn't show group" do
#     @studemt = FactoryGirl.create(:student)
#     sign_in @studemt
#     get :show, id: @group
#     assert_redirected_to groups_path
#   end

#   test "should get edit" do
#     get :edit, id: @group
#     assert_response :success
#   end

#   test "student shouldn't be able to edit" do
#     @studemt = FactoryGirl.create(:student)
#     sign_in @studemt
#     get :edit, id: @group
#     assert_redirected_to groups_path
#   end

#   test "teacher should update group" do
#     put :update, id: @group, group: { name: @group.name, user_id: @group.user_id }
#     assert_redirected_to root_path
#   end

#   test "admin should update group" do
# pending "failing test, investigate"
#     @admin = FactoryGirl.create(:admin)
#     sign_in @admin
#     put :update, id: @group, group: { name: @group.name, user_id: @group.user_id }
#     assert_redirected_to root_path
#   end

#   test "student shouldn't update group" do
#     @student = FactoryGirl.create(:student)
#     sign_in @student
#     put :update, id: @group, group: { name: @group.name, user_id: @group.user_id }
#     assert_redirected_to groups_path
#   end

#   test "teacher should destroy group" do
#     assert_difference('Group.count', -1) do
#       delete :destroy, id: @group
#     end

#     assert_redirected_to root_path
#   end

#   test "admin should destroy group" do
#     @admin = FactoryGirl.create(:admin)
#     sign_in @admin
#     assert_difference('Group.count', -1) do
#       delete :destroy, id: @group
#     end

#     assert_redirected_to root_path
#   end

#   test "student shouldn't destroy group" do
#     @student = FactoryGirl.create(:student)
#     sign_in @student
#     assert_difference('Group.count', 0) do
#       delete :destroy, id: @group
#     end

#     assert_redirected_to root_path
#   end

end
