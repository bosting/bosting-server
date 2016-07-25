class CreateHostingServers < ActiveRecord::Migration
  def change
    create_table :hosting_servers do |t|
      t.string :name, null: false
      t.string :fqdn, null: false
      t.string :server_domain, null: false
      t.string :panel_domain, null: false
      t.boolean :panel_ssl, null: false
      t.string :cp_login, null: false
      t.string :cp_password, null: false
      t.string :ip, null: false
      t.integer :cores, null: false
      t.boolean :forward_agent, null: false
      t.string :ext_if, null: false
      t.string :int_if, null: false
      t.string :open_tcp_ports
      t.string :open_udp_ports
      t.integer :os_id, null: false
      t.string :ip, null: false
      t.integer :mysql_distrib_id
      t.string :mysql_version
      t.string :mysql_root_password, null: false
      t.string :default_mx, null: false
      t.integer :mail_delivery_method_id, null: false
      t.string :ns1_domain, null: false
      t.string :ns1_ip, null: false
      t.string :ns2_domain, null: false
      t.string :ns2_ip, null: false
      t.timestamps
    end
  end
end
