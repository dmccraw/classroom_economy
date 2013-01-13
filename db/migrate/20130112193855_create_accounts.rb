class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :owner_id
      t.string, :owner_type
      t.group, :references
      t.float :balance

      t.timestamps
    end
  end
end
