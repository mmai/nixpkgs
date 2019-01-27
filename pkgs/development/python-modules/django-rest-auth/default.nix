{ stdenv
, buildPythonPackage
, fetchPypi
, djangorestframework , six
, djangorestframework-jwt, django-allauth, responses, pytest, django, mock
}:

buildPythonPackage rec {
  pname = "django-rest-auth";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad155a0ed1061b32e3e46c9b25686e397644fd6acfd35d5c03bc6b9d2fc6c82a";
  };

  buildInputs = [ djangorestframework six ]; 

  # ImportError: Failed to import test module: runtests
  doCheck = false;
  checkInputs = [ djangorestframework-jwt django-allauth responses django mock pytest ];

  meta = with stdenv.lib; {
    description = "Create a set of REST API endpoints for Authentication and Registration";
    homepage = "http://github.com/Tivix/django-rest-auth";
    licence = licences.mit;
    maintainers = with maintainers; [ mmai ];
  };
}

