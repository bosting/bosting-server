class HostingServersController < ApplicationController
  before_action :set_hosting_server, only: [:edit, :setup, :update, :destroy]

  def index
    @hosting_servers = HostingServer.all
  end

  def new
    @hosting_server = HostingServer.new
    @hosting_server.set_defaults
  end

  def edit
  end

  def setup
    ServerSetupWorker.perform_async(@hosting_server.id)
  end

  def create
    @hosting_server = HostingServer.new(hosting_server_params)

    if @hosting_server.save
      redirect_to hosting_servers_path, notice: t('flash.hosting_server.create')
    else
      render :new
    end
  end

  def update
    if @hosting_server.update(hosting_server_params)
      redirect_to hosting_servers_path, notice: t('flash.hosting_server.update')
    else
      render :edit
    end
  end

  def destroy
    @hosting_server.destroy
    redirect_to hosting_servers_path, notice: t('flash.hosting_server.destroy')
  end

  private
  def set_hosting_server
    @hosting_server = HostingServer.find(params[:id])
  end

  def hosting_server_params
    params.require(:hosting_server).permit(:name, :fqdn, :services_ips, :ssh_ip_connect, :ssh_port_connect,
                                           :ssh_password, :ssh_listen_ips, :ssh_port_listen, :server_domain,
                                           :ssh_permit_root_login_id, :panel_domain, :panel_ssl, :cp_login,
                                           :cp_password, :cores, :forward_agent, :ext_if, :int_if, :open_tcp_ports,
                                           :open_udp_ports, :os_id, :mysql_distrib_id, :mysql_version,
                                           :mysql_root_password, :default_mx, :mail_delivery_method_id, :ns1_domain,
                                           :ns1_ip, :ns2_domain, :ns2_ip)
  end
end
