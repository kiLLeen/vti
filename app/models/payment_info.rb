class PaymentInfo < ActiveRecord::Base
  attr_accessor   :type, :number, :expire_month,
                  :expire_year, :cvv2, :address,
                  :city, :state, :zip

  belongs_to :account
  validates_associated :account

  def save(account)
    PaymentInfo.transaction do
      account.save!
      self.account_id = account.id
      self.save!
    end
  end
end
