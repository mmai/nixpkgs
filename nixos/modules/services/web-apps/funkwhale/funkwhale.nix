{config, lib, pkgs, ...}:

with lib;

let
  pythonEnv = (
    let pythonRequirements = import ./requirements.nix { inherit pkgs; };
    in
      with pkgs; 
      python36.withPackages(ps: with ps; (builtins.attrValues pythonRequirements.packages))
    );
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
    DJANGO_ALLOWED_HOSTS=${cfg.hostname}
    DJANGO_SETTINGS_MODULE=config.settings.production
    DJANGO_SECRET_KEY=${cfg.api.djangoSecretKey}
    RAVEN_ENABLED=${boolToString cfg.enableRaven}
    RAVEN_DSN=https://44332e9fdd3d42879c7d35bf8562c6a4:0062dc16a22b41679cd5765e5342f716@sentry.eliotberriot.com/5
    MUSIC_DIRECTORY_PATH=${cfg.musicDirectoryPath}
    MUSIC_DIRECTORY_SERVE_PATH=${cfg.musicDirectoryPath}
    FUNKWHALE_FRONTEND_PATH=${cfg.dataDir}/front/dist
    NGINX_MAX_BODY_SIZE=30M
  '';
  funkwhaleEnv = {
    FUNKWHALE_ENV_FILE = "${funkwhaleEnvFile}";
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
              proxyWebsockets = true;
              tryFiles = "$uri $uri/ @rewrites";
            };
            "@rewrites".extraConfig = ''
                rewrite ^(.+)$ /index.html last;
              '';
            "/api/" = { 
              extraConfig = proxyConfig;
              proxyPass = "http://funkwhale-api/api/";
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
            if ! test -e ${cfg.dataDir}/createSuperUser.sh; then
              echo "#!/bin/sh
            
              ${pythonEnv}/bin/python ${pkgs.funkwhale}/manage.py createsuperuser" > ${cfg.dataDir}/createSuperUser.sh
              chmod u+x ${cfg.dataDir}/createSuperUser.sh
              chown -R funkwhale.funkwhale ${cfg.dataDir}
              ${pythonEnv}/bin/python ${pkgs.funkwhale}/manage.py migrate
              ${pythonEnv}/bin/python ${pkgs.funkwhale}/manage.py collectstatic
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
            
          script = ''
            ${pythonEnv}/bin/celery -A funkwhale_api.taskapp worker -l INFO
            '';

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

  };

  meta = {
    maintainers = with lib.maintainers; [ mmai ];
  };
}
