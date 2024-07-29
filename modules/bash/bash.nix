{ config, pkgs, lib, ...}:

{

programs.bash = {
  enable = true;
  profileExtra = ''
    export TZ=Europe/Warsaw
  '';
  bashrcExtra = ''
    eval "$(zoxide init bash)"
  '';
};

}
