# frozen_string_literal: true

class HostingServer < ApplicationRecord
  CHEF_VERSION = '12.22.1'

  OSES = {
    1 => %w[FreeBSD freebsd],
    2 => %w[Debian debian]
  }.freeze

  CHEF_INSTALL_METHODS = {
    1 => 'omnitruck',
    2 => 'rubygems'
  }.freeze

  SSH_PERMIT_ROOT_LOGIN_TYPES = {
    1 => 'yes',
    2 => 'without-password',
    # 3 => 'no'
  }.freeze

  MYSQL_DISTRIBS = {
    1 => ['MySQL', %w[5.0 5.1 5.5 5.6 5.7]],
    2 => ['MariaDB', %w[5.1 5.2 5.3 5.5 10.0 10.1 10.2]]
  }.freeze

  PGSQL_VERSIONS = {
    1 => '9.0',
    2 => '9.1',
    3 => '9.2',
    4 => '9.3',
    5 => '9.4',
    6 => '9.5',
    7 => '9.6',
    8 => '10.0',
    9 => '10.1',
    10 => '10.2',
    11 => '10.3'
  }.freeze

  MAIL_DELIVERY_METHODS = {
    1 => [:sendmail, 'Sendmail'],
    2 => [:smtp, 'SMTP']
  }.freeze

  has_many :apache_variations
  has_many :smtp_settings

  validates :name, :fqdn, :server_domain, :panel_domain, :cp_login, :cp_password, :services_ips, :cores, :ext_if,
            :os_id, :chef_install_method_id, :mysql_distrib_id, :mysql_version, :mysql_root_password, :pgsql_version_id,
            :pgsql_root_password, :default_mx, :mail_delivery_method_id, :ns1_domain, :ns1_ip, :ns2_domain, :ns2_ip,
            :ssh_port_connect, :ssh_port_listen, :ssh_permit_root_login_id,
            presence: true

  validates :os_id, inclusion: OSES.keys
  validates :chef_install_method_id, inclusion: CHEF_INSTALL_METHODS.keys
  validates :ssh_permit_root_login_id, inclusion: SSH_PERMIT_ROOT_LOGIN_TYPES.keys
  validates :mysql_distrib_id, inclusion: MYSQL_DISTRIBS.keys
  validates :pgsql_version_id, inclusion: PGSQL_VERSIONS.keys
  validates :mail_delivery_method_id, inclusion: MAIL_DELIVERY_METHODS.keys

  def set_defaults
    self.cores = 2
    self.ssh_port_connect = 22
    self.ssh_port_listen = 22
    self.ssh_permit_root_login_id = 1
    self.mysql_distrib_id = 1
    self.mysql_version = '5.6'
    self.pgsql_version_id = 7
    self.mail_delivery_method_id = 1
  end

  def os
    OSES[os_id].last
  end

  def chef_install_method
    CHEF_INSTALL_METHODS[chef_install_method_id]
  end

  def to_chef_json
    hosting_server_hash = serializable_hash.slice(
      'fqdn', 'server_domain', 'panel_domain', 'cp_login', 'cp_password', 'cores', 'ext_if', 'int_if', 'mysql_version',
      'mysql_root_password', 'pgsql_root_password', 'default_mx', 'ns1_domain', 'ns1_ip', 'ns2_domain', 'ns2_ip',
      'open_tcp_ports', 'open_udp_ports', 'panel_ssl', 'ssh_port_listen'
    )

    hosting_server_hash['chef_install_method'] = chef_install_method
    hosting_server_hash['chef_version'] = CHEF_VERSION
    hosting_server_hash['mysql_distrib'] = MYSQL_DISTRIBS[mysql_distrib_id].first.downcase
    hosting_server_hash['pgsql_version'] = PGSQL_VERSIONS[pgsql_version_id]
    hosting_server_hash['delivery_method'] = MAIL_DELIVERY_METHODS[mail_delivery_method_id].first.to_sym
    hosting_server_hash['ssh_permit_root_login'] = SSH_PERMIT_ROOT_LOGIN_TYPES[ssh_permit_root_login_id]
    hosting_server_hash['smtp_settings'] = {}
    smtp_settings.each do |ss|
      hosting_server_hash['smtp_settings'][ss.name] = ss.value
    end
    hosting_server_hash['apache_variations'] = {}
    apache_variations.each do |av|
      hosting_server_hash['apache_variations'][av.name] = {
        ip: av.ip,
        apache_version: ApacheVariation::APACHE_VERSIONS[av.apache_version_id],
        php_version:    ApacheVariation::PHP_VERSIONS[av.php_version_id]
      }
    end
    hosting_server_hash['ssh_listen_ips'] =
      if ssh_listen_ips.present?
        (ssh_listen_ips.split(',') + services_ips.split(',')).uniq
      else
        services_ips.split(',')
      end
    hosting_server_hash['services_ips'] = services_ips.split(',')

    { 'bosting-cp': hosting_server_hash }.to_json
  end
end
