class MaplibreGlNative < Formula
  desc "Pointr-flavored Maplibre GL Native"
  homepage "https://maplibre.org"
  url "https://github.com/pointrlabs/maplibre-gl-native.git", tag: "version/maplibre-gl-native/1.0", revision: "f7abe3d6246a9524685eb7c2f7338304f102bef0"
  license "BSD-2-Clause"
  head "https://github.com/pointrlabs/maplibre-gl-native.git", branch: "develop"

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
