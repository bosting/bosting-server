# frozen_string_literal: true

require 'chef_installers'
require 'chef_runners'
require 'transports'

# Starts installation for a given hosting server
class ServerBootstrapper
  def initialize(hosting_server)
    @hosting_server = hosting_server
  end

  def setup
    clone_cookbooks(Rails.root.join('tmp', 'cookbooks').to_s)

    os = @hosting_server.os.capitalize
    cookbook_path = Rails.root.join('tmp', 'cookbooks', 'bosting-cp').to_s
    vendor_path = Rails.root.join('tmp', 'vendor', 'cookbooks').to_s
    klass = Object.const_get("ChefRunners::#{os}")
    runner = klass.new(
      credentials:         credentials,
      chef_install_method: @hosting_server.chef_install_method,
      chef_version:        HostingServer::CHEF_VERSION,
      chef_recipes:        %w[bosting-cp::first_run bosting-cp],
      cookbook_path:       cookbook_path,
      vendor_path:         vendor_path,
      chef_json:           @hosting_server.to_chef_json
    )
    runner.setup
  end

  private

  def clone_cookbooks(path)
    FileUtils.rm_rf(path)
    `git clone https://github.com/bosting/bosting-cookbooks.git #{path}`
  end

  def credentials
    case @hosting_server.os
    when 'freebsd', 'debian'
      Transports::SshCredentials.new(@hosting_server)
    else
      raise "OS not supported: #{os}"
    end
  end
end
