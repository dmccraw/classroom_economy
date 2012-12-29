class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :from_user
      t.references :to_user
      t.float :amount
      t.text :description

      t.timestamps
    end
    add_index :transactions, :from_user_id
    add_index :transactions, :to_user_id
  end
end
