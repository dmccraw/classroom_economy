# == Schema Information
#
# Table name: store_managers
#
#  id           :integer          not null, primary key
#  store_id     :integer
#  user_id      :integer
#  manage_level :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  salary       :float
#

require 'test_helper'

class StoreManagerTest < ActiveSupport::TestCase
  should validate_presence_of :store_id
  should validate_presence_of :user_id
  should validate_presence_of :salary
  should validate_numericality_of :salary
end
