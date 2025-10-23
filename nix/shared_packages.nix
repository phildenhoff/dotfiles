{ config, pkgs, ... }:
let
  unstable = import <nixpkgs> { config = { allowUnfree = true; }; };
  nixpkgsdarwin = import <nixpkgs-24.11-darwin> {};
  # Override jujutsu to skip tests and remove cargo-nextest, avoiding broken dependency on macOS
  jujutsuNoTests = pkgs.jujutsu.overrideAttrs (old: {
    doCheck = false;
    doInstallCheck = false;
    nativeBuildInputs = builtins.filter
      (pkg: !(builtins.match ".*cargo-nextest.*" (pkg.name or "") != null))
      (old.nativeBuildInputs or []);
  });
  workPackages = with pkgs; [
    alacritty
    colima
    docker
    postgresql_16
  ];
  personalPackages = with pkgs; [
    # Utilities
    bat
    dogdns
    entr
    fd
    fnm
    fzf
    git
    git-lfs
    gnupg
    jankyborders
    jq
    ripgrep
    sd
    tokei
    unzip
    zip
    zlib # Dec 30, 2024 Moved from Brew, no idea if I need it
    zoxide
    # Tools
    _1password-cli # Dec 30, 2024 Moved from Brew
    atuin
    bottom
    bun
    chezmoi
    curl
    delta
    dua
    unstable.deno
    difftastic
    dust
    eternal-terminal
    eza
    ffmpeg
    fish
    gh
    htop
    httpie
    hyperfine
    imagemagick
    jujutsuNoTests
    mosh
    mprocs
    neofetch
    nnn
    podman
    restic
    rustic
    sptlrx
    sqldiff
    starship
    stow
    tealdeer
    tmux
    topgrade
    uv # Python version & dependency mgmt tool
    watchman
    wakatime-cli
    unstable.wezterm
    wget
    viddy # Replaces `watch`, with auto-recorded history
    xh
    yt-dlp # Replaced youtube-dl, to download vids from YouTube
    zellij # Terminal Multiplexer. Replaces `screen` and `tmux`.
    # Editors & plugins
    efm-langserver # Dec 30, 2024 Moved from Brew, although I'm not sure what it's for
    kakoune-lsp
    kakoune
    neovim
    unstable.helix
    # Gaming
    # zulu11 # OpenJDK 11, which cannot be installed because it conflicts with the Modern JDK install
    zulu # Latest OpenJDK
  ];
  educationPkgs = with pkgs; [
    # Gleam
    erlang
    exercism
    gleam
    rebar3
  ];
  testingPkgs = with pkgs; [
    sapling
  ];
  uiPkgs = with pkgs; [
    alt-tab-macos
    meld
  ];
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [] ++ workPackages ++ personalPackages ++ educationPkgs ++ testingPkgs ++ uiPkgs;

  programs.fish.enable = true;
}
