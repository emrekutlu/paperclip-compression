require 'paperclip'
require 'os'
require 'image_spec'
require 'paperclip-compression/paperclip/compression'
require 'paperclip-compression/base'
require 'paperclip-compression/jpeg'
require 'paperclip-compression/png'

module PaperclipCompression
  def self.root
    Gem::Specification.find_by_name('paperclip-compression').gem_dir
  end
end
