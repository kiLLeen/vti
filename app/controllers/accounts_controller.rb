require 'paypal-sdk-rest'

class AccountsController < ApplicationController
  include PayPal::SDK::REST

  def new
    @account = Account.new
    @payment_info = PaymentInfo.new

    render :index
  end

  def show
  end

  def index
    @account ||= Account.new
    @payment_info ||= PaymentInfo.new
  end

  def create
    @account ||= Account.new(account_params)
    @payment_info ||= PaymentInfo.new(payment_info_params)

    if register
      redirect_to :accounts, notice: flash[:notice]
    else
      render :index
    end

  end

  private

  def register
    PayPal::SDK::Core::Config.load('config/paypal.yml',  ENV['RACK_ENV'] || 'development')

    @payment = Payment.new({
      :intent => "sale",
      :payer => {
        :payment_method => "credit_card",
        :funding_instruments => [{
          :credit_card => {
            :type => @payment_info.type,
            :number => @payment_info.number,
            :expire_month => @payment_info.expire_month,
            :expire_year => @payment_info.expire_year,
            :cvv2 => @payment_info.cvv2,
            :first_name => @payment_info.first_name,
            :last_name => @payment_info.last_name,
            :billing_address => {
              :line1 => @payment_info.address,
              :city => @payment_info.city,
              :state => @payment_info.state,
              :postal_code => @payment_info.zip,
              :country_code => "US" }}}]},
              :transactions => [{
                :item_list => {
                  :items => [{
                    :name => "Valley Teen Idol Registration",
                    :sku => "VTI-REG",
                    :price => "25",
                    :currency => "USD",
                    :quantity => 1 }]},
                    :amount => {
                      :total => "25.00",
                      :currency => "USD" },
                      :description => "Valley Teen Idol Registration" }]})

    paypal_transaction = @payment.create
    if paypal_transaction
      @payment_info.save_with_account @account
      flash[:notice] = "Congratulations, you have been submitted as a contestant to Valley Teen Idol".html_safe
    else
      flash[:notice] = "Credit card information was not accepted by Paypal: <p><h5> #{@payment.error[:details]} </h5>".html_safe
    end

    paypal_transaction
  end

  def account_params
    params.require(:account).permit(:first_name, :last_name, :gender,
                                    :birth_date, :city, :state, :email,
                                    :school, :hobby, :video_embed_url,
                                    :phone)
  end

  def payment_info_params
    params.require(:payment_info).permit(:type, :number, :expire_month,
                                         :expire_year, :cvv2, :first_name,
                                         :last_name, :address, :city,
                                         :state, :zip)
  end
end
