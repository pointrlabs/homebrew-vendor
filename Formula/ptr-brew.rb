class PtrBrew < Formula
  desc "Authentication helpers for the Pointr private Homebrew taps"
  homepage "https://github.com/pointrlabs/homebrew-vendor"
  url "https://github.com/pointrlabs/homebrew-vendor.git", tag: "version/ptr-brew/1.0.2", revision: "5243da4bfe5b0be0aa80159b1136ea3963dd2375"
  head "https://github.com/pointrlabs/homebrew-vendor.git", branch: "develop"

  depends_on "jq"

  # Shell scripts only — nothing to compile, so no bottle block.
  def install
    # Single source of truth for the version: it is derived from the git tag,
    # and stamped into the scripts here (they ship with "dev").
    inreplace ["bin/ptr-brew", "bin/ptr-setup"],
              'PTR_BREW_VERSION="dev"', "PTR_BREW_VERSION=\"#{version}\""
    bin.install "bin/ptr-brew", "bin/ptr-setup"
  end

  test do
    # Both commands exit non-zero without credentials; assert on the guidance
    # they print rather than on a successful run.
    assert_match "ptr-setup", shell_output("#{bin}/ptr-brew 2>&1", 1)
    assert_match "Usage: ptr-setup", shell_output("#{bin}/ptr-setup --help")
    # The version stamp must have been applied, not left as "dev".
    assert_match version.to_s, shell_output("#{bin}/ptr-brew 2>&1", 1)
  end
end
