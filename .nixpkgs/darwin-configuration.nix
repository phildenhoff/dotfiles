{ config, pkgs, ... }:
{
  imports = [
    /Users/phil/.config/_dotfiles/nix/shared_packages.nix
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  nix.package = pkgs.nix;

  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  system.defaults = {
    finder.FXPreferredViewStyle = "icnv";
    loginwindow.LoginwindowText = "phil@denhoff.ca | 250 327 7468";
    menuExtraClock.Show24Hour = true;
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
    };
  };
  ids.gids.nixbld = 350;
  networking.hosts = {
    "192.168.2.1" = [ "unifi.local" "paradise.local" ];
    "40.233.86.119" = [ "opc.internal.denhoff.ca" ];
  };

  documentation.enable = false;
  documentation.doc.enable = false;
  documentation.man.enable = false;

  # security.pam.enableSudoTouchIdAuth = true;
  security.pam.services.sudo_local.touchIdAuth = true;
}
