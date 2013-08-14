require 'test_helper'

class BillsControllerTest < ActionController::TestCase
  setup do
    @bill = FactoryGirl.create(:bill)
  end

  test "should get index" do
    get :index, :group_id => @bill.group_id
    assert_response :success
    assert_not_nil assigns(:bills)
  end

  # test "should get new" do
  #   get :new, group_id: @group.id
  #   assert_response :success
  # end

  # test "should create bill" do
  #   assert_difference('Bill.count') do
  #     post :create, group_id: @group.id, bill: { due_date: @bill.due_date }
  #   end

  #   assert_redirected_to bill_path(assigns(:bill))
  # end

  # test "should show bill" do
  #   get :show, group_id: @group.id, id: @bill
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, group_id: @group.id, id: @bill
  #   assert_response :success
  # end

  # test "should update bill" do
  #   put :update, group_id: @group.id, id: @bill, bill: { due_date: @bill.due_date }
  #   assert_redirected_to bill_path(assigns(:bill))
  # end

  # test "should destroy bill" do
  #   assert_difference('Bill.count', -1) do
  #     delete :destroy, group_id: @group.id, id: @bill
  #   end

  #   assert_redirected_to bills_path
  # end
end
