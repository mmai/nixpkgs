{ stdenv, python3, fetchurl, unzip
, makeWrapper
}:

# Look for the correct urls for build_front and build_api artifacts on the tags page of the project : https://dev.funkwhale.audio/funkwhale/funkwhale/pipelines?scope=tags
# Attention : do not use the url "https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/artifacts/${version}/download?job=" : it is not guaranteed to be stable

let
  pythonEnv = python.withPackages (_: runtimePackages);

  python = (python3.override {
    packageOverrides = self: super: rec {
      django = self.django_2_2;
    };
  });

  runtimePackages = with python.pkgs; [
    aioredis
    aiohttp
    autobahn
    av
    boto3
    celery
    channels
    channels-redis
    django
    django-allauth
    django-auth-ldap
    django-oauth-toolkit
    django-cleanup
    django-cors-headers
    django-dynamic-preferences
    django_environ
    django-filter
    django_redis
    django-rest-auth
    djangorestframework
    djangorestframework-jwt
    django-storages
    django_taggit
    django-versatileimagefield
    gunicorn
    kombu
    ldap
    mutagen
    musicbrainzngs
    pillow
    pendulum
    persisting-theory
    psycopg2
    pyacoustid
    pydub
    PyLD
    pymemoize
    pyopenssl
    python_magic
    redis
    requests
    requests-http-signature
    service-identity
    unidecode
    unicode-slugify
    uvicorn
  ];

  checkPackages = with python.pkgs; [
    pytest
    pytest-django
    pytest-env
    pytest_xdist
  ];

in

stdenv.mkDerivation rec {
  pname = "funkwhale-django";
  version = "0.20.0";
  src = fetchurl {
    url = https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/31311/artifacts/download;
    name =  "api.zip";
    sha256 = "1v8v5rha21ksdqnj73qkvc35mxal82hypxa5gnf82y1cjk2lp4w7";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  doCheck = true;
  dontInstall = true;

  unpackPhase = ''
    srcDir=$out/share/funkwhale
    mkdir -p $srcDir
    cp -r --no-preserve=mode $src/* $srcDir
  '';

  postPatch = ''
    substituteInPlace $out/share/funkwhale/requirements/base.txt \
      --replace "django-cleanup==3.2.0" django-cleanup
  '';

  buildPhase = ''
    ${python.interpreter} -m compileall $srcDir

    makeWrapper $pythonEnv/bin/python $out/bin/funkwhale \
      --add-flags $out/share/funkwhale/manage.py

    # A shell snippet that can be sourced to setup a funkwhale env
    cat > $out/share/funkwhale/setup-env.sh <<EOF
    export PATH="$pythonEnv/bin''${PATH:+:}$PATH"
    export funkwhaleSrc=$out/share/funkwhale
    EOF
  '';

  checkPhase = ''
    source $out/share/funkwhale/setup-env.sh
    tmpDir=$(realpath testsTmp)
    mkdir $tmpDir
    export HOME=$tmpDir
    cd $funkwhaleSrc
    # Prevent tests from writing to the derivation output
    chmod -R -w $out
    # Disable cache to silence a pytest warning ("could not create cache")
    $pythonCheckEnv/bin/pytest -p no:cacheprovider
  '';

  passthru = {
    withConfig = callPackage ./withConfig.nix {};
    inherit python runtimePackages checkPackages;
  };


  meta = with stdenv.lib; {
    description = "A modern, convivial and free music server";
    homepage = https://funkwhale.audio/;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mmai ];
  };
 }
