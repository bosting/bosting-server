# frozen_string_literal: true

class AddPostgreSqlFieldsToHostingServers < ActiveRecord::Migration[5.0]
  def up
    add_column :hosting_servers, :pgsql_version_id, :integer
    add_column :hosting_servers, :pgsql_root_password, :string

    HostingServer.reset_column_information
    HostingServer.all.each do |hosting_server|
      hosting_server.update!(
        pgsql_version_id: 7,
        pgsql_root_password: 'new password'
      )
    end

    change_column :hosting_servers, :pgsql_version_id, :integer, null: false
    change_column :hosting_servers, :pgsql_root_password, :string, null: false
  end

  def down
    remove_column :hosting_servers, :pgsql_version_id
    remove_column :hosting_servers, :pgsql_root_password
  end
end
