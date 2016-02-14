class RenamePaymentInfosToPayers < ActiveRecord::Migration
  def change
    rename_table :payment_infos, :payers
  end
end
