# frozen_string_literal: true

module Transports
  # SSH session wrapper for commands and uploads
  class Ssh
    def initialize(credentials:, sudo:)
      @ssh_session = Net::SSH.start(credentials.host, credentials.user, credentials.options)
      @sudo = sudo
      ObjectSpace.define_finalizer(self, proc { @ssh_session.close })
    end

    def exec(cmd, options = {})
      options[:echo_output] ||= false
      options[:raise_error] ||= false

      output = @ssh_session.exec!(cmd_with_sudo(cmd))
      puts output if options[:echo_output]

      if options[:raise_error] && output.exitstatus.positive?
        raise "Error executing command: #{cmd}"
      end

      output
    end

    def exec!(cmd, options = {})
      options[:raise_error] = true
      exec(cmd, options)
    end

    def upload(src_filename, dst_filename, recursive: false)
      @ssh_session.scp.upload!(src_filename, dst_filename, recursive: recursive)
    end

    private

    def cmd_with_sudo(cmd)
      return cmd unless @sudo
      'sudo ' + cmd
    end
  end
end
