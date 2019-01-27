{ stdenv
, buildPythonPackage
, fetchPypi
, ldap , django_2_0 
, mock
}:

buildPythonPackage rec {
  pname = "django-auth-ldap";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72848b3b036d299114be3c6ef38b12f83f6cf1cf1696c5f92e06fe45a1b8e27b";
  };

  buildInputs = [ ldap django_2_0 ]; 
  checkInputs = [ mock ]; 

  # django.core.exceptions.AppRegistryNotReady: Apps aren't loaded yet
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Django LDAP authentication backend";
    homepage = https://github.com/django-auth-ldap/django-auth-ldap;
    license = licenses.bsd2;
    maintainers = with maintainers; [ mmai ];
  };
}
