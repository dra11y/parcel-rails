# encoding: utf-8
require "pty"

module Parcel
  class ParcelWatcher
    attr_accessor :pid
    attr_reader :log, :config
    def initialize(log:, config:)
      @log = log
      @config = config
    end

    def run
      path = File.expand_path(config.parcel.bin_path).to_s
      # Right now this will just watch ALL files in each entrypoint folder:
      entrypoints = config.parcel.entrypoint_folders.map do |entrypoint|
        File.expand_path(entrypoint).to_s + '/*'
      end
      output_dir = ['-d', config.parcel.asset_output_folder.to_s]
      args = %w[watch].concat(entrypoints, output_dir)
      $stdout.puts("PARCEL-RAILS: #{path} #{args.join(' ')}")
      out, writer, self.pid = PTY.spawn(path, *args)
      writer.close

      Process.detach(pid)

      begin
        loop do
          output = out.readpartial(64.kilobytes).strip
          output.force_encoding("utf-8")

          log << output

          output = output.gsub(/\e\[([;\d]+)?m/, "")

          if output.match?(/Built in/)
            update_manifest!(output: output)
            broadcast(status: "success", message: output.split("info: ").last)

          # check for 🚨:
          # elsif output.bytes & [240, 159, 154, 168] == [240, 159, 154, 168]
          elsif output.match?(/🚨/)
            broadcast(status: "error", message: output.split("error: ").last)
          end
        end
      rescue EOFError, Errno::EIO
        log.fatal "[PARCEL-RAILS] Watcher died unexpectedly. Restart Rails Server"
        broadcast(
          status: "error",
          message: "Watcher died unexpectedly. Restart Rails server"
        )
      end
    end

    def terminate
      Process.kill("TERM", @pid)
    rescue Errno::ESRCH
      # NOOP. Process exited cleanly or already terminated. Don't print
      # exception to STDOUT
    end

    private

    def update_manifest!(output:)
      config.parcel.manifest ||= Parcel::Manifest.new(base_dir: config.parcel.asset_output_folder)
      $stdout.puts 'UPDATE MANIFEST!'
      # binding.pry
    end

    def broadcast(status:, message:)
      ActionCable.server.broadcast(STATUS_CHANNEL, {
        status: status,
        message: message
      })
    end
  end
end
