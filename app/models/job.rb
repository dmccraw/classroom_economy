# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :string(255)
#  salary      :float
#  group_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Job < ActiveRecord::Base
  # associations
  belongs_to :group
  has_many :job_assignments

  # attr_accessible
  attr_accessible :description, :salary, :title

  # validations
  validates :title,
    presence: true,
    length: { maximum: 255 },
    uniqueness: {
      scope: :group_id,
      case_sensitive: false
    }
  validates :description,
    presence: true,
    length: { maximum: 255 },
    uniqueness: {
      scope: :group_id,
      case_sensitive: false
    }
  validates :salary,
    presence: true,
    numericality: { greater_than: 0.0 },
    uniqueness: {
      scope: :group_id,
      case_sensitive: false
    }
  validates :group_id, presence: true
end
