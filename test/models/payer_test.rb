require 'test_helper'

class PayerTest < ActiveSupport::TestCase
  test 'payers should save without information' do
    payer = Payer.new
    assert payer.save(Account.new), 'Could not save an account without properties'
  end

  test 'created payment id should be selectable' do
    payment = Payer.new({ payment_id: "Test123" })
    payment.save_with_account(Account.new)
    payments = Payer.where(payment_id: "Test123")

    assert_not payments.empty?
  end

  test 'selecting invalid payer id throws record not found' do
    assert_raise ActiveRecord::RecordNotFound do
      Payer.find(-1)
    end
  end

  test 'payers should save with an account_id' do
    payer = Payer.new
    payer.save_with_account(Account.new)

    assert_not_nil payer.account_id
    assert Account.find(payer.account_id)
  end
end
