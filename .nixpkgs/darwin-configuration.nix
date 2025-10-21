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
  system.primaryUser = "phil";
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
  # Disabled Mar 21, 2025, this was removed from nix-darwin
  # https://github.com/LnL7/nix-darwin/issues/1035
  #networking.hosts = {
  #  "192.168.2.1" = [ "unifi.local" "paradise.local" ];
  #  "40.233.86.119" = [ "opc.internal.denhoff.ca" ];
  #};

  documentation.enable = false;
  documentation.doc.enable = false;
  documentation.man.enable = false;

  # security.pam.enableSudoTouchIdAuth = true;
  # Disabled Mar 21, 2025 This is not a config option anymore. Was it renamed...?
  # security.pam.services.sudo_local.touchIdAuth = true;
}
