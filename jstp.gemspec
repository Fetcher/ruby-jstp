# -*- encoding: utf-8 -*-
require File.expand_path('../lib/jstp/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Xavier Via", "Luciano Bertenasco", "Matias Domingues"]
  gem.email         = ["xavierviacanel@gmail.com"]
  gem.description   = %q{Reference implementation for the sketch protocol JSTP}
  gem.summary       = %q{Reference implementation for the sketch protocol JSTP}
  gem.homepage      = "https://github.com/Fetcher/jstp"

  gem.add_dependency 'em-websocket'
  gem.add_dependency 'em-websocket-client'
  gem.add_dependency 'discoverer'

  gem.add_development_dependency 'rspec'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "jstp"
  gem.require_paths = ["lib"]
  gem.version       = Jstp::VERSION
end
