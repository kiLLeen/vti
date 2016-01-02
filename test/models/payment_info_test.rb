require 'test_helper'

class PaymentInfoTest < ActiveSupport::TestCase
  test 'payment_infos should save without information' do
    payment_info = PaymentInfo.new
    assert payment_info.save(Account.new), 'Could not save an account without properties'
  end

  test 'created payment id should be selectable' do
    payment = PaymentInfo.new({ payment_id: "Test123" })
    payment.save(Account.new)
    payments = PaymentInfo.where(payment_id: "Test123")

    assert_not payments.empty?
  end

  test 'selecting invalid payment_info id throws record not found' do
    assert_raise ActiveRecord::RecordNotFound do
      PaymentInfo.find(-1)
    end
  end

  test 'payment_infos should save with an account_id' do
    payment_info = PaymentInfo.new
    payment_info.save(Account.new)

    assert_not_nil payment_info.account_id
    assert Account.find(payment_info.account_id)
  end

  test 'payment_infos should always have an account' do
    payment_info = PaymentInfo.new

    assert_raise ArgumentError do
      payment_info.save
    end
  end
end
