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

  spec.files         = \
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
      .reject do |f|
        [
          '.travis.yml',
          'circle.yml',
          '.tachikoma.yml',
          'package.json'
        ].include?(f)
      end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'octokit', '>= 0'
  spec.add_runtime_dependency 'git_diff_parser', '>= 2.0', '< 3.0'
  spec.add_runtime_dependency 'saddler-reporter-support', '>= 0.1', '< 0.2'
  spec.add_runtime_dependency 'saddler-reporter-support-git', '>= 0.2', '< 0.3'

  spec.add_development_dependency 'bundler', '>= 0'
  spec.add_development_dependency 'rake', '>= 0'
  spec.add_development_dependency 'test-unit', '>= 0'
end
