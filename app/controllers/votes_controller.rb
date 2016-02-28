require 'paypal-sdk-rest'

class VotesController < ApplicationController

  def index
    respond_to do |format|
      @accounts ||= Account.all
      @vote = Vote.new
      @vote.payer = Payer.new(payer_params) if payer_params
      @votes ||= Vote.all

      format.html
      format.js
    end
  end

  def create
    respond_to do |format|
      flash[:notice] = nil
      @accounts ||= Account.all
      @vote = Vote.new(vote_params)
      @vote.payer = Payer.new(payer_params)
      @payer = @vote.payer

      @vote.account = Account.find(@vote.account_id) if @vote.account_id.present?

      format.js
    end
  end

  def pay
    respond_to do |format|
      @accounts ||= Account.all
      @vote = Vote.new(vote_params)
      @payer = Payer.new(payer_params)
      @account = Account.find(@vote.account_id)

      @vote.payer = @payer
      @vote.account = @account

      raise "Invalid params" if (@vote.payer.nil? || @vote.account.nil?)

      vote

      format.js
    end
  end

  private

  def vote
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
                    :name => "Valley Teen Idol Vote",
                    :sku => "VTI-VOTE",
                    :price => "1",
                    :currency => "USD",
                    :quantity => @vote.quantity }]},
                    :amount => {
                      :total => @vote.quantity,
                      :currency => "USD" },
                      :description => "Valley Teen Idol Vote" }]})

    paypal_transaction = @payment.create
    if paypal_transaction
      @vote.payer.payment_id = @payment.id
      @vote.save
      @vote = Vote.new
      flash[:notice] = "Success! Thank you for voting!".html_safe
    else
      flash[:notice] = "Credit card information was not accepted by Paypal: <p><h5> #{@payment.error[:details]} </h5>".html_safe
    end
  end

  def vote_params
    params.require(:vote).permit(:account_id, :payer_id, :quantity)
  end

  def payer_params
    params.fetch(:payer, {}).permit(:type, :number, :expire_month,
                                    :expire_year, :cvv2, :first_name,
                                    :last_name, :address, :city,
                                    :state, :zip)
  end
end
