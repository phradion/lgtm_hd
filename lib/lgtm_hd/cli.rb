require 'rubygems'
require 'commander'
require 'os'
require 'clipboard'
require 'uri'

module LgtmHD
  class CLI
    include Commander::Methods

    CMD_RANDOM_SYNTAX = 'lgtm_hd random [-i | --interactive] [-d | --dest DIR]'.freeze
    CMD_TRANSFORM_SYNTAX = 'lgtm_hd <URI|FILE> [-i | --interactive] [-d | --dest <DIR>]'.freeze

    def run
      program :name, LgtmHD::Configuration::PROGRAM_NAME
      program :version, LgtmHD::VERSION
      program :description, LgtmHD::Configuration::DESCRIPTION

      default_command :transform
      global_option '-i', '--interactive', 'Turn on interactive Mode. In case you forgot all these super complexive args and options' do say "-- LGTM HD Interactive Mode --" end
      global_option '-d', '--dest DIR', String, 'Directory to export the LGTM image to. Default value is user\'s current working directory'

      command :random do |c|
        c.syntax = CMD_RANDOM_SYNTAX
        c.summary = 'Fetch random images from LGTM.in'
        c.description = ''
        c.example 'Example', 'lgtm_hd random'

        c.action do |args, options|
          if options.interactive  # Interactive mode!
            options.dest ||= ask('Destination Directory (Enter to skip): ')
          end
          dest_dir = CLI.destination_dir(options.dest)
          dest_file_prefix = CLI.destination_file_prefix
          check_uris(dest_dir)

          say_step "Fetching from lgtm.in"
          dest_uri,image_markdown = LgtmDotIn.fetch_random_image(dest_dir,dest_file_prefix) do |url, markdown|
            say_step "Loading image at #{url}"
          end

          say_ok "Exported image to #{dest_uri}"
          copy_file_to_clipboard(dest_uri)
          say "\nOr you can copy the markdown format below provided by lgtm.in"
          say_code_block "#{image_markdown}"
          say "\nIf the image does not have LGTM texts on it, run the cmd below"
          say_code_block "lgtm_hd #{dest_uri}"
        end
      end

      command :transform do |c|
        c.syntax = CMD_TRANSFORM_SYNTAX
        c.summary = 'Generate LGTM text on top of image URL or local image File'
        c.description = 'The command \e[3mtransform\e[0m is the default command hence you can skip typing it instead'
        c.example 'Example', 'lgtm_hd http://domain.com/image.png'

        c.action do |args, options|
          # ARGS validation!
          if args.length >= 1
            source_uri = args[0]
          elsif options.interactive  # Interactive mode!
            source_uri ||= ask(' Source Image (URL or Path/to/file): ')
            options.dest ||= ask('Destination Directory (Enter to skip): ')
          else
            # Since this is the default command so we will provide a little extra care for first-time user
            help_the_noobie
          end

          # Validate the inputs
          dest_dir = CLI.destination_dir(options.dest)
          check_uris(dest_dir, source_uri)
          dest_file = File.join(dest_dir, CLI.destination_file_prefix + File.extname(source_uri))

          # Do stuff with our LGTM meme
          say_step "Reading and inspecting source at #{source_uri}"
          meme_generator = MemeGenerator.new(input_image_uri:source_uri, output_image_uri:dest_file)
          say_step "Transforming Image"
          meme_generator.draw

          # Export and play around with the clipboard
          say_step "Exporting to file"
          meme_generator.export do |output|
            say_ok "Exported LGTM image to #{output}."
            copy_file_to_clipboard(dest_file)
          end # end of meme_generator.export block
        end # end of action
      end # end of command transform

      run!
    end # end run def

    def help_the_noobie
      say "To add LGTM text:"
      say_code_block CLI::CMD_TRANSFORM_SYNTAX
      say "To fetch LGTM text:"
      say_code_block CLI::CMD_RANDOM_SYNTAX
      say "More Help:"
      say_code_block "lgtm_hd --help"
      say "\nVisit #{LgtmHD::Configuration::MORE_HELP_URL} for development purpose or more examples"
      exit
    end


    private

    def copy_file_to_clipboard(output_file)
      if OS.mac? then
        applescript "set the clipboard to (read (POSIX file \"#{output_file}\") as GIF picture)"
        say_ok "Copied file to OS's clipboard for direct pasting to Github comments or Slack"

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
        say_ok "Copied file's path to OS's clipboard"
      end
    end

    def say_step(*args)
      args.each do |arg|
        say $terminal.color(arg, :magenta)
      end
    end

    def say_code_block(*args)
      args.each do |arg|
        say $terminal.color("#{arg}", :black, :on_white)
      end
    end

    def check_uris(dest_dir, source_uri = nil)
      begin
        raise ArgumentError, "Destination path for exporting image is invalid" unless File.exist?(dest_dir) && File.directory?(dest_dir)
        if !!source_uri
          raise ArgumentError, "Source image is neither proper URL nor FILE" unless source_uri =~ URI::regexp || File.exist?(source_uri)
        end
      rescue ArgumentError => e
        say_error e.message
        exit
      end
    end

    def self.destination_dir(dest_dir)
      dest_dir ||= Dir.pwd
      File.expand_path(dest_dir)
    end

    def self.destination_file_prefix
      LgtmHD::Configuration::OUTPUT_PREFIX + Time.now.strftime('%Y%m%d%H%M%S')
    end

  end # end of Class
end # end of Module
