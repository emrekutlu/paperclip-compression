# Paperclip-Compression

JPEG and PNG processor for Paperclip.

# Requirements

Paperclip-Compression requires Paperclip gem, jpegtran and optipng libraries.

# Installation

Add to your Gemfile

````ruby
gem "paperclip-compression", "~> 0.1.0"
````

# Usage

````ruby
class User < ActiveRecord::Base
  has_attached_file :avatar,
                    :styles     => { :medium => "300x300>", :thumb => "100x100>" },
                    :processors => [:thumbnail, :compression]
end
````