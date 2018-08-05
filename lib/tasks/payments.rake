
def pay_groups
  Group.all.each do |group|

    # need to make sure they don't get paid more than once a month
    group_account = group.group_account

    group.job_assignments.each do |job_assignment|
      if job_assignment.user && job_assignment.user.account(group.id)
        transfer = Transfer.new(
          from_account_id: group_account.id,
          to_account_id: job_assignment.user.account(group.id).id,
          group_id: group.id,
          amount: job_assignment.job.salary,
          description: "Monthy paycheck for job: #{job_assignment.job.title}",
          user_id: group.user_id,
          occurred_on: DateTime.now
        )
        transfer.save!
      end
    end

    group.charges.each do |charge|
      if charge.account
        Transfer.new(
          from_account_id: charge.account_id,
          to_account_id: group_account.id,
          group_id: group.id,
          amount: charge.amount,
          description: "Monthy charge for #{charge.description}",
          user_id: group.user_id,
          occurred_on: DateTime.now
        )
        transfer.save!
      end
    end
  end
end

namespace :payments do
  task :monthly => :environment do
    # this should only be run once per month on the first of the month
    if Time.now.day.to_i == 1
      # go through each group and pay each job assignment
      pay_groups
    end
  end

  task :monthly_no_date => :environment do
    pay_groups
  end
end
