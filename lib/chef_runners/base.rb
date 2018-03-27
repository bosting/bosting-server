# frozen_string_literal: true

module ChefRunners
  # Installs packages, Chef, uploads cookbooks and runs them
  class Base
    def initialize(credentials:, chef_install_method:, chef_version:, chef_recipes:, cookbook_path:, vendor_path:,
                   chef_json:)
      @credentials         = credentials
      @chef_install_method = chef_install_method
      @chef_recipes        = chef_recipes
      @cookbook_path       = cookbook_path
      @vendor_path         = vendor_path
      @chef_json           = chef_json

      klass = Object.const_get("ChefInstallers::#{chef_install_method.capitalize}")
      @chef_installer = klass.new(transport: @transport, chef_version: chef_version)
    end

    def setup
      packages.each { |package| install_package(package) }
      install_chef
      vendor_cookbooks
      upload_cookbooks
      @chef_recipes.each { |recipe| run_chef_cookbook(recipe) }
    end

    private

    def packages
      %w[bash curl rsync]
    end

    def install_package(package_name)
      return if package_installed?(package_name)
      puts "Installing #{package_name}..."
      install_package_command(package_name)
    end


    def install_chef
      return if command_available?('chef-client')
      puts 'Installing Chef...'
      @chef_installer.install
    end

    def vendor_cookbooks
      FileUtils.rm_rf(@vendor_path)
      Bundler.with_clean_env do
        res = system('berks vendor ' \
        "--berksfile=#{@cookbook_path}/Berksfile " +
        @vendor_path)
        raise 'Berks not found, please install chef-dk' if res.nil?
        raise 'Berks error' unless res
      end
    end

    def upload_cookbooks
      puts 'Uploading Chef cookbooks...'
      return upload_cookbooks_with_rsync(@vendor_path) if use_rsync?
      puts 'WARNING! Please install rsync for faster upload'.red
      upload_cookbooks_with_scp(@vendor_path)
    end

    def run_chef_cookbook(recipe_name)
      puts "Running Chef recipe '#{recipe_name}'..."
      @transport.exec!(
        "echo '#{@chef_json}' | chef-client " \
        '--local-mode ' \
        "--runlist 'recipe[#{recipe_name}]' " \
        '--json-attributes /dev/stdin ' \
        '--logfile /var/log/chef-client',
        echo_output: true
      )
    end
  end
end
