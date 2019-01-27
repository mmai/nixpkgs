{ stdenv
, buildPythonPackage
, fetchPypi
, pyjwt 
}:

buildPythonPackage rec {
  pname = "djangorestframework-jwt";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5efe33032f3a4518a300dc51a51c92145ad95fb6f4b272e5aa24701db67936a7";
  };

  buildInputs = [ pyjwt ];

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    description = "JSON Web Token Authentication support for Django REST Framework";
    homepage = "https://github.com/GetBlimp/django-rest-framework-jwt";
    licence = licences.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
