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
#

class StoreManager < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  attr_accessible :manage_level, :store_id, :user_id

  validates :store_id, presence: true
  validates :user_id, presence: true

  validate :unique_store_user

  private

  def unique_store_user
    if self.new_record?
      store_managers = StoreManager.where(user_id: self.user_id, store_id: self.store_id)
      if store_managers.count > 0
        errors.add(:base, "This student is already a manager of this store.")
      end
    end
  end
end
