class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name,       :null => false
      t.text :description
      t.boolean :approved,  :null => false, :default => false
      t.references :group,  :null => false

      t.timestamps
    end
    add_index :stores, :group_id

  end
end
