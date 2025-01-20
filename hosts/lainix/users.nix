{ pkgs, username, ... }:

let inherit (import ./variables.nix) gitUsername;
in {
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups =
        [ "networkmanager" "wheel" "libvirtd" "scanner" "lp" "video" "audio" ];
      # shell = pkgs.fish;
      shell = pkgs.bash;
      ignoreShellProgramCheck = true;
      packages = with pkgs; [ btop ];
    };
  # VM tests user
  users.users.nixosvmtest.isSystemUser = true ;
  users.users.nixosvmtest.initialPassword = "test";
  users.users.nixosvmtest.group = "nixosvmtest";
  users.groups.nixosvmtest = {};
    # "newuser" = {
    #   homeMode = "755";
    #   isNormalUser = true;
    #   description = "New user account";
    #   extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    #   shell = pkgs.bash;
    #   ignoreShellProgramCheck = true;
    #   packages = with pkgs; [];
    # };
  };
}
