class CreateStoreManagers < ActiveRecord::Migration
  def change
    create_table :store_managers do |t|
      t.references :store
      t.references :user
      t.integer :manage_level

      t.timestamps
    end
    add_index :store_managers, :store_id
    add_index :store_managers, :user_id
  end
end
