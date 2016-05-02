require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/test*.rb']
end

task default: :test

require 'yard'
require 'yard/rake/yardoc_task'
DOC_FILES = ['lib/**/*.rb'].freeze
DOC_OPTIONS = ['--debug', '--verbose'].freeze
YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = DOC_FILES
  t.options = DOC_OPTIONS if Rake.application.options.trace
end
