class AddChefInstallMethodIdToHostingServers < ActiveRecord::Migration[5.0]
  def up
    add_column :hosting_servers, :chef_install_method_id, :integer

    HostingServer.reset_column_information
    HostingServer.update_all(chef_install_method_id: 1)

    change_column :hosting_servers, :chef_install_method_id, :integer, null: false
  end

  def down
    remove_column :hosting_servers, :chef_install_method_id
  end
end
