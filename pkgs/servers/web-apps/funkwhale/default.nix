{ stdenv, fetchurl, unzip }:

# This is the front-end part of the funkwhale app
# See pythonPackages.funkwhale package for the Django API

# Look for the correct url for build_front artifacts on the tags page of the project : https://dev.funkwhale.audio/funkwhale/funkwhale/pipelines?scope=tags
# Attention : do not use the url "https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/artifacts/${version}/download?job=" : it is not guaranteed to be stable

stdenv.mkDerivation {
  name = "funkwhale";
  version = "0.20.0";
  src = fetchurl {
    url = https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/31308/artifacts/download;
    name =  "frontend.zip";
    sha256 = "02pc6j83sn5l8wz7i2r649pff3gs5021isx9d5l9xsb5cndkq0b4";
  };
  nativeBuildInputs = [ unzip ];
  installPhase = ''
    mkdir $out
    cp -R ./dist $out
  '';
  meta = with stdenv.lib; {
    description = "A modern, convivial and free music server";
    homepage = https://funkwhale.audio/;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mmai ];
  };
 }
