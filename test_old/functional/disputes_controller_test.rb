require 'test_helper'

class DisputesControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @group = FactoryGirl.create(:group, user_id: @user.id)
    sign_in @user
    @dispute = FactoryGirl.create(:user_dispute)
  end

  test "should get index" do
    get :index, group_id: @group.id
    assert_response :success
    assert_not_nil assigns(:disputes)
  end

  test "should get new" do
    get :new, group_id: @group.id
    assert_response :success
  end

  test "should create dispute" do
    assert_difference('Dispute.count') do
      post :create, group_id: @group.id, dispute: { reason: @dispute.reason, result: @dispute.result, result_reason: @dispute.result_reason, transfer: @dispute.transfer, owner_id: @dispute.owner_id, owner_type: @dispute.owner_type }
    end

    assert_redirected_to dispute_path(assigns(:dispute))
  end

  test "should get edit" do
    get :edit, id: @dispute, group_id: @group.id
    assert_response :success
  end

  test "should update dispute" do
    put :update, id: @dispute, group_id: @group.id, dispute: { reason: @dispute.reason, result: @dispute.result, result_reason: @dispute.result_reason, transfer: @dispute.transfer, owner_id: @dispute.owner_id, owner_type: @dispute.owner_type }
    assert_redirected_to group_dispute_path(@group, assigns(:dispute))
  end

  test "should destroy dispute" do
    assert_difference('Dispute.count', -1) do
      delete :destroy, id: @dispute, group_id: @group.id
    end

    assert_redirected_to disputes_path
  end
end
