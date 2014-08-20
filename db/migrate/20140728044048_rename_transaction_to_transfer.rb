class RenameTransactionToTransfer < ActiveRecord::Migration
  def change
    rename_table :transactions, :transfers if table_exists? :transactions
    rename_column :disputes, :transaction_id, :transfer_id if column_exists? :disputes, :transaction_id
    rename_column :disputes, :result_transaction_id, :result_transfer_id if column_exists? :disputes, :result_transaction_id
    rename_column :bills, :transaction_id, :transfer_id if column_exists? :bills, :transaction_id
  end
end
