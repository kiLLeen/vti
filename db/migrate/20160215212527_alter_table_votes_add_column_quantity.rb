class AlterTableVotesAddColumnQuantity < ActiveRecord::Migration
  def change
    add_column :votes, :quantity, :integer
  end
end
