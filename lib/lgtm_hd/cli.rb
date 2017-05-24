require 'rubygems'
require 'commander'
require 'os'
require 'lgtm_hd'
require 'net/http'
require 'tempfile'
require 'clipboard'
require 'uri'

module LgtmHD
  class CLI
    include Commander::Methods

    def run
      program :name, LgtmHD::Configuration::PROGRAM_NAME
      program :version, LgtmHD::VERSION
      program :description, LgtmHD::Configuration::DESCRIPTION
      default_command :export

      command :transform do |c|
        c.syntax = 'lgtm_hd transform <source_uri> <output_uri> [options]'
        c.summary = 'Generate a LGTM image from source_uri (local path or URL) into output_uri (local)'
        c.description = ''
        c.example '', 'lgtm_hd export http://domain.com/image.png /path/to/lgtm.png'
        c.option '--clipboard', 'Copy the end result (LGTM image) to OS\'s clipboard'

        c.action do |args, options|
          # TODO add validation for args
          uri = URI.parse(args[0])
          tmp_file_name = Time.now.strftime('%Y-%m-%d_%H-%M-%S') << LgtmHD::Configuration::TEMP_FILE_PREFIX

          meme_generator = MemeGenerator.new(*args)
          meme_generator.draw

          meme_generator.export do |output|
            say "LGTM image has been generated at #{output}."
            if not options.clipboard then return; end
            if OS.mac? then
              applescript "set the clipboard to (read (POSIX file \"#{output}\") as GIF picture)"
              say "I see you are using MacOSX. Content of the file has been copied to your clipboard."

              #{}`osascript -e 'set the clipboard to (read (POSIX file "#{output}") as JPEG picture)'`
              # Note on 2017/05/22
              # Currently Github allow pasting image directly to comment box.
              # However it does not support pure text content produced by pbcopy so we have to use direct Applescript
              # No Universal solution as for now.
              #
              # Apple Script reference: http://www.macosxautomation.com/applescript/imageevents/08.html
            else
              Clipboard.copy(output)
              say "Path to LGTM file has been copied to your clipboard."
            end
          end

        end

      end

      run!
    end
  end
end
