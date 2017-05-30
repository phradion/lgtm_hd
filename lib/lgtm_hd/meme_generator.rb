require "mini_magick"

module LgtmHD
  class MemeGenerator
    @@caption_positions = {caption_position_top: "north center", caption_position_bottom: "south center"}

    # TODO make options list for this class
    # TODO pass BLOB data into this class instead of paths
    def initialize(input_image_uri:, output_image_uri:)
      @input_image_uri = input_image_uri
      @output_image_uri = output_image_uri
    end

    ##
    # Used to create a new Image object data-copy. Not used to "paint" or
    # that kind of thing.
    #
    # @param caption_text [String] Specify the caption for your LGTM meme
    # @return [MiniMagick::Image] The drawn image
    #
    def draw(caption_text = "LGTM")
      img = image
      img.combine_options do |c|
        c.gravity caption_position
        c.draw "text 0,0 " << caption_text
        c.font caption_font
        c.pointsize caption_font_size
        c.density image_density
        c.fill caption_color
        c.resize image_max_size().reduce() {|w,h| "#{w}x#{h}"} # syntax: convert -resize $wx$h
        img.contrast
      end
      yield img if block_given?
    end

    def export
      image.write(@output_image_uri)
      yield @output_image_uri if block_given?
    end

  private

    def image
      @image ||= MiniMagick::Image.open(@input_image_uri)
    end

    def image_max_size
      [Configuration::OUTPUT_MAX_WIDTH, Configuration::OUTPUT_MAX_HEIGHT]
    end

    ##
    # @return [String] the position of image
    # Could be either :caption_position_top or :caption_position_bottom
    # Default value is top
    #
    def caption_position
      @caption_position = :caption_position_bottom unless [:caption_position_top, :caption_position_bottom].include? @caption_position
      @@caption_positions[@caption_position]
    end

    def caption_font
      File.join(LgtmHD::gem_root, Configuration::FONT_PATH)
    end

    def caption_font_size
      Configuration::CAPTION_FONT_SIZE_DEFAULT
    end

    def image_density
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
    def caption_color
      # Copy current image data instead of working directly on working file
      # because ImageMagick apply change directly to the temporary working file instead of keep changes in memory
      # Might need to invest a bit further to ensure this, as for now, lazy..
      temp_img = MiniMagick::Image.read(image.to_blob)

      # cutoff's x is always 0 as we only support top or bottom right now
      cutoff_y = @caption_position == :caption_position_bottom ? (temp_img.height/2).round : 0
      temp_img.crop("#{temp_img.width}x#{temp_img.height/2}+0+#{cutoff_y}")

      # Since we are getting
      temp_img = temp_img.resize('1x1')
      rgb = temp_img.get_pixels[0][0] # Only 1x1 pixel remember? ^_^
      color = {}
      ['r','g','b'].zip(rgb) { |k,v| color[k] = v }

      magic_color_value = color['r'] * color['r'] * 0.241
      magic_color_value += color['g'] * color['g'] * 0.691
      magic_color_value += color['b'] * color['b'] * 0.068
      magic_color_value = Math.sqrt(magic_color_value)

      (magic_color_value.round > 130) ? "#000000" : "#FFFFFF"
    end

  end # End of Class
end # End of module
