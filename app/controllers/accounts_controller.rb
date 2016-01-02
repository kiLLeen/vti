require 'paypal-sdk-rest'

class AccountsController < ApplicationController
  include PayPal::SDK::REST

  def index
  end

  def show
  end

  def create
    @account = Account.new(account_params)
    @payment_info = PaymentInfo.new(payment_info_params)

    p params[:account].inspect
    p params[:payment_info].inspect
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

    if @payment.create
      @payment_info.save @account
      redirect_to :back, notice: "You have been submitted as a contestant to Valley Teen Idol"
    else
      @payment.error
      redirect_to :back, notice: "Credit card information not accepted by paypal"
    end

  end

  private

  def account_params
    params.require(:account).permit(:first_name, :last_name, :gender,
                                    :birth_date, :city, :state,
                                    :school, :hobby, :video_embed_url,
                                    :phone)
  end

  def payment_info_params
    params.require(:payment_info).permit(:type, :number, :expire_month,
                                         :expire_year, :cvv2, :first_name,
                                         :last_name, :address, :city,
                                         :state, :zip )
  end
end
