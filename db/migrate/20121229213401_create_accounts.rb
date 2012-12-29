class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user
      t.references :group
      t.float :balance

      t.timestamps
    end
    add_index :accounts, :user_id
    add_index :accounts, :group_id
  end
end
