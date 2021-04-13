{ lib, stdenv, fetchurl, glib, gtk3, gperf, pkg-config, bzip2, tcl, tk, wrapGAppsHook, judy, xz }:

stdenv.mkDerivation rec {
  pname = "gtkwave";
  version = "3.3.108";

  src = fetchurl {
    url    = "mirror://sourceforge/gtkwave/${pname}-gtk3-${version}.tar.gz";
    sha256 = "sha256-LtlexZKih+Si/pH3oQpWdpzfZ6j+41Otgfx7nLMfFSQ=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ glib gtk3 gperf bzip2 tcl tk judy xz ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--enable-judy"
    "--enable-gtk3"
  ];

  meta = {
    description = "VCD/Waveform viewer for Unix and Win32";
    homepage    = "http://gtkwave.sourceforge.net";
    license     = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms   = lib.platforms.linux;
  };
}
