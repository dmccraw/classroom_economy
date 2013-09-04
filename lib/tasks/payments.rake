namespace :payments do
  task :monthly => :environment do

    # go through each group and pay each job assignment
    Group.all.each do |group|

      # need to make sure they don't get paid more than once a month
      group_account = group.group_account

      group.job_assignments.each do |job_assignment|
        if job_assignment.user && job_assignment.user.account(group.id)
          transaction = Transaction.new(
            from_account_id: group_account.id,
            to_account_id: job_assignment.user.account(group.id).id,
            group_id: group.id,
            amount: job_assignment.job.salary,
            description: "Monthy paycheck for job: #{job_assignment.job.title}",
            user_id: group.user_id,
            occurred_on: DateTime.now
          )
          transaction.save!
        end
      end

      group.charges.each do |charge|
        if charge.account
          transaction = Transaction.new(
            from_account_id: charge.account_id,
            to_account_id: group_account.id,
            group_id: group.id,
            amount: charge.amount,
            description: "Monthy charge for #{charge.description}",
            user_id: group.user_id,
            occurred_on: DateTime.now
          )
        end
      end
    end
  end
end