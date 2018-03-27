# frozen_string_literal: true

module ChefInstallers
  # Installs Chef
  # Bootstrapper will NOT upgrade Chef client if an older/different version is installed
  class Base #nodoc:
    def initialize(transport:, chef_version:)
      @transport    = transport
      @chef_version = chef_version
    end
  end
end
