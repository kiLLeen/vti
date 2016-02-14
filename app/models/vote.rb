class Vote < ActiveRecord::Base
  belongs_to :account
  validates_associated :payer
  belongs_to :payer
  validates_associated :payer
end
