# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # configure home-manager
  home-manager.users.oleg = { pkgs, ... }: {
    home.packages = [ 
      pkgs.kitty 
      pkgs.htop
      pkgs.git
      pkgs.gh
      pkgs.gnome-secrets
    ];
    
    # git
    programs.git = {
      enable = true;
      userName  = "GachiLord";
      userEmail = "name504172@gmail.com";
    };

    # kitty
    programs.kitty = {
      enable = true;
      theme = "Later This Evening";
      shellIntegration.enableZshIntegration = true;
      extraConfig = ''
        enable_audio_bell no
        confirm_os_window_close 0
        paste_actions quote-urls-at-prompt
        map ctrl+shift+n new_os_window_with_cwd
      '';
    };
    
    # neovim
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";
  };

  # use systemd-boot
  boot.loader.systemd-boot.enable = true;
  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "nodev"; 

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Yekaterinburg";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;	  
    configFile = "/etc/nixos/dotfiles/i3-config";
  };
  services.xserver.displayManager.sddm.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Configure keymap in X11
  services.xserver.displayManager.sddm.autoNumlock = true;
  services.xserver = {
    layout = "us,ru";
    xkbOptions = "grp:win_space_toggle,caps:capslock";
  };
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.oleg = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # firefox
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" ];

    /* ---- POLICIES ---- */
    # Check about:policies#documentation for options.
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value= true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      DisplayBookmarksToolbar = "always"; # alternatives: "always" or "newtab"

      /* ---- EXTENSIONS ---- */
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
        };
        "simple-translate@sienori" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/simple-translate/latest.xpi";
          installation_mode = "normal_installed";
        };
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "normal_installed";
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
  
      /* ---- PREFERENCES ---- */
      # Check about:config for options.
      Preferences = { 
        "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
        "extensions.pocket.enabled" = "lock-false";
        "extensions.screenshots.disabled" = "lock-true";
        "browser.topsites.contile.enabled" = "lock-false";
        "browser.formfill.enable" = "lock-false";
        "browser.search.suggest.enabled" = "lock-false";
        "browser.search.suggest.enabled.private" = "lock-false";
        "browser.urlbar.suggest.searches" = "lock-false";
        "browser.urlbar.showSearchSuggestionsFirst" = "lock-false";
        "browser.newtabpage.activity-stream.feeds.section.topstories" = "lock-false";
        "browser.newtabpage.activity-stream.feeds.snippets" = "lock-false";
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = "lock-false";
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = "lock-false";
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = "lock-false";
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = "lock-false";
        "browser.newtabpage.activity-stream.showSponsored" = "lock-false";
        "browser.newtabpage.activity-stream.system.showSponsored" = "lock-false";
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = "lock-false";
      };
    };
  };

  # nix settings
  nix.settings.allowed-users = ["*"];

  # set default shell
  users.defaultUserShell = pkgs.zsh;
  # zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellInit = ''
      f() {
        fff "$@"
        cd "$(cat "''${XDG_CACHE_HOME:=''${HOME}/.cache}/fff/.fff_d")"
      }
      
      eval "$(zoxide init zsh --cmd cd)"
    '';
  
    shellAliases = {
      n = "nvim";
      t = "tmux new -A";
      update = "sudo nixos-rebuild switch";
    };

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "rust" "npm" ];
      theme = "robbyrussell";
    };
  };

  # tmux
  programs.tmux = {
    escapeTime = 20;
    enable = true;
    clock24 = true;
    extraConfig = '' # used for less common options, intelligently combines if defined in multiple places.
      set -g status-bg brightblue
      set-option -g default-shell ${pkgs.zsh}/bin/zsh
      set-window-option -g mode-keys vi
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
  };
  
  environment.systemPackages = with pkgs; [
    wget
    bat
    xclip
    htop
    nodejs
    python3
    cargo
    rustc
    go
    gcc    
    fff
    fzf
    zoxide
    git
    neovim
    gh
    ((vim_configurable.override {  }).customize{
      name = "vim";
      # Install plugins for example for syntax highlighting of nix files
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix vim-lastplace ];
        opt = [];
      };
      vimrcConfig.customRC = ''
        " your custom vimrc
        set smartindent
        syntax on
        " ...
      '';
    }
    )
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

