class HostingServer < ApplicationRecord
  has_many :apache_variations
  has_many :smtp_settings

  validates :name, :fqdn, :server_domain, :panel_domain, :cp_login, :cp_password, :ip, :cores, :ext_if, :os_id,
            :mysql_distrib_id, :mysql_version, :mysql_root_password, :default_mx, :mail_delivery_method_id,
            :ns1_domain, :ns1_ip, :ns2_domain, :ns2_ip,
            presence: true

  OSES = {
      1 => %w(FreeBSD freebsd),
      2 => %w(Debian debian)
  }

  MYSQL_DISTRIBS = {
      1 => ['MySQL', %(5.0 5.1 5.5 5.6 5.7)],
      2 => ['MariaDB', %(5.1 5.2 5.3 5.5 10.0 10.1)]
  }

  MAIL_DELIVERY_METHODS = {
      1 => [:sendmail, 'Sendmail'],
      2 => [:smtp, 'SMTP']
  }

  CHEF_VERSION = '12.12.15'

  def to_chef_json
    hosting_server_hash = serializable_hash
    hosting_server_hash.keep_if do |key, value|
      %w(
        fqdn server_domain panel_domain cp_login cp_password ip cores ext_if int_if mysql_version mysql_root_password
        default_mx ns1_domain ns1_ip ns2_domain ns2_ip forward_agent open_tcp_ports open_udp_ports panel_ssl
      ).include?(key)
    end
    hosting_server_hash['mysql_distrib'] = MYSQL_DISTRIBS[mysql_distrib_id].first.downcase
    hosting_server_hash['delivery_method'] = MAIL_DELIVERY_METHODS[mail_delivery_method_id].first
    hosting_server_hash['smtp_settings'] = {}
    smtp_settings.each do |ss|
      hosting_server_hash['smtp_settings'][ss.name] = ss.value
    end
    hosting_server_hash['apache_variations'] = {}
    apache_variations.each do |av|
      hosting_server_hash['apache_variations'][av.name] = {
          ip: av.ip,
          apache_version: ApacheVariation::APACHE_VERSIONS[av.apache_version_id],
          php_version: ApacheVariation::PHP_VERSIONS[av.php_version_id]
      }
    end

    { 'bosting-cp' => hosting_server_hash }.to_json
  end
end
