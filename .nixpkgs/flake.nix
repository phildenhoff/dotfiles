{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {

      nixpkgs.config.allowUnfree = true;

      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
      ];

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [
          # Apps
          aerospace
          pika
          ice-bar
          wezterm

          # Tools
          _1password-cli
          atuin
          bat
          delta
          difftastic
          entr
          eza
          fd
          fish
          fnm
          fzf
          gh
          git
          git-lfs
          jankyborders
          jq
          ripgrep
          sd
          starship
          tokei
          unzip
          uv
          viddy
          zip
          zellij
          zoxide

          # Editors & plugins
          vim
          neovim
          helix

          # Work
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      system.primaryUser = "phildenhoff";
      system.defaults = {
        loginwindow.LoginwindowText = "phil@digits.com | 250 327 7468";
        NSGlobalDomain = {
          # Disable holding keyboard keys to access diacritics
          ApplePressAndHoldEnabled = false;
        };
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."press" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
