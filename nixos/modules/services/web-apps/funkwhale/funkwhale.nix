{config, lib, pkgs, ...}:

with lib;

let
  pythonEnv = (pkgs.python3.override {
    packageOverrides = self: super: rec {
      django = super.django_2_1;

			# Needs
			#  pillow 5.4 ?
			#  mutagen 1.42 ?

      # 2.10.6 needed ; bug in 3.0.1 cf. https://github.com/celery/celery/issues/5175
      redis = super.buildPythonPackage rec {
        pname = "redis";
        version = "2.10.6";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "03vcgklykny0g0wpvqmy8p6azi2s078317wgb2xjv5m2rs9sjb52";
        };
        doCheck = false; # tests require a running redis
        meta = {
          description = "Python client for Redis key-value store";
          homepage = "https://pypi.python.org/pypi/redis/";
        };
      };

      # celery package tests fail
      celery = super.celery.overridePythonAttrs(old: rec { doCheck = false; });

      django_taggit = super.django_taggit.overridePythonAttrs(old: rec { 
        buildInputs = [ super.isort django ]; 
      });

      # There is a pending pull request for this package : https://github.com/NixOS/nixpkgs/pull/44086
      django-cors-headers = super.buildPythonPackage rec {
        pname = "django-cors-headers";
        version = "2.4.0";
        # Don't use the PyPI source because it's missing test files
        src = pkgs.fetchFromGitHub {
          owner = "ottoyiu";
          repo = "django-cors-headers";
          rev = version;
          sha256 = "1bj3fj4cknmf8qqnv91rig3gablnx6hx2rlvbnhcgwm97awdsmpf";
        };
        checkInputs = [ super.pytest super.pytest-django super.pytestcov ];
        checkPhase = ''
          PYTHONPATH="$(pwd):$PYTHONPATH" \
          DJANGO_SETTINGS_MODULE=tests.settings \
            pytest tests
        '';
        meta = with pkgs.stdenv.lib; {
          description = "Django app for handling the server headers required for CORS";
          homepage = https://github.com/ottoyiu/django-cors-headers;
          license = licenses.mit;
        };
      };

      # 2.1.0 needed (last version on pypi = 3.0.1)
      django-cleanup = super.buildPythonPackage rec {
        pname = "django-cleanup";
        version = "2.1.0";
        name = "${pname}-${version}";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "0pdgmcl2w3laxiapmscdgmx3gpdyq7dxkydm9jk22pyp00r7i48f";
        };
				# tests not included with pypi release
				doCheck = false;
      };

      # 1.0.0 needed for channel-redis 2.3.3 (last version on pypi : 1.2.0)
      aioredis = super.buildPythonPackage rec {
        pname = "aioredis";
        version = "1.0.0";
        name = "${pname}-${version}";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "9d735f09117e68fe8a2bf1e1d1d2d31287fffa023903a3629fdc43c391787c0f";
        };
        buildInputs = [ super.redis super.async-timeout super.hiredis ];
				# tests not included with pypi release
				doCheck = false;
      };

      # 0.6.0 required by channels-redis (0.6.1 on pypi)
      msgpack = super.buildPythonPackage rec {
        pname = "msgpack";
        version = "0.6.0";
        name = "${pname}-${version}";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "64abc6bf3a2ac301702f5760f4e6e227d0fd4d84d9014ef9a40faa9d43365259";
        };
				# doCheck = false;
        checkPhase = "py.test";
        checkInputs = [ super.pytest ];
        meta = {
          homepage = https://github.com/msgpack/msgpack-python;
          description = "MessagePack serializer implementation for Python";
          license = lib.licenses.asl20;
        };
      };

      # dependencies on msgpack 0.6.0
      channels-redis = super.buildPythonPackage rec {
        pname = "channels_redis";
        version = "2.3.3";
        name = "${pname}-${version}";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "3f84ebce1e20e339c099ac0ea336fdc6a599882eee4f2a01b394d766488c9d45";
        };
        buildInputs = [ super.redis super.channels msgpack aioredis super.hiredis ];
				doCheck = false;
        meta = {
          homepage = http://github.com/django/channels_redis/;
          description = "Redis-backed ASGI channel layer implementation";
          license = lib.licenses.bsd3;
        };
      };

      ## from the author of Funkwhale 
      django-dynamic-preferences = super.buildPythonPackage rec {
        pname = "django-dynamic-preferences";
        version = "1.7";
        name = "${pname}-${version}";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "0izvn5glc7mpy8qf18w9nh3wzhs3kx63fck66rcmj69d4jg1bihf";
        };
        buildInputs = [ super.six django persisting-theory ]; 
				# tests not included with pypi release
				doCheck = false;
      };

      ## from the author of Funkwhale 
      persisting-theory = super.buildPythonPackage rec {
        pname = "persisting-theory";
        version = "0.2.1";
        name = "${pname}-${version}";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "00ff7dcc8f481ff75c770ca5797d968e8725b6df1f77fe0cf7d20fa1e5790c0a";
        };
        checkInputs = [ super.nose ];
        checkPhase = "nosetests";
      };
    };

    }).withPackages (ps: [
              ps.aioredis
              ps.beautifulsoup4
              ps.celery
              ps.channels
              ps.channels-redis
              ps.daphne
              ps.django
              ps.django-allauth
              ps.django-auth-ldap
              ps.django-cleanup
              ps.django-cors-headers
              ps.django-dynamic-preferences
              ps.django_environ
              ps.django-filter
              ps.django_redis
              ps.django-rest-auth
              ps.djangorestframework
              ps.djangorestframework-jwt
              ps.django_taggit
              ps.django-versatileimagefield
              ps.persisting-theory
              ps.requests-http-signature
              ps.ldap
              ps.markdown
              ps.msgpack
              ps.mutagen
              ps.musicbrainzngs
              ps.pillow
              ps.pendulum
              ps.psycopg2
              ps.pyacoustid
              ps.pydub
              ps.pymemoize
              ps.python_magic
              ps.redis
              ps.service-identity
            ]);
  cfg              = config.services.funkwhale;
  funkwhaleEnvFile = pkgs.writeText "funkwhale.env" ''
    FUNKWHALE_API_IP=${cfg.apiIp}
    FUNKWHALE_API_PORT=${toString cfg.apiPort}
    FUNKWHALE_URL=${cfg.hostname}
    FUNKWHALE_HOSTNAME=${cfg.hostname}
    FUNKWHALE_PROTOCOL=${cfg.protocol}
    EMAIL_CONFIG=${cfg.emailConfig}
    DEFAULT_FROM_EMAIL=${cfg.defaultFromEmail}
    REVERSE_PROXY_TYPE=nginx
    DATABASE_URL=postgresql://funkwhale@:5432/funkwhale
    CACHE_URL=redis://127.0.0.1:6379/0
    MEDIA_ROOT=${cfg.api.mediaRoot}
    STATIC_ROOT=${cfg.api.staticRoot}
    DJANGO_SETTINGS_MODULE=config.settings.production
    DJANGO_SECRET_KEY=${cfg.api.djangoSecretKey}
    RAVEN_ENABLED=${boolToString cfg.enableRaven}
    RAVEN_DSN=https://44332e9fdd3d42879c7d35bf8562c6a4:0062dc16a22b41679cd5765e5342f716@sentry.eliotberriot.com/5
    MUSIC_DIRECTORY_PATH=${cfg.musicDirectoryPath}
    MUSIC_DIRECTORY_SERVE_PATH=${cfg.musicDirectoryPath}
    FUNKWHALE_FRONTEND_PATH=${cfg.dataDir}/front/dist
    NGINX_MAX_BODY_SIZE=100M
  '';
  funkwhaleEnv = {
    ENV_FILE = "${funkwhaleEnvFile}";
  };
in 
{ 

  options = {
    services.funkwhale = {
      enable = mkEnableOption "funkwhale";

      dataDir = mkOption {
        type = types.string;
        default = "/srv/funkwhale";
        description = ''
          Where to keep the funkwhale data.
        '';
      };

      apiIp = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = ''
          Funkwhale API IP.
        '';
      };

      apiPort = mkOption {
        type = types.port;
        default = 5000;
        description = ''
          Funkwhale API Port.
        '';
      };

      hostname = mkOption {
        type = types.str;
        description = ''
          The definitive, public domain you will use for your instance.
        '';
        example = "funkwhale.yourdomain.net";
      };

      protocol = mkOption {
        type = types.enum [ "http" "https" ];
        default = "https";
        description = ''
          Web server protocol.
        '';
      };

      emailConfig = mkOption {
        type = types.str;
        default = "consolemail://";
        description = ''
          Configure email sending. By default, it outputs emails to console instead of sending them. See https://docs.funkwhale.audio/configuration.html#email-config for details.
        '';
        example = "smtp+ssl://user@:password@youremail.host:465";
      };

      defaultFromEmail = mkOption {
        type = types.str;
        description = ''
          The email address to use to send system emails.
        '';
        example = "funkwhale@yourdomain.net";
      };

      api = {
        mediaRoot = mkOption {
          type = types.str;
          default = "/srv/funkwhale/data/media";
          description = ''
            Where media files (such as album covers or audio tracks) should be stored on your system ? Ensure this directory actually exists.
          '';
        };

        staticRoot = mkOption {
          type = types.str;
          default = "/srv/funkwhale/data/static";
          description = ''
            Where static files (such as API css or icons) should be compiled on your system ? Ensure this directory actually exists.
          '';
        };

        djangoSecretKey = mkOption {
          type = types.str;
          description = ''
            Django secret key. Generate one using `openssl rand -base64 45` for example.
          '';
          example = "6VhAWVKlqu/dJSdz6TVgEJn/cbbAidwsFvg9ddOwuPRssEs0OtzAhJxLcLVC";
        };
      };

      musicDirectoryPath = mkOption {
        type = types.str;
        default = "/srv/funkwhale/data/music";
        description = ''
          In-place import settings.
        '';
      };

      enableRaven = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Sentry/Raven error reporting (server side).
          Enable Raven if you want to help improve funkwhale by
          automatically sending error reports to the funkwhale developers Sentry instance.
          This will help them detect and correct bugs.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    users.users.funkwhale = {
      description = "Funkwhale service user";
      isSystemUser = true;
      createHome = false;
      home = cfg.dataDir;
      group = "funkwhale";
    };

    users.groups.funkwhale = {};

    services.ntp.enable = true; 
    services.redis.enable =  true;
    services.postgresql = {
      enable = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE funkwhale WITH LOGIN PASSWORD 'funkwhale' CREATEDB;
        CREATE DATABASE funkwhale WITH ENCODING 'utf8';
        GRANT ALL PRIVILEGES ON DATABASE funkwhale TO funkwhale;
      '';
    };
    services.nginx = {
      enable = true;
      appendHttpConfig = ''
        upstream funkwhale-api {
          server ${cfg.apiIp}:${toString cfg.apiPort};
        }
      '';
      virtualHosts = 
      let proxyConfig = ''
          # global proxy conf
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Host $host:$server_port;
          proxy_set_header X-Forwarded-Port $server_port;
          proxy_redirect off;

          # websocket support
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;
        '';
        withSSL = cfg.protocol == "https";
      in {
        "${cfg.hostname}" = {
          enableACME = withSSL;
          forceSSL = withSSL;
          root = "${pkgs.funkwhale}/front";
          locations = {
            "/" = { 
              extraConfig = proxyConfig;
              proxyPass = "http://funkwhale-api/";
            };
					  "/front/" = {
							alias = "${pkgs.funkwhale}/front/";
              extraConfig = ''
								expires 30d;
								add_header Pragma public;
								add_header Cache-Control "public, must-revalidate, proxy-revalidate";
							'';
						};
            "/federation/" = { 
              extraConfig = proxyConfig;
              proxyPass = "http://funkwhale-api/federation/";
            };
            "/rest/" = { 
              extraConfig = proxyConfig;
              proxyPass = "http://funkwhale-api/api/subsonic/rest/";
            };
            "/.well-known/" = { 
              extraConfig = proxyConfig;
              proxyPass = "http://funkwhale-api/.well-known/";
            };
            "/media".alias = cfg.api.mediaRoot;
            "/_protected/media" = {
              extraConfig = ''
                internal;
              '';
              alias = cfg.api.mediaRoot;
            };
            "/_protected/music" = {
              extraConfig = ''
                internal;
              '';
              alias = cfg.musicDirectoryPath;
            };
            "/staticfiles".alias = cfg.api.staticRoot;
          };
        };
        };
      };

      systemd.tmpfiles.rules = [
        "d ${cfg.dataDir} 0755 funkwhale funkwhale -"
        "d ${cfg.api.mediaRoot} 0755 funkwhale funkwhale -"
        "d ${cfg.api.staticRoot} 0755 funkwhale funkwhale -"
        "d ${cfg.musicDirectoryPath} 0755 funkwhale funkwhale -"
      ];

      systemd.services = 
        let serviceConfig = {
            User = "funkwhale";
            WorkingDirectory = "${pkgs.funkwhale}";
            EnvironmentFile =  "${funkwhaleEnvFile}";
          };
        in {
        "funkwhale.target" = {
          description = "Funkwhale";
          wants = ["funkwhale-server.service" "funkwhale-worker.service" "funkwhale-beat.service"];
        };
        funkwhale-psql-init = {
          description = "Funkwhale database preparation";
          after = [ "redis.service" "postgresql.service" ];
          wantedBy = [ "funkwhale-init.service" ];
          before   = [ "funkwhale-init.service" ];
          serviceConfig = {
            User = "postgres";
          };
          script = ''
            ${pkgs.postgresql}/bin/psql -d funkwhale -c 'CREATE EXTENSION IF NOT EXISTS "unaccent";'
          '';
        };
        funkwhale-init = {
          description = "Funkwhale initialization";
          after = [ "funkwhale-psql-init.service" ];
          wantedBy = [ "funkwhale-server.service" "funkwhale-worker.service" "funkwhale-beat.service" ];
          before   = [ "funkwhale-server.service" "funkwhale-worker.service" "funkwhale-beat.service" ];
          environment = funkwhaleEnv;
          script = ''
            ${pythonEnv}/bin/python ${pkgs.funkwhale}/manage.py migrate
            ${pythonEnv}/bin/python ${pkgs.funkwhale}/manage.py collectstatic
            if ! test -e ${cfg.dataDir}/createSuperUser.sh; then
              echo "#!/bin/sh
            
              set -a
              . ${funkwhaleEnvFile}
              set +a
              ${pythonEnv}/bin/python ${pkgs.funkwhale}/manage.py createsuperuser" > ${cfg.dataDir}/createSuperUser.sh
              chmod u+x ${cfg.dataDir}/createSuperUser.sh
              chown -R funkwhale.funkwhale ${cfg.dataDir}
            fi
            if ! test -e ${cfg.dataDir}/config; then
              mkdir -p ${cfg.dataDir}/config
              ln -s ${funkwhaleEnvFile} ${cfg.dataDir}/config/.env
              ln -s ${funkwhaleEnvFile} ${cfg.dataDir}/.env
            fi
          '';
        };

        funkwhale-server = {
          description = "Funkwhale application server";
          partOf = [ "funkwhale.target" ];

          serviceConfig = serviceConfig;
          environment = funkwhaleEnv;
          script = "${pythonEnv}/bin/daphne -b ${cfg.apiIp} -p ${toString cfg.apiPort} config.asgi:application --proxy-headers";

          wantedBy = [ "multi-user.target" ];
        };

        funkwhale-worker = {
          description = "Funkwhale celery worker";
          partOf = [ "funkwhale.target" ];

          serviceConfig = serviceConfig // { RuntimeDirectory = "funkwhaleworker"; };
          environment = funkwhaleEnv;
            
          script = '' ${pythonEnv}/bin/celery -A funkwhale_api.taskapp worker -l INFO '';
          wantedBy = [ "multi-user.target" ];
        };

        funkwhale-beat = {
          description = "Funkwhale celery beat process";
          partOf = [ "funkwhale.target" ];

          serviceConfig = serviceConfig // { RuntimeDirectory = "funkwhalebeat"; };
          environment = funkwhaleEnv;
          script = ''
            ${pythonEnv}/bin/celery -A funkwhale_api.taskapp beat -l INFO --schedule="/run/funkwhalebeat/celerybeat-schedule.db"  --pidfile="/run/funkwhalebeat/celerybeat.pid"
            '';

          wantedBy = [ "multi-user.target" ];
        };

      };

      environment.systemPackages = with pkgs; [ ffmpeg libjpeg ];

  };

  meta = {
    maintainers = with lib.maintainers; [ mmai ];
  };
}
