class MaplibreMapRenderer < Formula
  desc "Renders and produces raster images from Maplibre maps"
  homepage "https://github.com/pointrlabs/maplibre-gl-native/tree/develop/map-renderer"
  url "https://github.com/pointrlabs/maplibre-gl-native.git", tag: "version/map-renderer/1.2", revision: "ba8dcb702e0a6431398034845a7a77f1bbdc7cd9"
  license "MIT"
  head "https://github.com/pointrlabs/maplibre-gl-native.git", branch: "develop"

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
