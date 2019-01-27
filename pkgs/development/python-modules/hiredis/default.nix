{ stdenv
, buildPythonPackage
, fetchPypi
, redis
}:

buildPythonPackage rec {
  pname = "hiredis";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e97c953f08729900a5e740f1760305434d62db9f281ac351108d6c4b5bf51795";
  };
  buildInputs = [ redis ];

  # Test fail
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python extension that wraps protocol parsing code in hiredis. It primarily speeds up parsing of multi bulk replies";
    homepage = "https://github.com/redis/hiredis-py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}

