class Account < ActiveRecord::Base
  belongs_to :payer
  validates_associated :payer
end
