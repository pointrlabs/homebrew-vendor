class Qmaplibre < Formula
  desc "Pointr-flavored MapLibre Native Qt bindings (QMapLibre)"
  homepage "https://github.com/maplibre/maplibre-native-qt"
  url "https://github.com/pointrlabs/ptr-rd-maplibre-native-qt.git", tag: "v4.0.0-ptr.1", revision: "4f9d87223742c89cfa9ab72addcba370c0d0119d"
  version "4.0.0-ptr.1"
  license "BSD-2-Clause"
  head "https://github.com/pointrlabs/ptr-rd-maplibre-native-qt.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/pointrlabs/vendor"
    sha256 cellar: :any, arm64_tahoe:   "ca8ae6bf7122ad62c1fdbdad5e0b8c90ce05cc528ceab781bf19b671bc7038da"
    sha256 cellar: :any, arm64_sequoia: "ef9893d4efe38617d440fadc3a0f6d9226a131369ec1cdfe60d779f2a8967438"
    sha256 cellar: :any, tahoe:         "99262c35fdee36a8164290ce6c44f786a8e74696c44f2f8ccdafe8e88f970d55"
    sha256 cellar: :any, sequoia:       "c0f0e86bac6817ad0bc83830cf4772ec21b157269883a0c6fb846b9ff896be9e"
    sha256 cellar: :any, x86_64_linux:  "178fdcf0ae267fef05030ab1dd3a1cecd809c31b38e7349dd1b7cd7deadd707c"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt"

  def install
    # Backend has no default and isn't auto-detected: exactly one MLN_WITH_* must be
    # set. macOS = Metal (core GL is GLES-only; macOS has no GLES); Linux = OpenGL.
    backend = OS.mac? ? "-DMLN_WITH_METAL=ON" : "-DMLN_WITH_OPENGL=ON"

    # Core only. Internal SQLite everywhere; internal ICU is honored on Linux only
    # (no-op on macOS) and avoids system-ICU portability issues there.
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
      "-DMLN_QT_WITH_QUICK_PLUGIN=OFF",
      "-DMLN_QT_WITH_LOCATION=OFF",
      "-DMLN_QT_WITH_WIDGETS=OFF",
      "-DMLN_QT_WITH_RENDERER_DEBUGGING=OFF",
      "-DMLN_QT_WITH_INTERNAL_SQLITE=ON",
      "-DMLN_QT_WITH_INTERNAL_ICU=ON",
      backend,
      *std_cmake_args
    system "cmake", "--build", "build", "--target", "MLNQtCore"
    system "cmake", "--install", "build"

    # Drop private mbgl headers: the only files that collide with maplibre-gl-native.
    # Public API (QMapLibre.framework / include/QMapLibre) is untouched.
    rm_r(include/"mbgl") if (include/"mbgl").exist?
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.19)
      project(qmaplibre_smoke LANGUAGES CXX)
      find_package(QMapLibre COMPONENTS Core REQUIRED)
    CMAKE
    system "cmake", "-S", testpath, "-B", "#{testpath}/build",
      "-DCMAKE_PREFIX_PATH=#{prefix};#{formula_opt_prefix("qt")}"
  end
end
