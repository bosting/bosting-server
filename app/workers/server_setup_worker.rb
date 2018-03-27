# frozen_string_literal: true

class ServerSetupWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform(hosting_server_id)
    hosting_server = HostingServer.find(hosting_server_id)
    bootstrapper = ServerBootstrapper.new(hosting_server)
    bootstrapper.setup
  end
end
