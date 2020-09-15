# frozen_string_literal: true

module Transports
  # Extracts SSH credentials for Net::SSH from hosting_server model
  class SshCredentials
    def initialize(hosting_server)
      @hosting_server = hosting_server
    end

    def host
      @host ||=
        if @hosting_server[:ssh_ip_connect].present?
          @hosting_server[:ssh_ip_connect]
        else
          @hosting_server[:services_ips].split(',').first
        end
    end

    def port
      @hosting_server[:ssh_port_connect]
    end

    def user
      'root'
    end

    def password
      nil
    end

    def options
      {
        keys_only: false,
        port: @hosting_server[:ssh_port_connect]
      }
    end
  end
end
