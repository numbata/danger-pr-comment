# -*- encoding: utf-8 -*-
$:.push File.expand_path('lib', __dir__)
require 'danger-pr-comment/version'

Gem::Specification.new do |s|
  s.name        = 'danger-pr-comment'
  s.version     = DangerPrComment::VERSION
  s.authors     = ['Andrei Subbota']
  s.email       = ['numbata@users.noreply.github.com']
  s.homepage    = 'https://github.com/numbata/danger-pr-comment'
  s.summary     = 'Reusable workflows and shared Dangerfile for PR comment reporting.'
  s.description = 'Shared Dangerfile that exports a JSON report for posting Danger results as a PR comment.'
  s.license     = 'MIT'

  s.files         = Dir['Dangerfile', 'LICENSE.txt', 'README.md', 'lib/**/*.rb']
  s.require_paths = ['lib']

  s.add_runtime_dependency 'danger', '~> 9'
end
