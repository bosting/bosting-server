# frozen_string_literal: true

module ChefRunners
  # Base class for BSD and Linux
  class Unix < Base
    def initialize(credentials:, chef_install_method:, chef_version:, chef_recipes:, cookbook_path:, vendor_path:,
                   chef_json:)
      @transport      = Transports::Ssh.new(credentials: credentials, sudo: false)
      @rsync_uploader = Transports::RsyncUploader.new(credentials)
      super
    end

    def command_available?(cmd)
      @transport.exec('command -v ' + cmd) != ''
    end

    def upload_cookbooks_with_scp(src_path)
      @transport.exec('rm -rf cookbooks')
      @transport.upload!(src_path, 'cookbooks', recursive: true)
    end

    def upload_cookbooks_with_rsync(src_path)
      @rsync_uploader.upload!(src_path, '/root')
    end

    def use_rsync?
      rsync_installed_locally?
    end

    def rsync_installed_locally?
      system('rsync --version > /dev/null')
    end
  end
end
