{ stdenv
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "requests-http-signature";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e39d928469e6f1411e3bffca74a280ac9375d4fa5bf03552974f0ba4ff4c37a";
  };
  buildInputs = [ requests ];

  # missing files for tests in pypi release (keys)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Requests auth module for HTTP Signature";
    homepage = "https://github.com/kislyuk/requests-http-signature";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmai ];
  };
}
