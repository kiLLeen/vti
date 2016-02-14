class VotesController < ApplicationController
  def index
    @accounts = Account.all
    @vote = Vote.new
  end

  def payment
    @vote = Vote.new(vote_params)
    @payment_info ||= PaymentInfo.new
    @votee = Account.find(@vote.try(:account_id))
  end

  def create
    @vote ||= Vote.new(vote_params)
    @payment_info ||= PaymentInfo.new(payment_info_params)
  end

  def vote_params
    params.require(:vote).permit(:account_id, :payment_info_id,
                                 :first_name, :last_name)
  end

  def payment_info_params
    params.require(:payment_info).permit(:type, :number, :expire_month,
                                         :expire_year, :cvv2, :first_name,
                                         :last_name, :address, :city,
                                         :state, :zip)
  end
end
