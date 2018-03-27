# frozen_string_literal: true

module Transports
  class RsyncUploader
    def initialize(credentials)
      @credentials = credentials
    end

    def upload!(src_path, dst_path)
      user = @credentials.user
      host = @credentials.host
      port = @credentials.port
      res = system("rsync -avzP --delete -e 'ssh -p #{port}' #{src_path} #{user}@#{host}:#{dst_path}")
      raise "Error uploading #{src_path} to #{dst_path}" unless res
    end
  end
end
