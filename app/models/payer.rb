class Payer < ActiveRecord::Base
  attr_accessor   :type, :number, :expire_month,
                  :expire_year, :cvv2, :address,
                  :city, :state, :zip
end
