lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geo_pattern/version'

Gem::Specification.new do |spec|
  spec.name          = 'geo_pattern'
  spec.version       = GeoPattern::VERSION
  spec.authors       = ['Jason Long']
  spec.email         = ['jlong@github.com']
  spec.summary       = 'Generate SVG beautiful patterns'
  spec.description   = 'Generate SVG beautiful patterns'
  spec.homepage      = 'https://github.com/jasonlong/geo_pattern'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~>3'

  spec.add_dependency 'color', '~> 1.5'
  spec.add_development_dependency 'bundler', '~> 2.2'
end
