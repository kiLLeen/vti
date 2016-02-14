class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :account_id
      t.integer :payment_info_id
      t.timestamps null: false
    end
  end
end
