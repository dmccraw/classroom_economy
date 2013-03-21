class AddAmountAndDescriptionToBill < ActiveRecord::Migration
  def change
    add_column :bills, :amount, :float
    add_column :bills, :description, :string
  end
end
