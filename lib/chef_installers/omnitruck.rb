# frozen_string_literal: true

module ChefInstallers
  class Omnitruck < Base
    def install
      @transport.exec!('curl -LO https://omnitruck.chef.io/install.sh')
      @transport.exec!("bash ./install.sh -v #{@chef_version} && rm install.sh")
    end
  end
end
