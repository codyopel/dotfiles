pkgs : {
  allowUnfree = true;
  cabal.libraryProfiling = true;
  firefox = {
    jre = false;
    enableAdobeFlash = true;
    enableGoogleTalkPlugin = true;
    icedtea = true;
  };
  chromium = {
    enablePepperFlash = true;
  #  enableWideVine = true;
    proprietaryCodecs = true;
  };
  # Suckless
  st.conf = (builtins.readFile ./st/config.mach.h)
    + (builtins.readFile ./st/config.inc.h);

  packageOverrides = self : rec {

    chromium = self.chromium.override {
      proprietaryCodecs = true;
      pulseSupport = true;
      enableWideVine = true;
      enablePepperFlash = true;
    };
    #emacs = self.emacs.override {
    #  withX = false;
    #};
    /*ffmpeg-full = self.ffmpeg-full.override {
      nonfreeLicensing = true;
      gnutls = null;
      opensslExtlib = true;
      #decklinkExtlib = true;
      fdkaacExtlib = true;
      openglExtlib = true;
    };*/
    #rtorrent = self.rtorrent.override {
    #  colorSupport = true;
    #};
    #desktop = self.haskellPackages.ghcWithPackages (self : with self; [
    #  haskell-ngPackages.xdgBasedir
     # xmonad
      #yi
    #]);

    # Import Environments
    user-env = self.buildEnv {
      name = "userEnv";
      paths = with self; [
        # Default
          acpi
          atop
          bc
          dash
          dnstop
          emacs
          git
          gptfdisk
          #hdparm
          htop
          iftop
          iotop
          iperf
          ipset
          iptables
          lm_sensors
          meslo-lg
          mtr
          nftables
          nmap
          openssh
          openssl
          psmisc
          smartmontools
          sysstat
          tcpdump
          tmux
          vim
          wget
          zsh

        # Headless
          beets
          ffmpeg-full
          flac
          #gnupg1compat
          go
          #icedtea7_web
          imagemagick
          lame
          libpng
          libvpx
          mediainfo
          mkvtoolnix-cli
          mosh
          most
          mpd
          mpdris2
          ncdc
          ncdu
          ncmpcpp
          networkmanager
          #nix-repl
          #nixops
          #notbit
          p7zip
          pcsclite
          pinentry
          psmisc
          pulseaudioFull
          rtorrent
          scrot
          speedtest_cli
          subversion
          unzip
          vobsub2srt
          x264
          x265
          #xlibs.xbacklight
          xz
          youtube-dl

        # Graphical
          atom
          chromium
          dmenu
          #eagle
          filezilla
          firefoxWrapper
          gimp
	        #gnome-mpv
          #guitarix
          jack2Full
          #kde5.kate
          #libreoffice
          mixxx
          mkvtoolnix-cli
          mpv
          mumble_git
          networkmanager
          networkmanagerapplet
          pavucontrol
          kde5.quasselClient
          #qbittorrent
          qjackctl
          sakura
          sublime-text
          teamspeak_client
          texLive
          #texstudio
          #virtmanager
          vlc
          #xfe

          #steamEnv
      ];
    };

    steamEnv = self.buildEnv {
      name = "steam-env";
      ignoreCollisions = true;
      paths = with self; [
          steam
      ];
    };
  };
}
