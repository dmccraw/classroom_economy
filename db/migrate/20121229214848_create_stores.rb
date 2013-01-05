class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.text :description
      t.references :group

      t.timestamps
    end
    add_index :stores, :group_id

  end
end
