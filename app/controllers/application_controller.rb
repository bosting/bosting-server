# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  private

  def set_parent_hosting_server
    @hosting_server = HostingServer.find(params[:hosting_server_id])
  end
end
