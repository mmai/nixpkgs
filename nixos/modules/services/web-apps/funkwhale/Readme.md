# NixOS Funkwhale service module

This module enable a complete Funkwhale service.

A deployment configuration example is available at https://github.com/mmai/funkwhale-nixos

## Development notes

_requirements.nix_ was generated using _pypi2nix_ on the funkwale sources :

```
git clone https://code.eliotberriot.com/funkwhale/funkwhale.git
cd funkwhale/api
git checkout 0.17
vim requirements/base.txt # requests-http-signature==0.1 instead of git+https://github.com/EliotBerriot/requests-http-signature.git@signature-header-support
pypi2nix -V "3.6" -e setuptools-scm -e m2r -r requirements/base.txt -E "postgresql libffi openssl openldap cyrus_sasl pkgconfig libjpeg openjpeg zlib libtiff freetype lcms2 libwebp tcl"
```

## Things to do when updating funkwhale

Look at changes in the following src files and update _funkwhale.nix_ accordingly :
- deploy/*.service
- deploy/nginx.template



