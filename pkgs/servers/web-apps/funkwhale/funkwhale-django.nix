{ stdenv, python3, fetchurl, unzip, buildPythonPackage,
#  aioredis,
#  aiohttp,
#  autobahn,
#  av,
#  boto3,
#  celery,
#  channels,
#  channels-redis,
# django_2_2,
#  django-allauth,
#  django-auth-ldap,
#  django-oauth-toolkit,
#  django-cleanup,
#  django-cors-headers,
#  django-dynamic-preferences,
#  django_environ,
#  django-filter,
#  django_redis,
#  django-rest-auth,
#  djangorestframework,
#  djangorestframework-jwt,
#  django-storages,
#  django_taggit,
#  django-versatileimagefield,
#  gunicorn,
#  kombu,
#  ldap,
#  mutagen,
#  musicbrainzngs,
#  pillow,
#  pendulum,
#  persisting-theory,
#  psycopg2,
#  pyacoustid,
#  pydub,
#  PyLD,
#  pymemoize,
#  pyopenssl,
#  python_magic,
#  redis,
#  requests,
#  requests-http-signature,
#  service-identity,
#  unidecode,
#  unicode-slugify,
#  uvicorn
}:

# Look for the correct urls for build_front and build_api artifacts on the tags page of the project : https://dev.funkwhale.audio/funkwhale/funkwhale/pipelines?scope=tags
# Attention : do not use the url "https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/artifacts/${version}/download?job=" : it is not guaranteed to be stable

let
  python = (python3.override {
    packageOverrides = self: super: rec {
      django = self.django_2_2;
    };
  }).withPackages (ps: [
    ps.aioredis
    ps.aiohttp
    ps.autobahn
    ps.av
    ps.boto3
    ps.celery
    ps.channels
    ps.channels-redis
    ps.django
    ps.django-allauth
    ps.django-auth-ldap
    ps.django-oauth-toolkit
    ps.django-cleanup
    ps.django-cors-headers
    ps.django-dynamic-preferences
    ps.django_environ
    ps.django-filter
    ps.django_redis
    ps.django-rest-auth
    ps.djangorestframework
    ps.djangorestframework-jwt
    ps.django-storages
    ps.django_taggit
    ps.django-versatileimagefield
    ps.gunicorn
    ps.kombu
    ps.ldap
    ps.mutagen
    ps.musicbrainzngs
    ps.pillow
    ps.pendulum
    ps.persisting-theory
    ps.psycopg2
    ps.pyacoustid
    ps.pydub
    ps.PyLD
    ps.pymemoize
    ps.pyopenssl
    ps.python_magic
    ps.redis
    ps.requests
    ps.requests-http-signature
    ps.service-identity
    ps.unidecode
    ps.unicode-slugify
    ps.uvicorn
  ]);
in

# We turn those Djando configuration files into a make-shift Python library so
# that Nix users can use this package as a part of their buildInputs to import
# the code. Also, this package implicitly provides an environment in which the
# Django app can be run.

# let 
#   django = django_2_2;
#   python = (python3.override {
#      packageOverrides = self: super: rec {
#        django = self.django_2_2;
#      };
#    });
#
# in

buildPythonPackage {
  # stdenv.mkDerivation {
  pname = "funkwhale";
  version = "0.20.0";
  src = fetchurl {
    url = https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/31311/artifacts/download;
    name =  "api.zip";
    sha256 = "1v8v5rha21ksdqnj73qkvc35mxal82hypxa5gnf82y1cjk2lp4w7";
  };
  nativeBuildInputs = [ unzip ];
  propagatedBuildInputs = [ python ]; 
#   propagatedBuildInputs = [ 
# aioredis
# aiohttp
# autobahn
# av
# boto3
# celery
# channels
# channels-redis
# django
# django-allauth
# django-auth-ldap
# django-oauth-toolkit
# django-cleanup
# django-cors-headers
# django-dynamic-preferences
# django_environ
# django-filter
# django_redis
# django-rest-auth
# djangorestframework
# djangorestframework-jwt
# django-storages
# django_taggit
# django-versatileimagefield
# gunicorn
# kombu
# ldap
# mutagen
# musicbrainzngs
# pillow
# pendulum
# persisting-theory
# psycopg2
# pyacoustid
# pydub
# PyLD
# pymemoize
# pyopenssl
# python_magic
# redis
# requests
# requests-http-signature
# service-identity
# unidecode
# unicode-slugify
# uvicorn
# ];
  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace "django-cleanup==3.2.0" django-cleanup
  '';
  buildPhase = ":";
  setuptoolsCheckPhase = ":";
  installPhase = ''
    d=$out/${python3.sitePackages}
  '';

  meta = with stdenv.lib; {
    description = "A modern, convivial and free music server";
    homepage = https://funkwhale.audio/;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mmai ];
  };
 }
