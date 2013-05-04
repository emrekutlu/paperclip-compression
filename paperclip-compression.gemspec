Gem::Specification.new do |s|
  s.name        = 'paperclip-compression'
  s.version     = '0.2.1'
  s.date        = '2013-05-04'
  s.summary     = 'Image compression for Paperclip'
  s.description = 'JPEG and PNG compression for Paperclip gem'
  s.author      = 'İ. Emre Kutlu'
  s.email       = 'emrekutlu@gmail.com'
  s.files       = ['lib/paperclip-compression.rb']
  s.homepage    = 'http://github.com/emrekutlu/paperclip-compression'
  s.add_runtime_dependency 'paperclip', ['~> 3.3']
  s.requirements << 'jpegtran for JPEG compression'
  s.requirements << 'optipng for PNG compression'
end
