require "lgtm_hd/version"
require "open-uri"
require "clipboard"

module LgtmHD
  class MemeWriter
    attr_accessor :input_image_URI, :output_image_URI

    def initialize(input_image_URI, output_image_URI)
      @input_image_URI = input_image_URI
      @output_image_URI = output_image_URI
    end

    def drawMeme
      
    end

    def digest
      # uri = URI.parse(@input_image_URI)
      # open(input_image_URI) { |f| return f.read }
      # TODO: add validation for input and output_image_URI

      open(@input_image_URI) {|f|
         File.open(@output_image_URI,"wb") do |file| #+b for opening in binary mode, Windows madness
           file.puts f.read
         end
      }
      yield @output_image_URI if block_given?
    end
  end

  def self.hello
    p "LGTM"
  end
end
