require 'paypal-sdk-rest'

class AccountsController < ApplicationController
  START_DATE = '2016-12-1';
  END_DATE = '2017-1-1';

  def new
    @account = Account.new
    @payer = Payer.new

    render :index
  end

  def index
    @account ||= Account.new
    @payer ||= Payer.new
  end

  def create
    @account ||= Account.new(account_params)
    @payer ||= Payer.new(payer_params)

    if register
      redirect_to :accounts, notice: flash[:notice]
    else
      render :index
    end

  end

  private

  def register
    PayPal::SDK::Core::Config.load('config/paypal.yml',  ENV['RACK_ENV'] || 'development')

    @payment = PayPal::SDK::REST::Payment.new({
      :intent => "sale",
      :payer => {
        :payment_method => "credit_card",
        :funding_instruments => [{
          :credit_card => {
            :type => @payer.type,
            :number => @payer.number,
            :expire_month => @payer.expire_month,
            :expire_year => @payer.expire_year,
            :cvv2 => @payer.cvv2,
            :first_name => @payer.first_name,
            :last_name => @payer.last_name,
            :billing_address => {
              :line1 => @payer.address,
              :city => @payer.city,
              :state => @payer.state,
              :postal_code => @payer.zip,
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
      @payer.payment_id = @payment.id
      @account.payer = @payer
      @account.save
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

  def payer_params
    params.require(:payer).permit(:type, :number, :expire_month,
                                         :expire_year, :cvv2, :first_name,
                                         :last_name, :address, :city,
                                         :state, :zip)
  end
end
