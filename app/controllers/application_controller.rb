class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  private
  def load_hosting_server
    @hosting_server = HostingServer.find(params[:hosting_server_id])
  end
end
