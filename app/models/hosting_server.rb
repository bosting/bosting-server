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
      1 => ['MySQL', %w(5.0 5.1 5.5 5.6 5.7)],
      2 => ['MariaDB', %w(5.1 5.2 5.3 5.5 10.0 10.1)]
  }

  MAIL_DELIVERY_METHODS = {
      1 => [:sendmail, 'Sendmail'],
      2 => [:smtp, 'SMTP']
  }

  CHEF_VERSION = '12.14.77'

  def to_chef_json
    hosting_server_hash = serializable_hash
    hosting_server_hash.keep_if do |key, value|
      %w(
        fqdn server_domain panel_domain cp_login cp_password ip cores ext_if int_if mysql_version mysql_root_password
        default_mx ns1_domain ns1_ip ns2_domain ns2_ip forward_agent open_tcp_ports open_udp_ports panel_ssl
      ).include?(key)
    end
    hosting_server_hash['mysql_distrib'] = MYSQL_DISTRIBS[mysql_distrib_id].first.downcase
    hosting_server_hash['delivery_method'] = MAIL_DELIVERY_METHODS[mail_delivery_method_id].first.to_sym
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

  def setup
    os = OSES[self.os_id].last
    case os
      when 'freebsd'
        pkg_update_cmd = 'pkg upgrade -y'
        pkg_install_cmd = 'pkg install -y'
      when 'debian'
        pkg_update_cmd = 'apt-get update && apt-get -y upgrade'
        pkg_install_cmd = 'apt-get install -y'
      else
        raise "OS not supported: #{os}"
    end

    `rm -rf ./tmp/cookbooks`
    `git clone git@github.com:bosting/bosting-cookbooks.git ./tmp/cookbooks`
    Bundler.with_clean_env do
      `berks vendor --berksfile=./tmp/cookbooks/bosting-cp/Berksfile ./tmp/cookbooks/vendor/cookbooks`
    end

    Net::SSH.start(self.ip, 'root', forward_agent: self.forward_agent) do |ssh|
      unless command_available?(ssh, 'chef-client')
        bosting_ssh_exec!(ssh, pkg_update_cmd)
        bosting_ssh_exec!(ssh, pkg_install_cmd + ' curl bash rsync')
        bosting_ssh_exec!(ssh, "curl -LO https://omnitruck.chef.io/install.sh")
        bosting_ssh_exec!(ssh, "bash ./install.sh -v #{CHEF_VERSION} && rm install.sh")
      end
      `rsync -avzP --delete #{Rails.root + 'tmp/cookbooks/vendor/cookbooks'} root@#{ip}:/root`
      bosting_ssh_exec!(ssh, "echo '#{to_chef_json}' | chef-client --local-mode --runlist 'recipe[bosting-cp]' " +
          "--json-attributes /dev/stdin --logfile /var/log/chef-client")
    end
  end

  private
  def bosting_ssh_exec(ssh, cmd, echo = true)
    SshExec.ssh_exec!(ssh, cmd, echo ? {echo_stdout: true, echo_stderr: true} : {})
  end

  def bosting_ssh_exec!(ssh, cmd, echo = true)
    res = bosting_ssh_exec(ssh, cmd, echo)
    if res.exit_status != 0
      raise "Error executing command: #{cmd}\nstdout: #{res.stdout}\nstderr: #{res.stderr}"
    end
  end

  def command_available?(ssh, cmd)
    bosting_ssh_exec(ssh, cmd, false).stderr != "#{cmd}: Command not found.\n"
  end
end
