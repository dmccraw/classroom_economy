class ConvertTransactionToTransfer < ActiveRecord::Migration
  def change
    # execute "ALTER TABLE transactions RENAME TO Transfers" rescue nil
    # execute "ALTER TABLE bills RENAME COLUMN transaction_id to transfer_id" rescue nil
    # execute "ALTER TABLE disputes RENAME COLUMN transaction_id to transfer_id" rescue nil
    # execute "ALTER TABLE disputes RENAME COLUMN result_transaction_id to result_transfer_id" rescue nil
  end
end
