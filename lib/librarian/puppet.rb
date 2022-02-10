require 'librarian'
require 'fileutils'

require 'librarian/puppet/extension'
require 'librarian/puppet/version'

require 'librarian/action/install'

module Librarian
  module Puppet
    @@puppet_version = "7.14.0"

    # Output of puppet --version, typically x.y.z
    # For Puppet Enterprise it contains the PE version too, ie. 3.4.3 (Puppet Enterprise 3.2.1)
    def puppet_version
      return @@puppet_version unless @@puppet_version.nil?
    end

    # Puppet version x.y.z translated as a Gem version
    def puppet_gem_version
      Gem::Version.create(puppet_version.split(' ').first.strip.gsub('-', '.'))
    end

  end
end
