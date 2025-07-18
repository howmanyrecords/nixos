# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	<home-manager/nixos>
	#inputs.illogical-impulse.homeManagerModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.enableIPv6 = false;
  boot.kernelParams = ["ipv6.disable=1"];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ############
  ###NVIDIA###
  ############
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.;
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


  ##############
  #HOME MANAGER#
  ##############






  #enable fish
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  #enable kde connect
  programs.kdeconnect.enable = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  #enable flatpak
  services.flatpak.enable = true;

  #enable tailscale and tailscaled
  services.tailscale.enable = true;

  #enable sunshine
 services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;

  };

  networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 47984 47989 47990 48010 ];
  allowedUDPPortRanges = [
    { from = 47998; to = 4800; }
    { from = 8000; to = 8010; }
  ];
};

  #enable espanso
  #services.espanso.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  #Enable the Hyprland window manager
 # programs.hyprland.enable = true;
 # wayland.windowManager.hyprland = {
#	enable = true;
#	package = null;
#	portalPackage = null;
#	};



  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
  };
 #The 1 containerization software for developers and teams
  # Configure console keymap
  console.keyMap = "dvorak";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #enable bluetooth for wireless connection
  hardware.bluetooth.enable = true; #enables support for bluetooth
  hardware.bluetooth.powerOnBoot = true; #powers up deafault bluetooth controller on boot


  virtualisation.waydroid.enable = true;
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
  users.users.leland = {
    isNormalUser = true;
    description = "leland";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      flatpak
      kdePackages.kate
    #  thunderbird
    ];
  };
#  home-manager.backupFileExtension = backup;
  programs.hyprland.enable = true;
  users.users.hyprleland = {
	isNormalUser = true;
	extraGroups = [ "wheel" ];
	};
  home-manager.users.hyprleland = { pkgs, ...}:  {
	wayland.windowManager.hyprland = {
		enable = true;
		extraConfig = ''

		
		
#monitors
monitor=,preferred,auto,auto

#programs
$terminal = kitty
$fileManager = dolphin
$menu = wofi --show drun

#autostart

# exec-once = $terminal
# exec-once = nm-applet &
# exec-once = waybar & hyprpaper & firefox
exec-once = swww-daemon
exec-once = swww img ~/Downloads/shiprender.jpg -t grow --transition-fps 60 --transition-pos bottom-right

#env vars

	
# See https://wiki.hyprland.org/Configuring/Environment-variables/

env = XCURSOR_SIZE,24
env = HYPRCURSOR_SIZE,24


#look and feel
	
# Refer to https://wiki.hyprland.org/Configuring/Variables/

# https://wiki.hyprland.org/Configuring/Variables/#general
general {
    gaps_in = 5
    gaps_out = 20

    border_size = 2

    # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
    col.active_border = rgba(2e3440ee) rgba(4c566aee) 45deg
    col.inactive_border = rgba(434c5eaa)

    # Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false

    layout = dwindle
}

# https://wiki.hyprland.org/Configuring/Variables/#decoration
decoration {
    rounding = 10

    # Change transparency of focused and unfocused windows
    active_opacity = 1.0
    inactive_opacity = 1.0

    shadow {
        enabled = true
        range = 4
        render_power = 3
        color = rgba(1a1a1aee)
    }

    # https://wiki.hyprland.org/Configuring/Variables/#blur
    blur {
        enabled = true
        size = 3
        passes = 1

        vibrancy = 0.1696
    }
}




#animation
# name "Dynamic"
# credit https://github.com/mylinuxforwork/dotfiles

animations {
    enabled = true
    bezier = wind, 0.05, 0.9, 0.1, 1.05
    bezier = winIn, 0.1, 1.1, 0.1, 1.1
    bezier = winOut, 0.3, -0.3, 0, 1
    bezier = liner, 1, 1, 1, 1
    animation = windows, 1, 6, wind, slide
    animation = windowsIn, 1, 6, winIn, slide
    animation = windowsOut, 1, 5, winOut, slide
    animation = windowsMove, 1, 5, wind, slide
    animation = border, 1, 1, liner
    animation = borderangle, 1, 30, liner, once
    animation = fade, 1, 10, default
    animation = workspaces, 1, 5, wind
}




# Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
# "Smart gaps" / "No gaps when only"
# uncomment all if you wish to use that.
# workspace = w[tv1], gapsout:0, gapsin:0
# workspace = f[1], gapsout:0, gapsin:0
# windowrulev2 = bordersize 0, floating:0, onworkspace:w[tv1]
# windowrulev2 = rounding 0, floating:0, onworkspace:w[tv1]
# windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
# windowrulev2 = rounding 0, floating:0, onworkspace:f[1]

# See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
dwindle {
    pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = true # You probably want this
}

# See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
master {
    new_status = master
}

# https://wiki.hyprland.org/Configuring/Variables/#misc
misc {
    force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
}


#input

# https://wiki.hyprland.org/Configuring/Variables/#input
input {
    kb_layout = us
    kb_variant = dvorak 
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

    touchpad {
        natural_scroll = false
    }
}

# https://wiki.hyprland.org/Configuring/Variables/#gestures
gestures {
    workspace_swipe = false
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
device {
    name = epic-mouse-v1
    sensitivity = -0.5
}

#keybinds
$mainMod = SUPER

bind = $mainMod, T, exec, $terminal
bind = $mainMod, Q, killactive,
bind = $mainMod, delete, exit,
bind = $mainMod, E, exec, $fileManager
bind = $mainMod, V, togglefloating,
bind = $mainMod, N, exec, $menu
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle

# Move focus with mainMod + arrow keys
bind = $mainMod, L, movefocus, l
bind = $mainMod, H, movefocus, r
bind = $mainMod, K, movefocus, u
bind = $mainMod, U, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Move active window to a workspace silently with mainMod + Alt + [0-9]
bind = $mainMod Alt, 1, movetoworkspacesilent, 1
bind = $mainMod Alt, 2, movetoworkspacesilent, 2
bind = $mainMod Alt, 3, movetoworkspacesilent, 3
bind = $mainMod Alt, 4, movetoworkspacesilent, 4
bind = $mainMod Alt, 5, movetoworkspacesilent, 5
bind = $mainMod Alt, 6, movetoworkspacesilent, 6
bind = $mainMod Alt, 7, movetoworkspacesilent, 7
bind = $mainMod Alt, 8, movetoworkspacesilent, 8
bind = $mainMod Alt, 9, movetoworkspacesilent, 9
bind = $mainMod Alt, 0, movetoworkspacesilent, 0

# Move active window around current workspace with mainMod + Shift + Control [←→↑↓]
$d=[$wm|Move active window across workspace]
$moveactivewindow=grep -q "true" <<< $(hyprctl activewindow -j | jq -r .floating) && hyprctl dispatch moveactive
bindde = $mainMod Shift Control, left, Move active window to the left, exec, $moveactivewindow -30 0 || hyprctl dispatch movewindow l
bindde = $mainMod Shift Control, right, Move active window to the right, exec, $moveactivewindow 30 0 || hyprctl dispatch movewindow r
bindde = $mainMod Shift Control, up, Move active window up, exec, $moveactivewindow  0 -30 || hyprctl dispatch movewindow u
bindde = $mainMod Shift Control, down, Move active window down, exec, $moveactivewindow 0 30 || hyprctl dispatch movewindow d


# Example special workspace (scratchpad)
bind = $mainMod, S, togglespecialworkspace, magic
bind = $mainMod SHIFT, S, movetoworkspace, special:magic

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Laptop multimedia keys for volume and LCD brightness
bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-

# Requires playerctl
bindl = , XF86AudioNext, exec, playerctl next
bindl = , XF86AudioPause, exec, playerctl play-pause
bindl = , XF86AudioPlay, exec, playerctl play-pause
bindl = , XF86AudioPrev, exec, playerctl previous


#windowrules
# Example windowrule v1
# windowrule = float, ^(kitty)$

# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

# Ignore maximize requests from apps. You'll probably like this.
windowrulev2 = suppressevent maximize, class:.*

# Fix some dragging issues with XWayland
windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0

	
	'';
	}; 

	home.packages = [
	pkgs.wofi
	pkgs.vim
	pkgs.blueman
	pkgs.hyprpicker
	pkgs.hypridle
	pkgs.hyprlock
	pkgs.kitty
	pkgs.swww	
	pkgs.hyprsunset	];
#	programs.fish.enable = true;
	home.stateVersion = "24.11"; 
  

  programs.git = {
	enable = true;
	userName = "howmanyrecords";
	userEmail = "howmanyrecords@proton.me";
	};
  programs.kitty = lib.mkForce { 
	enable = true;
	settings = {
		confirm_os_window_close = 0;
		dynamic_backgraund_opacity = true;
		enable_audio_bell = false;
		background_opacity = "0.5";
		background_blur = 5;
	};
   };
};
#  wayland.windowManager.hyprland.enable = true;
#  wayland.windowManager.hyprland.settings = {

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
	[

     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     fish
     vesktop
     bitwarden
     kitty
     youtube-music
     tailscale
     localsend
     starship
     whatsapp-for-linux
     gimp
     fastfetch
     espanso-wayland
     btop
     fzf
     finamp
     jellyfin
     picard
     prismlauncher
     ventoy
     chromium
     zapzap
     eza
     ttyper
     itch
     davinci-resolve
     sl
     dvdbackup
     #makemkv - "this software is too old" error, you have to use flatpak
     handbrake
     cava
     firefox
     obs-studio
     asciiquarium-transparent
     gimp-with-plugins
     gnome-software
     gnumake
     ffmpeg
     arduino-ide
     freetube
     libation
     #ladybird
     vlc
     joplin-desktop
     upscayl
     signal-desktop
     toilet
     nmap
     dig
     rpi-imager
     signal-desktop
     winetricks
     wine
     garmintools
     hyprlock
     playerctl
     themechanger
     waydroid
     blueman
     immich-cli


  ];

 # system.autoUpgrade.enable = true;
 # system.autoUpgrade.allowReboot = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
