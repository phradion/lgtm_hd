require "mini_magick"
require "rubygems"
require "lgtm_hd/version"
require "lgtm_hd/configuration"
require "lgtm_hd/meme_generator"
require "lgtm_hd/cli"

module LgtmHD
  def self.gem_root
    File.expand_path '../..', __FILE__
  end
end # End of Module
