require "librarian/environment"
require "librarian/puppet/dsl"
require "librarian/puppet/source"
require "librarian/puppet/lockfile"

module Librarian
  module Puppet
    class Environment < Librarian::Environment

      def adapter_name
        "puppet"
      end

      def lockfile
        Lockfile.new(self, lockfile_path)
      end

      def ephemeral_lockfile
        Lockfile.new(self, nil)
      end

      def tmp_path
        part = config_db["tmp"] || ".tmp"
        project_path.join(part)
      end

      def install_path
        part = config_db["path"] || "modules"
        project_path.join(part)
      end

      def vendor_path
        project_path.join('vendor/puppet')
      end

      def vendor_cache
        vendor_path.join('cache')
      end

      def vendor_source
        vendor_path.join('source')
      end

      def vendor!
        vendor_cache.mkpath  unless vendor_cache.exist?
        vendor_source.mkpath unless vendor_source.exist?
      end

      def vendor?
        vendor_path.exist?
      end

      def local?
        config_db['mode'] == 'local'
      end

      def use_v1_api
        config_db['use-v1-api']
      end

      def use_short_cache_path
        config_db['use-short-cache-path']
      end
    end
  end
end
