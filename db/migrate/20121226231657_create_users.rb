class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, :null => false
      t.string :last_name,  :null => false

      t.string :username, :null => false

      t.integer :user_type, :null => false

      t.timestamps
    end
  end
end
