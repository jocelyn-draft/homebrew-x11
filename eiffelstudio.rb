require "formula"

class Eiffelstudio < Formula
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/14.05/eiffelstudio-14.05.tar"
  sha1 "e0b9d0c4c10f6191e4b0b2ccbb6efc9345c2f950"

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on "gtk+"

  def ise_platform
    if Hardware::CPU.ppc?
      "macosx-ppc"
    elsif MacOS.prefer_64_bit?
      "macosx-x86-64"
    else
      "macosx-x86"
    end
  end

  def install
    system "./compile_exes", ise_platform
    system "./make_images", ise_platform
    prefix.install Dir["Eiffel_14.05/*"]
    bin.mkpath
    env = { :ISE_EIFFEL => prefix, :ISE_PLATFORM => ise_platform , :PKG_CONFIG_PATH => "/opt/X11/lib/pkgconfig" }
    (bin + exe).write_env_script(prefix+"studio/spec/#{ise_platform}/bin/ec", env)
    (bin + exe).write_env_script(prefix+"studio/spec/#{ise_platform}/bin/ecb", env)
    (bin + exe).write_env_script(prefix+"studio/spec/#{ise_platform}/bin/estudio", env)
    (bin + exe).write_env_script(prefix+"studio/spec/#{ise_platform}/bin/finish_freezing", env)
    (bin + exe).write_env_script(prefix+"tools/spec/#{ise_platform}/bin/compile_all", env)
    (bin + exe).write_env_script(prefix+"tools/spec/#{ise_platform}/bin/iron", env)
    (bin + exe).write_env_script(prefix+"tools/spec/#{ise_platform}/bin/syntax_updater", env)
  end

  test do
    # More extensive testing requires the full test suite
    # which is not part of this package.
    system "#{prefix}/studio/spec/#{ise_platform}/bin/ec", "-version"
  end
end
