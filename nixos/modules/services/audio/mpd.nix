{ config, lib, pkgs, ... }:

with lib;

let

  name = "mpd";

  uid = config.ids.uids.mpd;
  gid = config.ids.gids.mpd;
  cfg = config.services.mpd;

  credentialsPlaceholder = (creds:
    let
      placeholders = (imap0
        (i: c: ''password "{{password-${toString i}}}@${concatStringsSep "," c.permissions}"'')
        creds);
    in
      concatStringsSep "\n" placeholders);

  mpdConf = pkgs.writeText "mpd.conf" ''
    # This file was automatically generated by NixOS. Edit mpd's configuration
    # via NixOS' configuration.nix, as this file will be rewritten upon mpd's
    # restart.

    music_directory     "${cfg.musicDirectory}"
    playlist_directory  "${cfg.playlistDirectory}"
    ${lib.optionalString (cfg.dbFile != null) ''
      db_file             "${cfg.dbFile}"
    ''}
    state_file          "${cfg.dataDir}/state"
    sticker_file        "${cfg.dataDir}/sticker.sql"

    ${optionalString (cfg.network.listenAddress != "any") ''bind_to_address "${cfg.network.listenAddress}"''}
    ${optionalString (cfg.network.port != 6600)  ''port "${toString cfg.network.port}"''}
    ${optionalString (cfg.fluidsynth) ''
      decoder {
              plugin "fluidsynth"
              soundfont "${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2"
      }
    ''}

    ${optionalString (cfg.credentials != []) (credentialsPlaceholder cfg.credentials)}

    ${cfg.extraConfig}
  '';

in {

  ###### interface

  options = {

    services.mpd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable MPD, the music player daemon.
        '';
      };

      startWhenNeeded = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If set, <command>mpd</command> is socket-activated; that
          is, instead of having it permanently running as a daemon,
          systemd will start it on the first incoming connection.
        '';
      };

      musicDirectory = mkOption {
        type = with types; either path (strMatching "(http|https|nfs|smb)://.+");
        default = "${cfg.dataDir}/music";
        defaultText = "\${dataDir}/music";
        description = ''
          The directory or NFS/SMB network share where MPD reads music from. If left
          as the default value this directory will automatically be created before
          the MPD server starts, otherwise the sysadmin is responsible for ensuring
          the directory exists with appropriate ownership and permissions.
        '';
      };

      playlistDirectory = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/playlists";
        defaultText = "\${dataDir}/playlists";
        description = ''
          The directory where MPD stores playlists. If left as the default value
          this directory will automatically be created before the MPD server starts,
          otherwise the sysadmin is responsible for ensuring the directory exists
          with appropriate ownership and permissions.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra directives added to to the end of MPD's configuration file,
          mpd.conf. Basic configuration like file location and uid/gid
          is added automatically to the beginning of the file. For available
          options see <literal>man 5 mpd.conf</literal>'.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/${name}";
        description = ''
          The directory where MPD stores its state, tag cache, playlists etc. If
          left as the default value this directory will automatically be created
          before the MPD server starts, otherwise the sysadmin is responsible for
          ensuring the directory exists with appropriate ownership and permissions.
        '';
      };

      user = mkOption {
        type = types.str;
        default = name;
        description = "User account under which MPD runs.";
      };

      group = mkOption {
        type = types.str;
        default = name;
        description = "Group account under which MPD runs.";
      };

      network = {

        listenAddress = mkOption {
          type = types.str;
          default = "127.0.0.1";
          example = "any";
          description = ''
            The address for the daemon to listen on.
            Use <literal>any</literal> to listen on all addresses.
          '';
        };

        port = mkOption {
          type = types.int;
          default = 6600;
          description = ''
            This setting is the TCP port that is desired for the daemon to get assigned
            to.
          '';
        };

      };

      dbFile = mkOption {
        type = types.nullOr types.str;
        default = "${cfg.dataDir}/tag_cache";
        defaultText = "\${dataDir}/tag_cache";
        description = ''
          The path to MPD's database. If set to <literal>null</literal> the
          parameter is omitted from the configuration.
        '';
      };

      credentials = mkOption {
        type = types.listOf (types.submodule {
          options = {
            passwordFile = mkOption {
              type = types.path;
              description = ''
                Path to file containing the password.
              '';
            };
            permissions = let
              perms = ["read" "add" "control" "admin"];
            in mkOption {
              type = types.listOf (types.enum perms);
              default = [ "read" ];
              description = ''
                List of permissions that are granted with this password.
                Permissions can be "${concatStringsSep "\", \"" perms}".
              '';
            };
          };
        });
        description = ''
          Credentials and permissions for accessing the mpd server.
        '';
        default = [];
        example = [
          {passwordFile = "/var/lib/secrets/mpd_readonly_password"; permissions = [ "read" ];}
          {passwordFile = "/var/lib/secrets/mpd_admin_password"; permissions = ["read" "add" "control" "admin"];}
        ];
      };

      fluidsynth = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If set, add fluidsynth soundfont and configure the plugin.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.sockets.mpd = mkIf cfg.startWhenNeeded {
      description = "Music Player Daemon Socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [
        (if pkgs.lib.hasPrefix "/" cfg.network.listenAddress
          then cfg.network.listenAddress
          else "${optionalString (cfg.network.listenAddress != "any") "${cfg.network.listenAddress}:"}${toString cfg.network.port}")
      ];
      socketConfig = {
        Backlog = 5;
        KeepAlive = true;
        PassCredentials = true;
      };
    };

    systemd.services.mpd = {
      after = [ "network.target" "sound.target" ];
      description = "Music Player Daemon";
      wantedBy = optional (!cfg.startWhenNeeded) "multi-user.target";

      serviceConfig = mkMerge [
        {
          User = "${cfg.user}";
          ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon /run/mpd/mpd.conf";
          ExecStartPre = pkgs.writeShellScript "mpd-start-pre" ''
            set -euo pipefail
            install -m 600 ${mpdConf} /run/mpd/mpd.conf
            ${optionalString (cfg.credentials != [])
            "${pkgs.replace}/bin/replace-literal -fe ${
              concatStringsSep " -a " (imap0 (i: c: "\"{{password-${toString i}}}\" \"$(cat ${c.passwordFile})\"") cfg.credentials)
            } /run/mpd/mpd.conf"}
          '';
          RuntimeDirectory = "mpd";
          Type = "notify";
          LimitRTPRIO = 50;
          LimitRTTIME = "infinity";
          ProtectSystem = true;
          NoNewPrivileges = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
          RestrictNamespaces = true;
          Restart = "always";
        }
        (mkIf (cfg.dataDir == "/var/lib/${name}") {
          StateDirectory = [ name ];
        })
        (mkIf (cfg.playlistDirectory == "/var/lib/${name}/playlists") {
          StateDirectory = [ name "${name}/playlists" ];
        })
        (mkIf (cfg.musicDirectory == "/var/lib/${name}/music") {
          StateDirectory = [ name "${name}/music" ];
        })
      ];
    };

    users.users = optionalAttrs (cfg.user == name) {
      ${name} = {
        inherit uid;
        group = cfg.group;
        extraGroups = [ "audio" ];
        description = "Music Player Daemon user";
        home = "${cfg.dataDir}";
      };
    };

    users.groups = optionalAttrs (cfg.group == name) {
      ${name}.gid = gid;
    };
  };

}
