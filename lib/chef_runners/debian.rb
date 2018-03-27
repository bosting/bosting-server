# frozen_string_literal: true

module ChefRunners
  class Debian < Unix #:nodoc:
    def packages
      super + %w[ruby2.1 ruby2.1-dev]
    end

    def package_installed?(package_name)
      # https://askubuntu.com/questions/423355/how-do-i-check-if-a-package-is-installed-on-my-server/668229#668229
      @ssh.exec!("/usr/bin/dpkg-query --show --showformat='${db:Status-Status}\n' #{package_name}") == "installed\n"
    end

    def install_package_command(package_name)
      @ssh.exec!('apt-get -y install ' + package_name)
    end
  end
end
