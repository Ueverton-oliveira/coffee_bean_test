require "net/http"
class HomeController < ApplicationController
  before_action :require_login

  def index
    @user = User.new(session[:user])
    @ipInfo = request_infos
    render :index
  end

  def request_infos
    ActiveSupport::JSON.decode(
      Net::HTTP.get(
        URI("https://ipinfo.io/#{request.remote_ip}?token=" + ENV["IP_INFO_TOKEN"])
      )
    )
  end

  private
  def require_login
    redirect_to users_path unless session[:user_auth]
  end
end
