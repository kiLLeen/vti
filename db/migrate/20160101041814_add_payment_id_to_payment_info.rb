class AddPaymentIdToPaymentInfo < ActiveRecord::Migration
  def change
    add_column :payment_infos, :payment_id, :string
  end
end
