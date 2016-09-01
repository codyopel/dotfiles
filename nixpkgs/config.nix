pkgs: {
  allowUnfree = true;
  cabal.libraryProfiling = true;
  # Suckless
  st.conf = (builtins.readFile ./st/config.mach.h)
    + (builtins.readFile ./st/config.inc.h);

  packageOverrides = self: rec {

    chromium = self.chromium.override {
      proprietaryCodecs = true;
      enableWideVine = true;
      enablePepperFlash = true;
    };
    #emacs = self.emacs.override {
    #  withX = false;
    #};
    pulseaudio_full = self.pulseaudio_full.override {
      loopbackLatencyMsec = "20";
      resampleMethod = "speex-float-7";
    };
    rtorrent = self.rtorrent.override {
      colorSupport = true;
    };
    #x264 = self.x264.override {
    #  enable10bit = true;
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
          brotli
          curl
          dash
          dmidecode
          dnstop
          git
          gptfdisk
          #hdparm
          htop
          iftop
          iotop
          iperf
          ipset
          iptables
          jq
          lib-bash
          lm-sensors
          meslo-lg
          mg
          mtr
          nftables
          nmap
          openssh
          openssl
          p7zip
          psmisc
          screen
          smartmontools
          speedtest-cli
          sysstat
          tcpdump
          tmux
          unrar
          unzip
          vim
          wget
          xz
          zsh

        # Headless
          #goPackages.hugo.bin
          #goPackages.ipfs.bin
          goPackages.lego.bin
          goPackages.nomad.bin
          #goPackages.syncthing.bin
          goPackages.vault.bin
          python2Packages.bazaar
          python3Packages.beets
          #python2Packages.certbot
          python2Packages.deluge
          python3Packages.flexget
          python3Packages.pycountry
          #python2Packages.youtube-dl
          python3Packages.python
          python3Packages.youtube-dl
          arkive
          atom
          btsync
          cdrtools
          ffmpeg_head
          flac
          gnupg
          pinentry
          go
          #icedtea8_web
          imagemagick
          lame
          #libpng
          #libvpx
          mediainfo
          mosh
          mpd
          #mpdris2
          ncdc
          #ncdu
          ncmpcpp
          networkmanager
          #nix-repl
          #nixops
          #notbit
          pcsc-lite_full
          perl
          pinentry
          psmisc
          pulseaudio_full
          rtorrent
          #rustc
          scrot
          slock
          subversion
          #vobsub2srt
          x264
          x265
          #xlibs.xbacklight

        # Graphical
          chromium
          dmenu
          #eagle
          eog
          file-roller
          firefox
          #gimp
          #gnome-calculator
          gnome-mpv
          gnome-screenshot
          gnome-terminal
          #gnome-tweak-tool
          #guitarix
          #jack2_full
          #kde5.kate
          lftp
          #libreoffice
          #mixxx
          #mkvtoolnix
          mpv
          mumble
          nautilus
          networkmanager
          networkmanager-applet
          nvidia-settings
          pavucontrol
          #kde5.quasselClient
          #qjackctl
          sakura
          split2flac
          sublime-text
          swig
          #teamspeak_client
          #texLive
          #texstudio
          ufraw
          #virtmanager
          #vlc
          #xfe

          #myHsEnv

          #steamEnv
      ];
    };

    myHsEnv = self.haskellPackages.ghcWithPackages (self : with self; [
      #pandoc
      xmonad
      xmonad-contrib
    ]);

    steamEnv = self.buildEnv {
      name = "steam-env";
      ignoreCollisions = true;
      paths = with self; [
        steam
      ];
    };
  };
}
