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
  funkwhaleHome    = config.users.extraUsers.funkwhale.home;
  funkwhaleEnvFile = pkgs.writeText "funkwhale.env" ''
    FUNKWHALE_API_IP=${cfg.apiIp}
    FUNKWHALE_API_PORT=${toString cfg.apiPort}
    FUNKWHALE_URL=${cfg.hostname}
    FUNKWHALE_HOSTNAME=${cfg.hostname}
    FUNKWHALE_PROTOCOL=${cfg.protocol}
    EMAIL_CONFIG=${cfg.emailConfig}
    DEFAULT_FROM_EMAIL=${cfg.defaultFromEmail}
    REVERSE_PROXY_TYPE=nginx
    DATABASE_URL=${cfg.api.databaseUrl}
    CACHE_URL=${cfg.api.cacheUrl}
    MEDIA_ROOT=${cfg.api.mediaRoot}
    STATIC_ROOT=${cfg.api.staticRoot}
    DJANGO_ALLOWED_HOSTS=${cfg.api.djangoAllowedHosts}
    DJANGO_SETTINGS_MODULE=config.settings.production
    DJANGO_SECRET_KEY=${cfg.api.djangoSecretKey}
    RAVEN_ENABLED=false
    RAVEN_DSN=https://44332e9fdd3d42879c7d35bf8562c6a4:0062dc16a22b41679cd5765e5342f716@sentry.eliotberriot.com/5
    MUSIC_DIRECTORY_PATH=${cfg.musicDirectoryPath}
    MUSIC_DIRECTORY_SERVE_PATH=${cfg.musicDirectoryPath}
    FUNKWHALE_FRONTEND_PATH=/srv/funkwhale/front/dist
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
      databaseUrl = mkOption {
        type = types.str;
        default = "postgresql://funkwhale@:5432/funkwhale";
        description = ''
          Database configuration.
          '';
        example = "postgresql://user:password@host:port/database";
      };

      cacheUrl = mkOption {
        type = types.str;
        default = "redis://127.0.0.1:6379/0";
        description = ''
          Cache configuration.
          '';
        example = "redis://host:port/database";
      };

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

      djangoAllowedHosts = mkOption {
        type = types.str;
        description = ''
          Update it to match the domain that will be used to reach your funkwhale instance.
        '';
        example = "funkwhale.yourdomain.net";
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

    };
  };

  config = mkIf cfg.enable {
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
      in {
        "${cfg.hostname}" = {
        # enableACME = true; #Ask Let's Encrypt to sign a certificate for this vhost
        # addSSL = true;
        # forceSSL = true;
          root = "${pkgs.funkwhale}/front";
          default = true;
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
            "/media/".alias = "${cfg.api.mediaRoot}/";
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
            "/staticfiles/".alias = "${cfg.api.staticRoot}/";
          };
        };
        };
      };

      # systemd.tmpfiles.rules = [
      #   "d ${funkwhaleHome} 0755 funkwhale ${cfg.group} -"
      # ];

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
            chmod a+rx ${funkwhaleHome}
            if ! test -e ${cfg.api.mediaRoot}; then
            mkdir -p ${cfg.api.mediaRoot}
            mkdir -p ${cfg.api.staticRoot}
            mkdir -p ${cfg.musicDirectoryPath}
            echo "#!/bin/sh
            
            ${pythonEnv}/bin/python ${pkgs.funkwhale}/manage.py createsuperuser" > ${funkwhaleHome}/createSuperUser.sh
            chmod u+x ${funkwhaleHome}/createSuperUser.sh
            chown -R funkwhale.users ${funkwhaleHome}

            ${pythonEnv}/bin/python ${pkgs.funkwhale}/manage.py migrate
            ${pythonEnv}/bin/python ${pkgs.funkwhale}/manage.py collectstatic
            fi
            if ! test -e ${funkwhaleHome}/config; then
              mkdir -p ${funkwhaleHome}/config
              ln -s ${funkwhaleEnvFile} ${funkwhaleHome}/config/.env
              ln -s ${funkwhaleEnvFile} ${funkwhaleHome}/.env
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
