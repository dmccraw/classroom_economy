class AddPaidToBills < ActiveRecord::Migration
  def change
    add_column :bills, :paid, :boolean
    add_column :bills, :paid_date, :datetime
    add_column :bills, :transfer_id, :integer
  end
end
