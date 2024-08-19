# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Nix Flakes Enabled
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  # Not sure if this is doing anything useful.
  services.xserver.displayManager.setupCommands = ''
    # workaround for using NVIDIA Optimus without Bumblebee
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto
  '';

  #services.displayManager.defaultSession = "plasma"; #Plasmoid
  #services.displayManager.sddm.wayland.compositor = "weston"; #"kwin"; kwin seems to be defined in plasm6
  services.displayManager.sddm.autoNumlock = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enablee Bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hoid = {
    isNormalUser = true;
    description = "Ayman Jundi";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  environment.sessionVariables = {
    EDITOR = "codium --wait";
    SUDO_EDITOR = "kate";
  };

  #   """Constant Values""" constants.py of protonup
  # import os
  # CONFIG_FILE = os.path.expanduser('~/.config/protonup/config.ini')
  # DEFAULT_INSTALL_DIR = os.path.expanduser('~/.steam/root/compatibilitytools.d/')
  # TEMP_DIR = '/tmp/protonup/'
  # PROTONGE_URL = 'https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases'
  # BUFFER_SIZE = 65536  # Work with 64 kb chunks

  systemd.tmpfiles.rules = [
    # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html
    "d /home/shared/Steam/ 1777 hoid users -"
    "d /home/shared/Steam/steamapps/common/ 1777 hoid users -"
    "d /home/shared/Steam/package/ 1777 hoid users -"
    "d /home/shared/Steam/ubuntu12_32/ 1777 hoid users -"
    "d /home/shared/Steam/ubuntu12_64/ 1777 hoid users -"
  ];

  # https://unix.stackexchange.com/questions/619671/declaring-a-sym-link-in-a-users-home-directory
  # https://www.freecodecamp.org/news/linux-ln-how-to-create-a-symbolic-link-in-linux-example-bash-command/
  system.userActivationScripts.linktosharedfolder.text = ''
    if [[ ! -h "$HOME/.steam/root/" ]]; then
      mkdir $HOME/.steam
      ln -s "/home/shared/Steam/" "$HOME/.steam/root"
    fi

    if [[ ! -h "$HOME/.local/share/Steam/steamapps" ]]; then
      mkdir $HOME/.local/share/Steam
      ln -s "/home/shared/Steam/steamapps/" "$HOME/.local/share/Steam/steamapps"
    fi

    if [[ ! -h "$HOME/.local/share/Steam/package" ]]; then
      ln -s "/home/shared/Steam/package/" "$HOME/.local/share/Steam/package"
    fi

    if [[ ! -h "$HOME/.local/share/Steam/ubuntu12_32" ]]; then
      ln -s "/home/shared/Steam/ubuntu12_32/" "$HOME/.local/share/Steam/ubuntu12_32"
    fi

    if [[ ! -h "$HOME/.local/share/Steam/ubuntu12_64" ]]; then
      ln -s "/home/shared/Steam/ubuntu12_64/" "$HOME/.local/share/Steam/ubuntu12_64"
    fi
  '';

  # Enable automatic login for the user.
  #services.displayManager.autoLogin.enable = true;
  #services.displayManager.autoLogin.user = "hoid";

  # Install firefox.
  programs.firefox.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    brave
    gitFull
    kate
    vscodium
    lsd
    alejandra
    libnotify
    mangohud
    protonup
    lutris
    heroic
    sunshine
    moonlight-qt
    inxi
    pciutils
    zed-editor
    rustdesk
    kdePackages.sddm-kcm
  ];

  #options.programs.sunshine.enable = true;

  #sunshine
  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkgs.sunshine}/bin/sunshine";
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [47984 47989 47990 48010];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48000;
      }
      #{ from = 8000; to = 8010; }
    ];
  };
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;
  ##
  # Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  ##

  programs.bash.shellAliases = {
    # reference https://github.com/tolgaerok/nixos-kde/blob/main/core/programs/konsole/default.nix
    #---------------------------------------------------------------------
    # Nixos related
    #---------------------------------------------------------------------

    clean = "sudo nix-collect-garbage --delete-older-than";
    rebuild = "$HOME/nixos/rebuild.sh";
    testnix = "sudo nixos-rebuild test --flake $HOME/nixos#nixos";
    #---------------------------------------------------------------------
    # Navigate files and directories
    #---------------------------------------------------------------------

    CL = "source ~/.bashrc";
    cl = "clear && CL";
    cong = "echo && sysctl net.ipv4.tcp_congestion_control && echo";
    copy = "rsync -P";
    la = "lsd -a";
    ll = "lsd -l";
    ls = "lsd";
    lsla = "lsd -la";
    trim = "sudo fstrim -av";
    #---------------------------------------------------------------------
    # File access
    #---------------------------------------------------------------------
    cp = "cp -riv";
    mkdir = "mkdir -vp";
    mv = "mv -iv";

    #---------------------------------------------------------------------
    # Programs
    #---------------------------------------------------------------------
    code = "codium";
    fmtNix = "alejandra --quiet";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
