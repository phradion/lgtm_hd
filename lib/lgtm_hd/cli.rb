require 'rubygems'
require 'commander'
require 'os'
require 'clipboard'
require 'net/http'
require 'open-uri'
require 'uri'
require 'pry'

module LgtmHD
  class CLI
    include Commander::Methods

    def run
      program :name, LgtmHD::Configuration::PROGRAM_NAME
      program :version, LgtmHD::VERSION
      program :description, LgtmHD::Configuration::DESCRIPTION

      default_command :transform

      global_option '-c', '--clipboard', 'Copy the end result (LGTM image) to OS\'s clipboard for direct pasting to other programs'
      global_option '-i', '--interactive', 'Turn on interactive Mode. In case you forgot all these super complexive args and options' do say "-- LGTM HD Interactive Mode --" end

      command :random do |c|
        c.syntax = 'lgtm_hd random [--clipboard -c] [--interactive -i]'.freeze
        c.summary = 'Fetch random images from LGTM.in and put into destination directory'.freeze
        c.description = ''
        c.example 'Example', 'lgtm_hd random -c'

        c.action do |args, options|
          if options.interactive  # Interactive mode!
            input_dir = ask('[?] Destination Directory: ')
            options.clipboard ||= agree("[?] Copy LGTM image to clipboard afterward? [Y/N]")
          end
          dest_dir = CLI.format_destination_dir(input_dir)
          dest_file_prefix = CLI.format_destination_file_prefix
          say "\\ Fetching random image from lgtm.in"
          dest_uri,image_markdown = LgtmDotIn.fetch_random_image(dest_dir,dest_file_prefix) do |url, markdown|
            say "\\ Loading image at #{url}"
          end

          say "\\ Exported image to #{dest_uri}"
          if options.clipboard
             copy_file_to_clipboard(dest_uri)
             say "\\ Or you can copy the markdown format by lgtm.in directly below\n\n#{image_markdown}"
          end
        end
      end

      command :transform do |c|
        c.syntax = 'lgtm_hd <image_URI> <dest_DIR> [--clipboard|-c] [--interactive|-i]'.freeze
        c.summary = 'Generate a LGTM image from source_uri (local path or URL) into output folder'.freeze
        c.description = ''
        c.example 'Example', 'lgtm_hd transform http://domain.com/image.png /Users/lgtm/'

        c.action do |args, options|
          # ARGS validation!
          if args.length >= 2
              source_uri = args[0]
              dest_dir = args[1]
          elsif options.interactive  # Interactive mode!
            source_uri = ask('Source Image (URL or Path/to/file): ')
            dest_dir = ask('Destination Directory: ')
            options.clipboard ||= agree("Copy exported image to clipboard afterward? [Y/N]")
          else
            say "usage: lgtm_hd <source_img_URI> <dest_DIR> [--clipboard] [--interactive]"
            raise ArgumentError, "Too few arguments provided. Need to provide <source_image_uri> and <destination_dir>"
          end

          # Validate the inputs
          dest_file = CLI.format_destination_uri(source_uri, dest_uri)
          CLI.check_uris(dest_dir, source_uri)

          # Do stuff with our LGTM meme
          say "- Reading and inspecting source"
          meme_generator = MemeGenerator.new(input_image_uri:source_uri, output_image_uri:dest_file)
          say "- Rendering output"
          meme_generator.draw

          # Export and play around with the clipboard
          say "- exporting to file"
          meme_generator.export do |output|
            say "- Exported LGTM image to #{output}."
            if options.clipboard then
              CLI.copy_file_to_clipboard(output_file)
            end # end of if to_clipboard
          end # end of meme_generator.export block
        end # end of action
      end # end of command transform

      run!
    end # end run def

    private

    def copy_file_to_clipboard(output_file)
      if OS.mac? then
        applescript "set the clipboard to (read (POSIX file \"#{output_file}\") as GIF picture)"
        say "\\ Copied file to OS's clipboard for direct pasting to Github comments or Slack"

        # Apple Script Command reference
        # Sample: `osascript -e 'set the clipboard to (read (POSIX file "#{output}") as JPEG picture)'`
        #
        # Currently Github allow pasting image directly to comment box.
        # However it does not support pure text content produced by pbcopy so we have to use direct Applescript
        # No Universal solution as for now.
        #
        # Apple Script reference: http://www.macosxautomation.com/applescript/imageevents/08.html
      else
        Clipboard.copy(output_file)
        say "\\ Copied file's path to OS's clipboard"
      end
    end

    def self.check_uris(dest_dir, source_uri = nil)
      raise "Source is not proper URIs (URL or Path/to/file)" unless source_uri =~ URI::regexp || File.exist?(source_uri)
      if source_uri then return end
      raise "Output is invalid path or directory" unless File.exist?(dest_dir) && File.directory?(dest_dir)
    end

    def self.format_destination_dir(dest_dir)
      dest_dir ||= LgtmHD::Configuration::OUTPUT_PATH_DEFAULT
      File.expand_path(dest_dir)
    end
    def self.format_destination_file_prefix
      LgtmHD::Configuration::OUTPUT_PREFIX + Time.now.strftime('%Y%m%d%H%M%S')
    end

  end # end of Class
end # end of Module
