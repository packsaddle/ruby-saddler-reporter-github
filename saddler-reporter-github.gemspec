# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'saddler/reporter/github/version'

Gem::Specification.new do |spec|
  spec.name          = 'saddler-reporter-github'
  spec.version       = Saddler::Reporter::Github::VERSION
  spec.authors       = ['sanemat']
  spec.email         = ['o.gata.ken@gmail.com']

  spec.summary       = 'Saddler reporter for GitHub.'
  spec.description   = 'Saddler reporter for GitHub.'
  spec.homepage      = 'https://github.com/packsaddle/ruby-saddler-reporter-github'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'octokit'
  spec.add_runtime_dependency 'git_diff_parser'
  spec.add_runtime_dependency 'saddler-reporter-support'
  spec.add_runtime_dependency 'saddler-reporter-support-git'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'test-unit'
end
