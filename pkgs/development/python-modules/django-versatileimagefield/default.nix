{ stdenv
, buildPythonPackage
, fetchPypi
, pillow
}:

buildPythonPackage rec {
  pname = "django-versatileimagefield";
  version = "1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "886d084a95775a452602e3f63201022850281414affb4b7d0e3d3ddfb5361978";
  };
  buildInputs = [ pillow ];

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A drop-in replacement for django's ImageField that provides a flexible, intuitive and easily-extensible interface for creating new images from the one assigned to the field";
    homepage = "http://github.com/respondcreate/django-versatileimagefield/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}

