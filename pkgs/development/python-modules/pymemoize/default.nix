{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "PyMemoize";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07c7b8f592b1f03af74289ef0e554520022dae378ba36d0dbc1f80532130197b";
  };

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Simple Python cache and memoizing module";
    homepage = "http://github.com/mikeboers/PyMemoize";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}

