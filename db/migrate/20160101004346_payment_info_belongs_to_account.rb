class PaymentInfoBelongsToAccount < ActiveRecord::Migration
  def change
    change_table :payment_infos do |t|
      t.references :account
    end
  end
end
