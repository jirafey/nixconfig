{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.keyd;
in
{
  options = {
    services.keyd = {
      enable = mkEnableOption "enable keyd - key remapper daemon";
      config = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Content of config file
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.keyd = {
      description = "key remapping daemon";
      wantedBy = [ "sysinit.target" ];
      requires = [ "local-fs.target" ];
      after = [ "local-fs.target" ];
      environment.KEYD_CONFIG_DIR = pkgs.writeTextDir "keymap.conf" cfg.config;
      serviceConfig.ExecStart = "${pkgs.keyd}/bin/keyd";
    };
  };
}
