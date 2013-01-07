class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :description
      t.float :salary
      t.references :group

      t.timestamps
    end
    add_index :jobs, :group_id
  end
end
