class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.references :from_account
      t.references :to_account
      t.references :group
      t.references :user
      t.datetime :due_date

      t.timestamps
    end
    add_index :bills, :from_account_id
    add_index :bills, :to_account_id
    add_index :bills, :group_id
    add_index :bills, :user_id
  end
end
