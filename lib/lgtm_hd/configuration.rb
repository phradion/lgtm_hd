module LgtmHD
  module Configuration
    # Program configurations
    PROGRAM_NAME          = "lgtm_hd".freeze
    AUTHOR                = "Huy Dinh <phradion@gmail.com>".freeze
    DESCRIPTION           = "Generating images from user input with LGTM text on it,"\
                            "or fetching images from LGTM.in based on user's query.\n"\
                            "Finally put the image to clipboard.".freeze
    MORE_HELP_URL         = "https://github.com/phradion/lgtm_hd".freeze
    
    # Output Image configurations
    OUTPUT_PREFIX         = "lgtm_hd_".freeze
    OUTPUT_MAX_WIDTH      = 500
    OUTPUT_MAX_HEIGHT     = 500
    OUTPUT_DENSITY        = 90 # or 120 point per inch

    # Caption configurations
    FONT_PATH                   = "/fonts/impact.ttf".freeze
    CAPTION_FONT_SIZE_DEFAULT   = 96

  end
end
