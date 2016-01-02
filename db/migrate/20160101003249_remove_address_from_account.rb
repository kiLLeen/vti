class RemoveAddressFromAccount < ActiveRecord::Migration
  def change
    remove_column :accounts, :address
  end
end
