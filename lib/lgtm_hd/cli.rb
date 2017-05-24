require 'rubygems'
require 'commander'
require 'os'
require 'lgtm_hd'
require 'net/http'
require 'tempfile'
require 'uri'

module LgtmHD
  class CLI
    include Commander::Methods

    def run
      program :name, LgtmHD::Configuration::PROGRAM_NAME
      program :version, LgtmHD::VERSION
      program :description, LgtmHD::Configuration::DESCRIPTION
      default_command :export

      command :export do |c|
        c.syntax = 'lgtm_hd [options]'
        c.summary = ''
        c.description = ''
        c.example 'description', 'lgtm_hd export http://domain.com/image.png /path/to/lgtm.png'
        c.option '--interactive', 'Turns on interactive mode for adjusting the LGTM text and color'
        c.option '--clipboard', 'Copy the end result (LGTM image) to OS\'s clipboard'

        c.action do |args, options|
          # TODO add validation for args
          uri = URI.parse(args[0])
          tmp_file_name = Time.now.strftime('%Y-%m-%d_%H-%M-%S') << LgtmHD::Configuration::TEMP_FILE_PREFIX

          # TODO add file or URI independent stream
          # Net::HTTP.start(uri.host, uri.port) do |http|
          #   resp = http.get(uri.path)
          #   file = Tempfile.new(tmp_file_name)
          #   file.binmode
          #   file.write(resp.body)
          #   file.flush
          #   file
          # end

          meme_generator = MemeGenerator.new(*args)
          meme_generator.draw
          meme_generator.export do |output|
            if OS.mac? then
              `osascript -e 'set the clipboard to (read (POSIX file "#{output}") as JPEG picture)'`
              # Note on 2017/05/22
              # Currently Github allow pasting image directly to comment box.
              # However it does not support pure text content produced by pbcopy so we have to use direct Applescript
              # No Universal solution as for now.
              #
              # Apple Script reference: http://www.macosxautomation.com/applescript/imageevents/08.html
            end
          end
        end

      end

      run!
    end
  end
end
