class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.date :birth_date
      t.string :address
      t.string :city
      t.string :state
      t.string :phone
      t.string :school
      t.string :hobby
      t.string :video_embed_url
      t.timestamps null: false
    end
  end
end
