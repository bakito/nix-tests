{ config, pkgs, ... }:

let
  # Script to load secrets from KeePass
  loadSecrets = pkgs.writeShellScriptBin "loadSecrets" ''
    # Replace with the path to your database, entry, and optional key file
    export MY_SECRET=$(keepassxc-cli show -q -a password /path/to/your/database.kdbx entry/path --key-file /path/to/keyfile)
  '';
  sessionVariables = {
    EDITOR = "nano";
    MY_SECRET = "${loadSecrets}/bin/loadSecrets";
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "bakito";
  home.homeDirectory = "/home/bakito";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    nano
    starship
    nixfmt-rfc-style
    keepassxc
    loadSecrets
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/bakito/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = sessionVariables;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . $HOME/.nix-profile/etc/profile.d/nix.sh
      . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

      eval "$(starship init bash)"

      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'
    '';
    sessionVariables = sessionVariables;
    shellAliases = {
      grep = "grep --color=auto";
      k = "kubectl";
      l = "ls -CF";
      la = "ls -A";
      ll = "ls -alFh";
      ls = "ls --color=auto";
    };
  };

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      # add_newline = false;

      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };

      # package.disabled = true;
    };
  };

  # for mint cinnamon
  # https://github.com/nix-community/home-manager/issues/5102
  # xdg.mime.enable = false;
}