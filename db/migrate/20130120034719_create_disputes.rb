class CreateDisputes < ActiveRecord::Migration
  def change
    create_table :disputes do |t|
      t.references :owner, polymorphic: true
      t.references :transaction
      t.references :group
      t.string :reason
      t.integer :result
      t.string :result_reason

      t.timestamps
    end
    add_index :disputes, :owner_id
    add_index :disputes, :owner_type
    add_index :disputes, :transaction_id
    add_index :disputes, :group_id

  end
end
