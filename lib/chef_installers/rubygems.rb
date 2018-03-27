# frozen_string_literal: true

module ChefInstallers
  class Rubygems < Base
    def install
      @transport.exec!("gem install chef -v #{@chef_version} --no-ri --no-doc")
    end
  end
end
