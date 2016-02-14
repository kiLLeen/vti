class AlterTableVotesAddPayerId < ActiveRecord::Migration
  def change
    add_column :votes, :payer_id, :integer
  end
end
