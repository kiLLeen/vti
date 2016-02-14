class AlterTableVotesDropPaymentInfoId < ActiveRecord::Migration
  def change
    remove_column :votes, :payment_info_id
  end
end
