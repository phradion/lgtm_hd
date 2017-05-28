require 'resolv-replace'
require 'open-uri'

module LgtmHD
  class LgtmDotIn
    API_STARTING_ENDPOINT     = "http://www.lgtm.in/g".freeze
    ACTUAL_IMAGE_URL_USE_SSL  = false
    TRY_FETCHING_IMAGE_LIMIT  = 3 # I have hit lgtm.in with bad content 5 times in a row
    TRY_FETCHING_META_LIMIT   = 3 # God know how many more redirect lgtm.in will use in the future

    def self.fetch_random_image(dest_path = nil, file_prefix = nil)
      # LGTM.in has so many broken images
      # So we loop until a good image is found
      limit = TRY_FETCHING_IMAGE_LIMIT
      begin
        json_data = fetch_meta_data
        image_url = json_data["actualImageUrl"]
        image_markdown = json_data["markdown"].lines.first.strip
        yield image_url, image_markdown

        # fetching image data
        dest_file = File.join(dest_path ||= '/tmp', (file_prefix ||= 'lgtmdotin_') + File.extname(image_url))
        uri = URI.parse(image_url)

        uri.open(redirect: false, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE) do |input_stream|
          File.open(dest_file, 'wb') do |output_stream|
            IO.copy_stream(input_stream, output_stream)
          end
        end
        [dest_file, image_markdown]
      rescue OpenURI::HTTPError, SocketError, Net::ReadTimeout => error
        retry if (limit -= 1) > 0
        raise error, "We have tried 3 times but all images are broken. Either LGTM.in is trash or you are super unlucky"
      end
    end


    private
    def self.fetch_meta_data(uri = API_STARTING_ENDPOINT, limit = TRY_FETCHING_META_LIMIT)
      uri = URI.parse(API_STARTING_ENDPOINT)
      ##
      # LGTM.in has a JSON endpoint that
      # .forwards to an SSL HTTP address that
      # .has no valid SSL certificate
      # Hence the loop
      #
      begin
        data = uri.open('Accept' => 'application/json', redirect: false, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
        json = JSON.parse data.readlines.join("")
      rescue OpenURI::HTTPRedirect => redirect
        uri = redirect.uri # assigned from the "Location" response header
        retry if (limit -= 1) > 0
        raise IOError, "There maybe a network issue. The program failed to contact LGTM.in JSON API"
      end
    end
  end
end
