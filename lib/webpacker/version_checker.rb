# frozen_string_literal: true
require_relative "version"

module Webpacker
  class VersionChecker < Shakapacker::VersionChecker
    def raise_if_gem_and_node_package_versions_differ
      # Skip check if package is not in package.json or listed from relative path, git repo or github URL
      return if node_package_version.skip_processing?

      node_major_minor_patch = node_package_version.major_minor_patch
      gem_major_minor_patch = gem_major_minor_patch_version
      versions_match = node_major_minor_patch[0] == gem_major_minor_patch[0] &&
                       node_major_minor_patch[1] == gem_major_minor_patch[1] &&
                       node_major_minor_patch[2] == gem_major_minor_patch[2]

      uses_wildcard = node_package_version.semver_wildcard?

      if !Webpacker.config.ensure_consistent_versioning? && (uses_wildcard || !versions_match)
        check_failed = if uses_wildcard
          "Semver wildcard without a lockfile detected"
        else
          "Version mismatch detected"
        end

        warn <<-MSG.strip_heredoc
          Shakapacker::VersionChecker - #{check_failed}

          You are currently not checking for consistent versions of shakapacker gem and npm package. A version mismatch or usage of semantic versioning wildcard (~ or ^) without a lockfile has been detected.

          Version mismatch can lead to incorrect behavior and bugs. You should ensure that both the gem and npm package dependencies are locked to the same version.

          You can enable the version check by setting `ensure_consistent_versioning: true` in your `webpacker.yml` file.

          Checking for gem and npm package versions mismatch or wildcard will be enabled by default in the next major version of shakapacker.
        MSG

        return
      end

      raise_differing_versions_warning unless versions_match

      raise_node_semver_version_warning if uses_wildcard
    end

    private

      def gem_version
        Webpacker::VERSION
      end
  end
end
