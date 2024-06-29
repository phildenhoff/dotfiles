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
    zoxide
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

  programs.fish.enable = true;
}
