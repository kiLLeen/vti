class CopyPayerIdToAccountsTable < ActiveRecord::Migration
  def change
    Payer.find_each do |p|
      account = Account.find(p.account_id)
      if account.present?
        account.payer_id = p.id
        account.save
      end
    end
  end
end
