# frozen_string_literal: true

module ChefRunners
  class Freebsd < Unix #:nodoc:
    def packages
      super + %w[ruby rubygem-gems]
    end

    def package_installed?(package_name)
      @transport.exec("pkg info #{package_name}").exitstatus.zero?
    end

    def install_package_command(package_name)
      @transport.exec!("pkg install -y #{package_name}")
    end
  end
end
