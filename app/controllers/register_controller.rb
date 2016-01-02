class RegisterController < ApplicationController
  YOUTUBE_EMBED_URL = 'https://www.youtube.com/embed/'
  YOUTUBE_EMBED_ID = 'embedded_video'

  def create
    @account = params[:account] || Account.new
    @payment_info = params[:payment_info] || PaymentInfo.new
    render :index
  end

  def index
    @account ||= Account.new
    @payment_info ||= PaymentInfo.new
    @embedded_video = %Q{<iframe width="560" height="315" src="#{YOUTUBE_EMBED_URL}" frameborder="0" allowfullscreen id="#{YOUTUBE_EMBED_ID}"></iframe>}.html_safe
  end
end
