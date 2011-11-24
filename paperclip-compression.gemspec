Gem::Specification.new do |s|
  s.name        = "paperclip-compression"
  s.version     = "0.1.1"
  s.date        = "2011-11-24"
  s.summary     = "Image compression for Paperclip"
  s.description = "JPEG and PNG compression for Paperclip gem"
  s.author      = "İ. Emre Kutlu"
  s.email       = "emrekutlu@gmail.com"
  s.files       = ["lib/paperclip-compression.rb"]
  s.homepage    = "http://github.com/dakick/paperclip-compression"
  s.add_runtime_dependency "paperclip", ["~> 2.4"]
  s.requirements << "jpegtran for JPEG compression"
  s.requirements << "optipng for PNG compression"
end
