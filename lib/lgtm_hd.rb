require "lgtm_hd/configuration"
require "mini_magick"
require "rubygems"

module LgtmHD

  class MemeGenerator
    attr_accessor :input_image_URI, :output_image_URI

    # TODO make options list for this class
    def initialize(input_image_URI, output_image_URI)
      @input_image_URI = input_image_URI
      @output_image_URI = output_image_URI

      @img = MiniMagick::Image.open(@input_image_URI)
      @caption_position = :caption_position_bottom
    end

    ##
    # Used to create a new Image object data-copy. Not used to "paint" or
    # that kind of thing.
    #
    # @param caption_text [String] Specify the caption for your LGTM meme
    # @return [MiniMagick::Image] The drawn image
    #
    def draw (caption_text = "LGTM")
      if @img.respond_to? (:combine_options) then
        @img.combine_options do |c|
          c.gravity captionPosition()
          c.draw "text 0,0 " << "#{caption_text}"
          c.font captionFont
          c.pointsize captionFontSize
          c.density imageDensity
          c.fill captionColor
          c.resize imageMaxSize().reduce() {|w,h| w << 'x' << h} # syntax: convert -resize $wx$h
        end
        @img.contrast
      end
      yield @img if block_given?
    end

    def export
      @img.write(@output_image_URI)
      yield @output_image_URI if block_given?
    end


  private

    def imageMaxSize
      [Configuration::OUTPUT_MAX_WIDTH.to_s, Configuration::OUTPUT_MAX_HEIGHT.to_s]
    end

    ##
    # @return [String] the position of image
    # Could be either :caption_position_top or :caption_position_bottom
    #
    def captionPosition ()
      if not [:caption_position_top, :caption_position_bottom].include? (@caption_position)
        @caption_position = :caption_position_top
      end
      return {:caption_position_top => "north center",
              :caption_position_bottom => "south center"}[@caption_position]
    end

    def captionFont
      ROOT_DIR << Configuration::FONT_PATH
    end

    def captionFontSize
      Configuration::CAPTION_FONT_SIZE_DEFAULT
    end

    def imageDensity
      Configuration::OUTPUT_DENSITY
    end

    ##
    # Decide foreground color depending on background color
    # https://en.wikipedia.org/wiki/Rec._601
    #
    # We use this method that include magic numbers .241, .691, .068 accroding to
    # the provided wikipedia link
    # Math.Sqrt(
    # c.R * c.R * .241 +
    # c.G * c.G * .691 +
    # c.B * c.B * .068)
    #
    # Magic cut off number is 130.
    # Under 130 is too dark, so the foreground color is white
    # Above is too bright so the foreground color is black
    #
    # @return [String] the foreground color of caption
    #
    def captionColor
      # Copy current image data instead of working directly on working file
      img = MiniMagick::Image.read(@img.to_blob)

      # cutoff's x is always 0 as we only support top or bottom right now
      cutoff_y = @caption_position == :caption_position_bottom ? (img.height/2).round : 0
      img.crop("#{img.width}x#{img.height/2}+0+#{cutoff_y}")

      # Since we are getting
      img = img.resize('1x1')
      rgb = img.get_pixels[0][0] # Only 1x1 pixel remember? ^_^
      color = {}
      ['r','g','b'].zip(rgb) { |k,v| color[k] = v }

      magic_color_value = color['r'] * color['r'] * 0.241
      magic_color_value += color['g'] * color['g'] * 0.691
      magic_color_value += color['b'] * color['b'] * 0.068
      magic_color_value = Math.sqrt(magic_color_value)

      return (magic_color_value.round > 130) ? "#000000" : "#FFFFFF"
    end

  end # End of Class
end # End of Module
