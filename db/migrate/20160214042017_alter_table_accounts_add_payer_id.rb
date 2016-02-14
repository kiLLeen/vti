class AlterTableAccountsAddPayerId < ActiveRecord::Migration
  def change
    add_column :accounts, :payer_id, :integer
  end
end
