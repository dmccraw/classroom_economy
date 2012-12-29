class CreateStoreOwners < ActiveRecord::Migration
  def change
    create_table :store_owners do |t|
      t.references :user
      t.references :store

      t.timestamps
    end
    add_index :store_owners, :user_id
    add_index :store_owners, :store_id
  end
end
