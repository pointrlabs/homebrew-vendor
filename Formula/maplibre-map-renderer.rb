class MaplibreMapRenderer < Formula
  desc "Renders and produces raster images from Maplibre maps"
  homepage "https://github.com/pointrlabs/maplibre-gl-native/tree/develop/map-renderer"
  url "https://github.com/pointrlabs/maplibre-gl-native.git", tag: "version/map-renderer/1.3", revision: "3cd62bb7532286b39caab48f3d4781e10322e1cb"
  license "MIT"
  head "https://github.com/pointrlabs/maplibre-gl-native.git", branch: "develop"

  bottle do
    root_url "https://github.com/pointrlabs/maplibre-gl-native/releases/download/version%2Fmap-renderer%2F1.3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0fb62404f5ac8ae32d1a6710c62813440d35e2ac17e1713078a4d9f69f9bd8"
    sha256 cellar: :any_skip_relocation, sequoia:       "a0d5a40dedea500ce8a3bf764f9f54a76006299419b44c90803c01ca8984efa9"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  uses_from_macos "curl"
  on_linux do
    depends_on "libuv"
    depends_on "mesa-glu"
    depends_on "mesalib-glw"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
      "-DMBGL_WITH_MAP_RENDERER=ON", "-DMBGL_WITH_WERROR=OFF",
      *std_cmake_args(find_framework: "FIRST")
    system "cmake", "--build", "build", "--target", "map-renderer"
    system "cmake", "--install", "build"
  end
end
