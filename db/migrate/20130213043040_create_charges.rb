class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.references :account
      t.references :group
      t.string :description
      t.float :amount

      t.timestamps
    end
    add_index :charges, :account_id
    add_index :charges, :group_id
  end
end
