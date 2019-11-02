{ funkwhale-django, lib, writers }:

## Usage
#
# nix-build --out-link ./funkwhale-django -E '
# (import <nixpkgs> {}).funkwhale-django.withConfig {
#   dataDir = /tmp/paperless-data;
#   config = {
#     PAPERLESS_DISABLE_LOGIN = "true";
#   };
# }'
#
# Setup DB
# ./funkwhale-django migrate
#
# Start web interface
# ./funkwhale-django  runserver --noreload localhost:8000

{ config ? {}, dataDir ? null, extraCmds ? "" }:
with lib;
let
  envVars = (optionalAttrs (dataDir != null) {
    PAPERLESS_CONSUMPTION_DIR = "${dataDir}/consume";
    PAPERLESS_MEDIADIR = "${dataDir}/media";
    PAPERLESS_STATICDIR = "${dataDir}/static";
    PAPERLESS_DBDIR = dataDir;
  }) // config;

  envVarDefs = mapAttrsToList (n: v: ''export ${n}="${toString v}"'') envVars;
  setupEnvVars = builtins.concatStringsSep "\n" envVarDefs;

  setupEnv = ''
    source ${funkwhale-django}/share/funkwhale/setup-env.sh
    ${setupEnvVars}
    ${optionalString (dataDir != null) ''
      mkdir -p "$PAPERLESS_CONSUMPTION_DIR" \
               "$PAPERLESS_MEDIADIR" \
               "$PAPERLESS_STATICDIR" \
               "$PAPERLESS_DBDIR"
    ''}
  '';

  runFunkwhale = writers.writeBash "funkwhale" ''
    set -e
    ${setupEnv}
    ${extraCmds}
    exec python $funkwhaleSrc/manage.py "$@"
  '';
in
  runFunkwhale // {
    inherit funkwhale-django setupEnv;
  }
