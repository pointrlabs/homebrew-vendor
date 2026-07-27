class PtrBrew < Formula
  desc "Authentication helpers for the Pointr private Homebrew taps"
  homepage "https://github.com/pointrlabs/homebrew-vendor"
  url "https://github.com/pointrlabs/homebrew-vendor.git", tag: "version/ptr-brew/1.0.0", revision: "15819ed1d6cc4337a4fc4c2e34ee5da5f5adbe68"
  version "1.0.0"
  license "MIT"
  head "https://github.com/pointrlabs/homebrew-vendor.git", branch: "develop"

  depends_on "jq"

  # Shell scripts only — nothing to compile, so no bottle block.
  def install
    bin.install "bin/ptr-brew", "bin/ptr-setup"
  end

  test do
    # Both commands exit non-zero without credentials; assert on the guidance
    # they print rather than on a successful run.
    assert_match "ptr-setup", shell_output("#{bin}/ptr-brew 2>&1", 1)
    assert_match "Usage: ptr-setup", shell_output("#{bin}/ptr-setup --help")
  end
end
