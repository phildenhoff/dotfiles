{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  workPackages = with pkgs; [
    pipx
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
    bottom
    bun
    chezmoi
    delta
    unstable.deno
    difftastic
    doppler
    du-dust
    eternal-terminal
    exa
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
    sptlrx
    starship
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
in {
  environment.systemPackages = with pkgs; [] ++ workPackages ++ personalPackages;

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

  documentation.enable = false;
  documentation.doc.enable = false;
}
