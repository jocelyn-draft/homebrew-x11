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
      return "macosx-ppc"
    elsif MacOS.prefer_64_bit?
      return "macosx-x86-64"
    else
      return "macosx-x86"
    end
  end
	

  def install
    system "./compile_exes", ise_platform
    system "./make_images", ise_platform
    prefix.install Dir["Eiffel_14.05/*"]
  end

  test do
    system "#{prefix}/studio/spec/" + ise_platform + "/bin/ec", "-version"
  end

  def caveats; <<-EOS.undent
    Add these to your shell profile:
      export ISE_EIFFEL=#{prefix}
      export ISE_PLATFORM=#{ise_platform}

    And add this to your PATH:
      $ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin
      $ISE_EIFFEL/tools/spec/$ISE_PLATFORM/bin
    EOS
  end
end
