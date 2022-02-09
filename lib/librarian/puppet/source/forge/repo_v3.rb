require 'librarian/puppet/source/forge/repo'
require 'puppet_forge'
require 'librarian/puppet/version'

module Librarian
  module Puppet
    module Source
      class Forge
        class RepoV3 < Librarian::Puppet::Source::Forge::Repo

          PuppetForge.user_agent = "librarian-puppet/#{Librarian::Puppet::VERSION}"

          def initialize(source, name)
            PuppetForge.host = source.uri.clone
            super(source, name)
          end

          def get_versions
            get_module.releases.select{|r| r.deleted_at.nil?}.map{|r| r.version}
          end

          def dependencies(version)
            array = get_release(version).metadata[:dependencies].map{|d| [d[:name], d[:version_requirement]]}
            Hash[*array.flatten(1)]
          end

          def url(name, version)
            if name == "#{get_module().owner.username}/#{get_module().name}"
              release = get_release(version)
            else
              # should never get here as we use one repo object for each module (to be changed in the future)
              debug { "Looking up url for #{name}@#{version}" }
              release = PuppetForge::V3::Release.find("#{name}-#{version}")
            end
            "#{source}#{release.file_uri}"
          end

        private

          def get_module
            begin
              @module ||= PuppetForge::V3::Module.find(name)
            rescue Faraday::ResourceNotFound => e
              raise(Error, "Unable to find module '#{name}' on #{source}")
            end
            @module
          end

          def get_release(version)
            release = get_module.releases.find{|r| r.version == version.to_s}
            if release.nil?
              versions = get_module.releases.map{|r| r.version}
              raise Error, "Unable to find version '#{version}' for module '#{name}' on #{source} amongst #{versions}"
            end
            release
          end

          def cache_version_unpacked!(version)
            path = version_unpacked_cache_path(version)
            return if path.directory?

            path.mkpath

            target = vendored?(name, version) ? vendored_path(name, version).to_s : name

            # can't pass the default v3 forge url (http://forgeapi.puppetlabs.com)
            # to clients that use the v1 API (https://forge.puppet.com)
            # nor the other way around
            module_repository = source.uri.to_s

            if Forge.client_api_version() > 1 and module_repository =~ %r{^http(s)?://forge\.puppetlabs\.com}
              module_repository = "https://forgeapi.puppetlabs.com"
              warn { "Replacing Puppet Forge API URL to use v3 #{module_repository} as required by your client version #{Librarian::Puppet.puppet_version}" }
            end

            tar_dst = environment.tmp_path.join("#{target}-#{version}.tar.gz")
            dest_dir = path.join(module_name(name)) 
            tmp_dir = environment.tmp_path.join("forge").to_s

            release = get_release(version)
            release.download(tar_dst)
            release.verify(tar_dst)
            PuppetForge::Unpacker.unpack(tar_dst, dest_dir, tmp_dir)
          end

        end
      end
    end
  end
end
