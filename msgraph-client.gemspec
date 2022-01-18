# frozen_string_literal: true

require_relative 'lib/msgraph/client/version'

Gem::Specification.new do |spec|
  spec.name = 'msgraph-client'
  spec.version = MSGraph::Client::VERSION
  spec.authors = ['SHIMAYOSHI, Takao']
  spec.email = ['simayosi@cc.kyushu-u.ac.jp']

  spec.summary = 'MSGraph::Client'
  spec.description = 'Simple Microsoft Graph client gem.'
  spec.homepage = 'https://github.com/simayosi/rb-msgraph-client'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files = Dir['lib/**/*', 'sig/**/*', 'LICENSE.txt', 'README.md']
  spec.require_paths = ['lib']
end
