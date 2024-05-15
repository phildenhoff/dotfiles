{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  workPackages = with pkgs; [
    alacritty
    colima
    docker
    postgresql
  ];
  personalPackages = with pkgs; [
    # Utilities
    bat
    dogdns
    entr
    fd
    fnm
    fzf
    jq
    ripgrep
    sd
    # Tools
    atuin
    bottom
    bun
    chezmoi
    delta
    unstable.deno
    difftastic
    du-dust
    eternal-terminal
    eza
    fish
    gh
    htop
    httpie
    hyperfine
    imagemagick
    unstable.jujutsu
    mosh
    mprocs
    neofetch
    nnn
    podman
    restic
    rustic-rs
    sptlrx
    sqldiff
    starship
    stow
    tealdeer
    tmux
    topgrade
    wezterm
    zellij
    # Editors & plugins
    kak-lsp
    kakoune
    neovim
    unstable.helix
  ];
  educationPkgs = with pkgs; [
    # Gleam
    erlang
    exercism
    gleam
    rebar3
  ];
in {
  environment.systemPackages = with pkgs; [] ++ workPackages ++ personalPackages ++ educationPkgs;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
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

  documentation.enable = false;
  documentation.doc.enable = false;
  documentation.man.enable = false;

  security.pam.enableSudoTouchIdAuth = true;
}
