class VotesController < ApplicationController
  def index
    @accounts ||= Account.all
    @vote ||= Vote.new
    if @vote.payer
      @payer = Payer.new(@payer)
    end
  end

  def create
    respond_to do |format|
      @vote ||= Vote.new(vote_params)
      @vote.payer ||= Payer.new
      format.js
    end
  end

  def pay
    respond_to do |format|
      format.js
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:account_id, :payer_id,
                                 :first_name, :last_name)
  end

  def payer_params
    params.require(:payer).permit(:type, :number, :expire_month,
                                         :expire_year, :cvv2, :first_name,
                                         :last_name, :address, :city,
                                         :state, :zip)
  end
end
