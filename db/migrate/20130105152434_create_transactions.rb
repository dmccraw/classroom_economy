class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.references :from_account, :null => false
      t.references :to_account,   :null => false
      t.references :group,        :null => false
      t.float :amount,           :null => false
      t.string :description,      :null => false
      t.datetime :occurred_on,    :null => false
      t.references :user,         :null => false
      t.boolean :disputed,        :default => false, :null => false

      t.timestamps
    end
    add_index :transfers, :from_account_id
    add_index :transfers, :to_account_id
    add_index :transfers, :user_id
    add_index :transfers, :group_id
  end
end
