class MaplibreMapRenderer < Formula
  desc "Renders and produces raster images from Maplibre maps"
  homepage "https://github.com/pointrlabs/maplibre-gl-native/tree/develop/map-renderer"
  url "https://github.com/pointrlabs/maplibre-gl-native.git", tag: "version/map-renderer/1.1", revision: "630e51e941621b1c7aec9b9cd84c623482a20f2c"
  license "MIT"
  head "https://github.com/pointrlabs/maplibre-gl-native.git", branch: "develop"

  bottle do
    root_url "https://github.com/pointrlabs/maplibre-gl-native/releases/download/version%2Fmap-renderer%2F1.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f258b62dedaac02f3fc5fc684ea6e228858ae5477f77ed16decfad3714749232"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "7d173bff46a8cfd08fde7e0d24e3b3dbd94ccec369b78a6cecb33af3d25296ed"
    sha256 cellar: :any_skip_relocation, sequoia: "06dfe7da2bf32e2ee235fff57faec83faecc10b1e1dac8388ab854d96a3443c3"
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
