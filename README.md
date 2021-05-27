# paperclip-compression

JPEG and PNG compression processor for Paperclip. Under the hood, [jpegtran](http://jpegclub.org) and [optipng](http://optipng.sourceforge.net/) libraries are used.

## Installation

Add to your Gemfile.

````ruby
gem 'paperclip-compression'
````

## Usage
This is the basic usage. This will compress both JPEG and PNG files with the default options.

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

paperclip-compression uses binaries which are bundled with the gem. So you don't need to install anything. But if these binaries don't work for you, you can use your own.

````ruby
class User < ActiveRecord::Base
  has_attached_file :avatar,
    styles: {
      thumb: {
        geometry: '100x100>',
        processor_options: {
          compression: {
            jpeg: {
              command: '/path/to/jpegtran',
              options: '-copy none -optimize'
            }
          }
        }
      }
    },
    processors: [:thumbnail, :compression]
end
````

## Defaults
Default options for jpegtran is <code>-copy none -optimize -perfect</code> and default options for optipng is <code>-o 5 -quiet</code>.

You can use paperclip's default options to define global defaults for all your paperclip attachments. Use <code>compression</code> key.

Example for config/application.rb:

````ruby
module YourApp
  class Application < Rails::Application
    # Other code...

    config.paperclip_defaults = { :compression => { :png => false, :jpeg => '-optimize' } }
  end
end
````

Example for Rails initializer:

````ruby
Paperclip::Attachment.default_options[:compression] = { :png => false, :jpeg => '-optimize' }
````

For more information about paperclip defaults: https://github.com/thoughtbot/paperclip#defaults

## License
paperclip-compression is released under the [MIT License](https://github.com/emrekutlu/paperclip-compression/blob/master/LICENSE.txt).
