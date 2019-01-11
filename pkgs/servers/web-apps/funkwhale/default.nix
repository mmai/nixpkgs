{ stdenv, fetchurl, unzip }:

let
  release = "0.18";
  srcsUrl  = "https://code.eliotberriot.com/funkwhale/funkwhale/-/jobs/artifacts/${release}/download?job=";
  srcs = {
    api = fetchurl {
      url =  "${srcsUrl}build_api";
      name =  "api.zip";
      sha256 = "1wv4sgv9pscdksr35kj5m1g7nwn1gkv7k285rm0ilbg24w5j6fdx";
    };
    frontend = fetchurl {
      url =  "${srcsUrl}build_front";
      name =  "frontend.zip";
      sha256 = "12j09xzd31hxidh42dqdz07q267wskmz97c8xck2hwkldazxvyi0";
    };
  };
in stdenv.mkDerivation {
  name = "funkwhale";
  version = "${release}";
  src = srcs.api;
  buildInputs = [ unzip ];
  propagatedBuildInputs = [ ];
  installPhase = ''
    mkdir $out
    cp -R ./* $out
    unzip ${srcs.frontend} -d $out
    mv $out/front/ $out/front_tmp
    mv $out/front_tmp/dist $out/front
    rmdir $out/front_tmp
    '';

  meta = with stdenv.lib; {
    description = "A modern, convivial and free music server";
    homepage = https://funkwhale.audio/;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mmai ];
  };
 }
