# == Schema Information
#
# Table name: store_owners
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  store_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StoreOwner < ActiveRecord::Base
  belongs_to :user
  belongs_to :store

  attr_accessible :user_id, :store_id

  # validation
  validates :store_id, presence: true
  validates :user_id, presence: true

  validate :unique_user_store

  private

  def unique_user_store
    if self.new_record?
      store_owners = StoreOwner.where(user_id: self.user_id, store_id: self.store_id)
      if store_owners.any?
        errors.add(:base, "User is already is a store owner")
      end
    end
  end
end
