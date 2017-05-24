module LgtmHD
  module Configuration
    # Program configurations
    PROGRAM_NAME      = "lgtm_hd"
    DESCRIPTION       = "Generating images from user input with LGTM text on it, or fetching images from LGTM.in based on user's query. Finally put the image to clipboard."

    TEMP_FILE_PREFIX    = "lgtm_tmp_"

    # Output Image configurations
    OUTPUT_MAX_WIDTH    = 500
    OUTPUT_MAX_HEIGHT   = 500
    OUTPUT_DENSITY      = 90 # or 120 point per inch

    # Caption configurations
    FONT_PATH           = "/fonts/impact.ttf"
    CAPTION_FONT_SIZE_DEFAULT = 96

  end
end
