require 'test_helper'

class ChargesControllerTest < ActionController::TestCase
  setup do
    # @charge = charges(:one)
    @group = FactoryGirl.create(:group)
    @charge = FactoryGirl.create(:charge, group_id: @group.id)
  end

  # test "should get index" do
  #   get :index, group_id: @group.id
  #   assert_response :success
  #   assert_not_nil assigns(:charges)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create charge" do
  #   assert_difference('Charge.count') do
  #     post :create, group_id: @group.id, charge: { amount: @charge.amount, description: @charge.description }
  #   end

  #   assert_redirected_to charge_path(assigns(:charge))
  # end

  # test "should show charge" do
  #   get :show, id: @charge, group_id: @group.id
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @charge, group_id: @group.id
  #   assert_response :success
  # end

  # test "should update charge" do
  #   put :update, id: @charge, charge: { amount: @charge.amount, description: @charge.description }, group_id: @group.id
  #   assert_redirected_to charge_path(assigns(:charge))
  # end

  # test "should destroy charge" do
  #   assert_difference('Charge.count', -1) do
  #     delete :destroy, id: @charge, group_id: @group.id
  #   end

  #   assert_redirected_to charges_path
  # end
end
