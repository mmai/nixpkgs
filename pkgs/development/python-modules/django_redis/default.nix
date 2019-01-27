{ stdenv, fetchPypi, buildPythonPackage,
  mock, django, redis, msgpack }:
buildPythonPackage rec {
  pname = "django-redis";
  version = "4.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af0b393864e91228dd30d8c85b5c44d670b5524cb161b7f9e41acc98b6e5ace7";
  };

  doCheck = false;

  buildInputs = [ mock ];

  propagatedBuildInputs = [
    django
    redis
    msgpack
  ];

  meta = with stdenv.lib; {
    description = "Full featured redis cache backend for Django";
    homepage = https://github.com/niwibe/django-redis;
    license = licenses.bsd3;
  };
}
