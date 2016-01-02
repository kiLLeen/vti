require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test 'accounts should save without information' do
    account = Account.new
    assert account.save, 'Could not save an account without properties'
  end

  test 'selecting invalid account id throws record not found' do
    assert_raise ActiveRecord::RecordNotFound do
      Account.find(-1)
    end
  end
end
