$:.push File.expand_path("../lib", __FILE__)

require 'librarian/puppet/version'

Gem::Specification.new do |s|
  s.name = 'rethinc-librarian-puppet'
  s.version = Librarian::Puppet::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Tim Sharpe', 'Carlos Sanchez']
  s.license = 'MIT'
  s.email = ['tim@sharpe.id.au', 'carlos@apache.org']
  s.homepage = 'https://github.com/voxpupuli/librarian-puppet'
  s.summary = 'Bundler for your Puppet modules'
  s.description = 'Simplify deployment of your Puppet infrastructure by
  automatically pulling in modules from the forge and git repositories with
  a single command.'

  s.required_ruby_version = '>= 2.4.0', '< 4'

  s.files = [
    '.gitignore',
    'LICENSE',
    'README.md',
  ] + Dir['{bin,lib}/**/*']

  s.executables = ['librarian-puppet']

  s.add_dependency "librarianp", ">=0.6.3"
  s.add_dependency "rsync"
  s.add_dependency "puppet_forge", ">= 2.1", '< 4'

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber", "<3.0.0"
  s.add_development_dependency "aruba", "<0.8.0"
  s.add_development_dependency "puppet", ENV["PUPPET_VERSION"]
  s.add_development_dependency "minitest", "~> 5"
  s.add_development_dependency "mocha"
  s.add_development_dependency "simplecov", ">= 0.9.0"
end
