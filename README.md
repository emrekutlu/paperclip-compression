# paperclip-compression

JPEG and PNG compression processor for Paperclip.

## Requirements

paperclip-compression requires Paperclip gem, [jpegtran](http://jpegclub.org) and [optipng](http://optipng.sourceforge.net/) libraries.

## Installation

Add to your Gemfile

````ruby
gem 'paperclip-compression', '~> 0.2.1'
````

## Usage
This is the basic usage. This will compress both JPEG and PNG files with the default options. Default options for jpegtran is <code>-copy none -optimize -perfect</code> and for optipng is <code>-o 5</code>.

````ruby
class User < ActiveRecord::Base
  has_attached_file :avatar,
                    styles: { medium: '300x300>', thumb: '100x100>' },
                    processors: [:thumbnail, :compression]
end
````

Disable PNG compression and change default options for JPEG compression for <code>thumb</code>.

````ruby
class User < ActiveRecord::Base
  has_attached_file :avatar,
                    styles: {
                      medium: '300x300>',
                      thumb: {
                        geometry: '100x100>',
                        processor_options: {
                          compression: {
                            png: false,
                            jpeg: '-copy none -optimize'
                          }
                        }
                      }
                    },
                    processors: [:thumbnail, :compression]
end
````

You cannot set global compression settings. You must set <code>processor_options</code> individually for every style.
