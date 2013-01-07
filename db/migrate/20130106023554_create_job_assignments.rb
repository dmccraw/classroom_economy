class CreateJobAssignments < ActiveRecord::Migration
  def change
    create_table :job_assignments do |t|
      t.references :job
      t.references :user

      t.timestamps
    end
    add_index :job_assignments, :job_id
    add_index :job_assignments, :user_id
  end
end
