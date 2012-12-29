# == Schema Information
#
# Table name: stores
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Store < ActiveRecord::Base
  has_many :store_owners
  attr_accessible :description, :name
end
