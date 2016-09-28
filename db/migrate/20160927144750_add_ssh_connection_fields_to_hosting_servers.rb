class AddSshConnectionFieldsToHostingServers < ActiveRecord::Migration[5.0]
  def change
    add_column :hosting_servers, :ssh_ip_connect, :string
    add_column :hosting_servers, :ssh_port_connect, :integer
    add_column :hosting_servers, :ssh_password, :string
    add_column :hosting_servers, :ssh_listen_ips, :string
    add_column :hosting_servers, :ssh_port_listen, :string
    add_column :hosting_servers, :ssh_permit_root_login_id, :integer
  end
end
