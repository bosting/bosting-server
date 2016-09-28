class RenameHostingServersIpToServicesIps < ActiveRecord::Migration[5.0]
  def change
    rename_column :hosting_servers, :ip, :services_ips
  end
end
