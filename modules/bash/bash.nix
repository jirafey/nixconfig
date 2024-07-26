{ config, pkgs, lib, ...}:

{

programs.bash = {
  enable = true;
  profileExtra = "export TZ=Europe/London";
};

}
