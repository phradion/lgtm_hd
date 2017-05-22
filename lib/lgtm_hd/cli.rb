require 'rubygems'
require 'commander'
require 'lgtm_hd'

module LgtmHD
  class CLI
    include Commander::Methods
    # include whatever modules you need

    def run
      program :name, LgtmHD::PROGRAMNAME
      program :version, LgtmHD::VERSION
      program :description, LgtmHD::DESCRIPTION

      command :test do |c|
        c.syntax = 'lgtm_hd [options]'
        c.summary = ''
        c.description = ''
        c.example 'description', 'command example'
        c.option '--some-switch', 'Some switch that does something'
        c.action do |args, options|

          LgtmHD.hello
        end
      end
      run!
    end
  end
end
