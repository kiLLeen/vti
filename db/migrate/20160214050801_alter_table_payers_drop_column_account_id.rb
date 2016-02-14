class AlterTablePayersDropColumnAccountId < ActiveRecord::Migration
  def change
    remove_column :payers, :account_id
  end
end
