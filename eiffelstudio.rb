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

    # Create a link in the bin directory
    # to $ISE_EIFFEL/$root/spec/$ISE_PLATFORM/bin/$exe
    # that sets up the proper environment before launching $exe.
  def create_link root, exe, env
    (bin + exe).write_env_script(prefix+"#{root}/spec/#{ise_platform}/bin/#{exe}", env)
  end

  def install
      # Compile binaries
    system "./compile_exes", ise_platform
      # Create installation images
    system "./make_images", ise_platform
      # Copy files to Cellar
    prefix.install Dir["Eiffel_14.05/*"]
      # Create bin folder where all symbolic links to Eiffel executables
      # will be located.
    bin.mkpath
      # Setup environment to start Eiffel executables.
    env = { :ISE_EIFFEL => prefix, :ISE_PLATFORM => ise_platform }
      # Setup links to Eiffel executables.
    create_link("studio", "ec", env)
    create_link("studio", "ecb", env)
    create_link("studio", "estudio", env)
    create_link("studio", "finish_freezing", env)
    create_link("tools", "compile_all", env)
    create_link("tools", "iron", env)
    create_link("tools", "syntax_updater", env)
  end

  test do
      # Simple test to check ec was properly compiled.
      # More extensive testing requires the full test suite
      # which is not part of this package.
    system "#{prefix}/studio/spec/#{ise_platform}/bin/ec", "-version"
  end
end
