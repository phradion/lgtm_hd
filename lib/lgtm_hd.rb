require "lgtm_hd/version"
require "open-uri"
require "clipboard"
require "mini_magick"
require "rubygems"

module MiniMagick
  class Image
    def pixel_at(x, y)
      run_command("convert", "#{path}[1x1+#{x.to_i}+#{y.to_i}]", 'txt:').split("\n").each do |line|
        return $1 if /^0,0:.*(#[0-9a-fA-F]+)/.match(line)
      end
      nil
    end
  end
end

module LgtmHD
  class MemeGenerator
    attr_accessor :input_image_URI, :output_image_URI

    def initialize(input_image_URI, output_image_URI)
      @input_image_URI = input_image_URI
      @output_image_URI = output_image_URI
      @img = MiniMagick::Image.open(@input_image_URI)
    end

    def draw
      @img = yield @img if block_given?
      if @img.respond_to? (:combine_options) then
        @img.combine_options do |c|
          c.gravity 'south center'
          c.draw 'text 20,20 "LGTM"'
          c.font getFontPath
          c.pointsize 96
          c.density 90
          c.fill getCaptionColor
          c.resize getMaxSize().reduce() {|w,h| w << 'x' << h} # syntax: convert -resize $wx$h
        end
        @img.contrast
      end
    end

    def export
      @img = yield @img if block_given?
      @img.write(@output_image_URI)
      @output_image_URI
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

  private

    def getMaxSize
      ['500','500']
    end

    def getFontPath
      ROOT_DIR << FONT_PATH
    end

    def getCaptionColor
      # Decide foreground color depending on background color
      # https://en.wikipedia.org/wiki/Rec._601
      #
      # return (int)Math.Sqrt(
      # c.R * c.R * .241 +
      # c.G * c.G * .691 +
      # c.B * c.B * .068);

      img = MiniMagick::Image.open(@input_image_URI)
      # TODO splice the image into half before compressing because top of the image is irrelevant to the caption color
      img = img.resize('1x1')
      rgb = img.get_pixels[0][0] # Only 1x1 pixel remember? ^_^
      color = {}
      ['r','g','b'].zip(rgb) { |k,v| color[k] = v }

      magic_color_value = color['r'] * color['r'] * 0.241
      magic_color_value += color['g'] * color['g'] * 0.691
      magic_color_value += color['b'] * color['b'] * 0.068
      magic_color_value = Math.sqrt(magic_color_value)

      return (magic_color_value.round > 130) ? "#FFFFFF" : "#000000"
    end

  end # End of Class
end
