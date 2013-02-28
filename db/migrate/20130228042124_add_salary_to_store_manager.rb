class AddSalaryToStoreManager < ActiveRecord::Migration
  def change
    add_column :store_managers, :salary, :float

    StoreManager.all.each do |store_manager|
      store_manager.salary = 0.0
      store_manager.save
    end
  end
end
