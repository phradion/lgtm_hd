module LgtmHD
  module Configuration
    # Program configurations
    PROGRAM_NAME          = "lgtm_hd".freeze
    AUTHOR                = "Huy Dinh <phradion@gmail.com>".freeze
    DESCRIPTION           = "Generating images from user input with LGTM text on it, or fetching images from LGTM.in based on user's query. Finally put the image to clipboard.".freeze

    # Output Image configurations
    OUTPUT_PATH_DEFAULT   = "/tmp".freeze
    if (File.exist?("~/Desktop"))
      OUTPUT_PATH_DEFAULT = File.expand("~/Desktop").freeze
    end
    OUTPUT_PREFIX         = "lgtm_hd_".freeze
    OUTPUT_MAX_WIDTH      = 500.freeze
    OUTPUT_MAX_HEIGHT     = 500.freeze
    OUTPUT_DENSITY        = 90.freeze # or 120 point per inch

    # Caption configurations
    FONT_PATH                   = "/fonts/impact.ttf".freeze
    CAPTION_FONT_SIZE_DEFAULT   = 96.freeze

  end
end
