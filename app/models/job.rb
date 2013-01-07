class Job < ActiveRecord::Base
  belongs_to :group
  has_many :job_assignments

  attr_accessible :description, :salary, :title
end
