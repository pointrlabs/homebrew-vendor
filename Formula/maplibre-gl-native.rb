class MaplibreGlNative < Formula
  desc "Pointr-flavored Maplibre GL Native"
  homepage "https://maplibre.org"
  url "https://github.com/pointrlabs/maplibre-gl-native.git", tag: "version/maplibre-gl-native/1.0", revision: "f7abe3d6246a9524685eb7c2f7338304f102bef0"
  license "BSD-2-Clause"
  head "https://github.com/pointrlabs/maplibre-gl-native.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/pointrlabs/vendor"
    sha256 cellar: :any,                 arm64_tahoe:   "d70b292f553c5ce984f5dfb6053e3f275d8916470ce5de6bdb2cedd0130c7f5f"
    sha256 cellar: :any,                 arm64_sequoia: "aa0381d49568f668d93bddbd20cf378afef9874d78098e88bc61c93288dce410"
    sha256 cellar: :any,                 tahoe:         "f53d684e40c8d2884e68eca8bef176ead0b37feaa7288f94f8dfb068b796d725"
    sha256 cellar: :any,                 sequoia:       "d295371ff943b00352a75516deeccb01f89616ee61b03d0bd636c7fac3186511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1036c4027fe6b2be28ffef036966a3ec32c76f069a2f08dda6a763d4ba38822a"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt6"

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
      "-DMBGL_WITH_QT=ON", "-DMBGL_QT_LIBRARY_ONLY=ON",
      "-DMBGL_QT_WITH_INTERNAL_SQLITE=ON", "-DMBGL_QT_WITH_INTERNAL_ICU=ON",
      "-DMBGL_WITH_WERROR=OFF",
      *std_cmake_args
    system "cmake", "--build", "build", "--target", "qmaplibregl"
    system "cmake", "--install", "build"
  end
end
