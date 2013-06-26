Gem::Specification.new do |s|
  s.name        = 'paperclip-compression'
  s.version     = '0.3.2'
  s.date        = '2013-06-26'
  s.summary     = 'Image compression for Paperclip'
  s.description = 'JPEG and PNG compression for Paperclip gem'
  s.author      = 'İ. Emre Kutlu'
  s.email       = 'emrekutlu@gmail.com'
  s.files       = Dir['lib/**/*.rb'] + Dir['bin/**/*']
  s.bindir      = 'bin'
  s.homepage    = 'http://github.com/emrekutlu/paperclip-compression'
  s.add_runtime_dependency 'paperclip', ['~> 3.3']
  s.add_runtime_dependency 'os', ['~> 0.9.6']
  s.add_runtime_dependency 'ruby-imagespec', ['~> 0.3.1']
end
