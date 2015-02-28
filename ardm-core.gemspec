# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dm-core/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = "ardm-core"
  s.version       = DataMapper::VERSION

  s.summary       = "Ardm fork of dm-core"
  s.description   = s.summary

  s.authors       = [ "Martin Emde", "Dan Kubb" ]
  s.email         = [ "me@martinemde.com", "dan.kubb@gmail.com" ]
  s.homepage      = "https://github.com/ar-dm/ardm-core"
  s.license       = "MIT"

  s.require_paths = [ "lib" ]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.extra_rdoc_files = %w[ LICENSE README.md ]

  s.add_dependency 'addressable', '~> 2.3', '>= 2.3.5'

  s.add_development_dependency 'rake',  '~> 10.0'
  s.add_development_dependency 'rspec', '~> 2.0'
end
