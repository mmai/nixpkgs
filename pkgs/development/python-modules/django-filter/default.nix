{ stdenv
, buildPythonPackage
, fetchPypi
, django
, djangorestframework, python, mock
}:

buildPythonPackage rec {
  pname = "django-filter";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3dafb7d2810790498895c22a1f31b2375795910680ac9c1432821cbedb1e176d";
  };

  buildInputs = [ django ];

  # Tests fail (need the 'crispy_forms' module not packaged on nixos)
  doCheck = false;
  checkInputs = [ djangorestframework django mock ];
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py tests
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "Django-filter is a reusable Django application for allowing users to filter querysets dynamically";
    homepage = "https://pypi.org/project/django-filter/";
    licence = licences.bsd;
    maintainers = with maintainers; [ mmai ];
  };
}
