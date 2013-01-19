# == Schema Information
#
# Table name: job_assignments
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  user_id    :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class JobAssignment < ActiveRecord::Base
  belongs_to :job
  belongs_to :user
  belongs_to :group

  attr_accessible :job_id, :user_id, :group_id

  validates :job_id, presence: true
  validates :user_id, presence: true
  validates :group_id, presence: true

  validate :unique_job_and_user

  private

  def unique_job_and_user
    if self.new_record?
      if job_assignment = JobAssignment.where(job_id: self.job_id, user_id: self.user_id).first
        Rails.logger.red(job_assignment.inspect)
        errors.add(:base, "The student is already assigned to this job.")
      end
    end
  end
end
