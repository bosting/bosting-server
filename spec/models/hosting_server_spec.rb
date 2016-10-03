require 'rails_helper'

RSpec.describe HostingServer, type: :model do
  before(:all) do
    @hosting_server = HostingServer.create!(
        name:'freebsd_test',
        fqdn: 'ns1.bosting.net',
        server_domain: 'bosting.net',
        panel_domain: 'cp.bosting.net',
        panel_ssl: false,
        cp_login: 'admin@bosting.net',
        cp_password: 'cp_password',
        services_ips: '10.37.132.10',
        cores: 4,
        forward_agent: false,
        ext_if: 'em0',
        int_if: 'em1 tun0',
        open_tcp_ports: '',
        open_udp_ports: '',
        os_id: 1,
        mysql_distrib_id: 1,
        mysql_version: '5.6',
        mysql_root_password: 'mysql_password',
        pgsql_version_id: 7,
        pgsql_root_password: 'pgsql_password',
        default_mx: 'mx.bosting.net',
        mail_delivery_method_id: 1,
        ns1_domain: 'ns1.bosting.net',
        ns1_ip: '10.37.132.10',
        ns2_domain: 'ns2.bosting.net',
        ns2_ip: '10.37.132.101',
        ssh_port_connect: '22',
        ssh_listen_ips: nil,
        ssh_port_listen: '22',
        ssh_permit_root_login_id: 1
    )

    [
        ['apache22_php55', '10.0.0.4', 3, 6],
        ['apache22_php56', '10.0.0.5', 3, 7],
        ['apache24_php70', '10.0.0.6', 4, 8]
    ].each do |name, ip, apache_version_id, php_version_id|
      ApacheVariation.create!(name: name, ip: ip, apache_version_id: apache_version_id,
                              php_version_id: php_version_id, hosting_server_id: @hosting_server.id)
    end

    [
        [:address, 'smtp.bosting.net'],
        [:port, '25'],
        [:domain, 'smtp.bosting.net'],
        [:authentication, 'plain'],
        [:user_name, 'smtp_login'],
        [:password, 'smtp_password']
    ].each do |name, value|
      SmtpSetting.create!(name: name, value: value, hosting_server_id: @hosting_server.id)
    end
  end

  specify 'JSON for Chef' do
    expect(JSON.parse(@hosting_server.to_chef_json)).to(
        match_json_expression(
            {
                "bosting-cp" =>
                    {
                        "cp_login":"admin@bosting.net",
                        "cp_password":"cp_password",
                        "services_ips":["10.37.132.10"],
                        "ssh_listen_ips":["10.37.132.10"],
                        "ssh_port_listen":"22",
                        "ssh_permit_root_login":"yes",
                        "cores":4,
                        "forward_agent":false,
                        "ext_if":"em0",
                        "int_if":"em1 tun0",
                        "open_tcp_ports":"",
                        "open_udp_ports":"",
                        "fqdn":"ns1.bosting.net",
                        "server_domain":"bosting.net",
                        "panel_domain":"cp.bosting.net",
                        "panel_ssl":false,
                        "ns1_domain":"ns1.bosting.net",
                        "ns1_ip":"10.37.132.10",
                        "ns2_domain":"ns2.bosting.net",
                        "ns2_ip":"10.37.132.101",
                        "delivery_method":"sendmail",
                        "smtp_settings":
                            {
                                "address": 'smtp.bosting.net',
                                "port": '25',
                                "domain": 'smtp.bosting.net',
                                "authentication": 'plain',
                                "user_name": 'smtp_login',
                                "password": 'smtp_password'
                            },
                        "default_mx":"mx.bosting.net",
                        "mysql_distrib":"mysql",
                        "mysql_version":"5.6",
                        "mysql_root_password":"mysql_password",
                        "pgsql_version":"9.6",
                        "pgsql_root_password":"pgsql_password",
                        "apache_variations":
                            {
                                "apache22_php55":
                                    {
                                        "ip":"10.0.0.4",
                                        "apache_version":"2.2",
                                        "php_version":"5.5"
                                    },
                                "apache22_php56":
                                    {
                                        "ip":"10.0.0.5",
                                        "apache_version":"2.2",
                                        "php_version":"5.6"
                                    },
                                "apache24_php70":
                                    {
                                        "ip":"10.0.0.6",
                                        "apache_version":"2.4",
                                        "php_version":"7.0"
                                    }
                            }
                    }
            }
        )
    )
  end

  it 'should set alternative ssh listen ips' do
    @hosting_server.ssh_listen_ips = '10.37.132.20,10.37.132.21'
    @hosting_server.services_ips = '10.37.132.10'
    expect(JSON.parse(@hosting_server.to_chef_json)['bosting-cp']['ssh_listen_ips'])
        .to match_array(%w(10.37.132.10 10.37.132.20 10.37.132.21))
  end

  it 'should set multiple services_ips' do
    @hosting_server.ssh_listen_ips = nil
    @hosting_server.services_ips = '10.37.132.20,10.37.132.21'
    expect(JSON.parse(@hosting_server.to_chef_json)['bosting-cp']['services_ips']).to eq(%w(10.37.132.20 10.37.132.21))
  end
end
