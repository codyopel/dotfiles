pkgs: {
  allowUnfree = true;
  cabal.libraryProfiling = true;
  # Suckless
  st.conf = (builtins.readFile ./st/config.mach.h)
    + (builtins.readFile ./st/config.inc.h);

  packageOverrides = self: rec {

    chromium = self.chromium.override {
      proprietaryCodecs = true;
      #enableWideVine = true;
      #enablePepperFlash = true;
    };
    #emacs = self.emacs.override {
    #  withX = false;
    #};
    pulseaudio_full = self.pulseaudio_full.override {
      loopbackLatencyMsec = "20";
      resampleMethod = "speex-float-5";
    };
    /*python36Packages = self.python36Packages // {
      oauthlib = self.python36Packages.oauthlib.override {
        doCheck = false;
      };
    };
    python3Packages = self.python3Packages.override rec {
      python = self.python36;
      self = self.python36Packages;
    };*/
    #rtorrent = self.rtorrent.override {
      #  colorSupport = true;
      #};
    #x264 = self.x264.override {
    #  enable10bit = true;
    #};
    #desktop = self.haskellPackages.ghcWithPackages (self : with self; [
    #  haskell-ngPackages.xdgBasedir
     # xmonad
      #yi
    #]);

    /*user-env = self.buildEnv {
      name = "userEnv";
      paths = with self; [

        # Headless
          #mosh
          #notbit
          #pinentry
          #psmisc
          #xlibs.xbacklight

        # Graphical
          #eagle
          #gnome-tweak-tool
          #kde5.kate
          #kde5.quasselClient
          #virtmanager
      ];
    };*/

    default-tools-env = self.buildEnv  {
      name = "defaultToolsEnv";
      paths = with self; [
        acpi
        atop
        bash
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
        mg
        mtr
        nftables
        nmap
        openssh
        openssl
        p7zip
        psmisc
        python3Packages.speedtest-cli
        screen
        smartmontools
        subversion
        sysstat
        tcpdump
        tmux
        unrar
        unzip
        vim
        wget
        xz
        zsh

        gnupg
        pcsc-lite_full
        pinentry
      ];
    };

    desktop-env = self.buildEnv {
      name = "desktopEnv";
      paths = with self; [
        dmenu
        eog
        evince
        file-roller
        gnome-calculator
        gnome-screenshot
        gnome-terminal
        mumble
        nautilus
        networkmanager
        networkmanager-applet
        nvidia-settings
        pavucontrol
        pulseaudio_full
        sakura
        scrot
        slock
        #teamspeak_client
        #xfe
      ];
    };

    development-env = self.buildEnv {
      name = "developmentEnv";
      paths = with self; [
        go
        #goPackages.hugo.bin
        #goPackages.ipfs.bin
        goPackages.lego.bin
        goPackages.mc.bin
        #goPackages.minio.bin
        goPackages.nomad.bin
        goPackages.vault.bin
        #icedtea8_web
        openjdk
        perl
        python3Packages.aws-cli
        python2Packages.bazaar
        #python2Packages.certbot
        python3Packages.python
        #rustc
        swig
        #texLive
        #texstudio
      ];
    };

    multimedia-env = self.buildEnv {
      name = "multimediaEnv";
      paths = with self; [
        gnome-mpv
        mpd
        #mpdris2
        mpv
        ncmpcpp
        #python2Packages.mopidy
        #vlc
      ];
    };

    multimedia-tools-env = self.buildEnv {
      name = "multimediaToolsEnv";
      paths = with self; [
        arkive
        imagemagick
        #gimp
        #guitarix
        #jack2_full
        lame
        #libpng
        libvpx_head
        python3Packages.beets
        python3Packages.pycountry
        cdrtools
        ffmpeg_head
        flac
        mediainfo
        #mixxx
        #mkvtoolnix
        split2flac
        #qjackctl
        ufraw
        #vobsub2srt
        x264
        x265
      ];
    };

    editor-env = self.buildEnv {
      name = "editorEnv";
      paths = with self; [
        atom
        #libreoffice
        sublime-text
      ];
    };

    p2p-env = self.buildEnv {
      name = "p2pEnv";
      paths = with self; [
        #goPackages.syncthing.bin
        lftp
        ncdc
        python2Packages.deluge
        python3Packages.flexget
        python3Packages.youtube-dl
        resilio
        rtorrent
      ];
    };

    /*chromium-env = self.buildEnv  {
      name = "chromiumEnv";
      paths = with self; [
        chromium
      ];
    };*/

    google-chrome-env = self.buildEnv  {
      name = "googleChromeEnv";
      paths = with self; [
        google-chrome
      ];
    };

    firefox-env = self.buildEnv  {
      name = "firefoxEnv";
      paths = with self; [
        firefox
      ];
    };

    /*myHsEnv = self.haskellPackages.ghcWithPackages (self: with self; [
      pandoc
      xmonad
      xmonad-contrib
    ]);*/

    /*steamEnv = self.buildEnv {
      name = "steam-env";
      ignoreCollisions = true;
      paths = with self; [
        steam
      ];
    };*/
  };
}
