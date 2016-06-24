pkgs : {
  allowUnfree = true;
  cabal.libraryProfiling = true;
  # Suckless
  st.conf = (builtins.readFile ./st/config.mach.h)
    + (builtins.readFile ./st/config.inc.h);

  packageOverrides = self: rec {

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
    pulseaudio_full = self.pulseaudio_full.override {
      loopbackLatencyMsec = "20";
      resampleMethod = "speex-float-10";
    };
    rtorrent = self.rtorrent.override {
      colorSupport = true;
    };
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
          lm-sensors
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
          pythonPackages.beets
          ffmpeg
          flac
          #gnupg1compat
          go
          #icedtea7_web
          imagemagick
          lame
          libpng
          libvpx
          #mediainfo
          mosh
          mpd
          #mpdris2
          ncdc
          ncdu
          ncmpcpp
          networkmanager
          #nix-repl
          #nixops
          #notbit
          p7zip
          pcsclite
          perl
          pinentry
          psmisc
          pulseaudio_full
          rtorrent
          rustc
          scrot
          #speedtest-cli
          subversion
          unzip
          #vobsub2srt
          x264
          x265
          #xlibs.xbacklight
          xz
          pythonPackages.youtube-dl

        # Graphical
          atom
          chromium
          dmenu
          #eagle
          eog
          file-roller
          #filezilla
          #firefoxWrapper
          gimp
          gnome-calculator
	        gnome-mpv
          gnome-screenshot
          gnome-terminal
          #gnome-tweak-tool
          #guitarix
          jack2_full
          #kde5.kate
          #libreoffice
          #mixxx
          #mkvtoolnix
          mpv
          mumble
          nautilus
          networkmanager
          networkmanager-applet
          noise
          pavucontrol
          #kde5.quasselClient
          qbittorrent
          #qjackctl
          sakura
          sublime-text
          #teamspeak_client
          #texLive
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
