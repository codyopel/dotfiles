pkgs: {
  allowUnfree = true;
  cabal.libraryProfiling = true;
  # Suckless
  st.conf = (builtins.readFile ./st/config.mach.h)
    + (builtins.readFile ./st/config.inc.h);

  packageOverrides = self: rec {

    # chromium = self.chromium.override {
    #   proprietaryCodecs = true;
    #   #enableWideVine = true;
    #   #enablePepperFlash = true;
    # };
    #emacs = self.emacs.override {
    #  withX = false;
    #};
    ffmpeg_head = self.ffmpeg_head.override {
      fdk-aac = self.fdk-aac_head;
      flite = self.flite;
      #nvenc = true;
      #libnppSupport = false;
      #nvidia-cuda-toolkit = self.nvidia-cuda-toolkit;
      #nvidia-drivers = self.nvidia-drivers_latest;
      nonfreeLicensing = true;
    };
    mpd = self.mpd.override {
      ffmpeg = self.ffmpeg_head;
      opus = self.opus_head;
    };
    mpv = self.mpv.override {
      ffmpeg = ffmpeg_head;
      #nvidia-cuda-toolkit = self.nvidia-cuda-toolkit;
      #nvidia-drivers = self.nvidia-drivers_latest;
    };
    # pulseaudio_full = self.pulseaudio_full.override {
    #   loopbackLatencyMsec = "20";
    #   resampleMethod = "speex-float-10";
    # };
    # python3 = self.python36;
    # python3Packages = self.python36Packages;
    # rtorrent = self.rtorrent.override {
    #   colorSupport = true;
    # };
    transmission_head = self.transmission_head.override {
      useStableVersionUserAgent = true;
    };
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
        fish
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
        rsync
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

        gnupg
        pcsc-lite_full
        pinentry_gtk
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
        cmake
        gcc
        #gn
        gnumake
        go
        goPackages.consul.bin
        #goPackages.docker.bin
        #goPackages.hugo.bin
        ###goPackages.ipfs.bin
        #goPackages.lego.bin
        #goPackages.mc.bin
        #goPackages.minio.bin
        #goPackages.nomad.bin
        #goPackages.vault.bin
        #icedtea8_web
        ninja
        nodejs
        #openjdk
        perl
        # FIXME: errors with python 3.6
        #python3Packages.aws-cli
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
        minidlna
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
        aomedia
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
        opus-tools
        split2flac
        #qjackctl
        ufraw
        #vobsub2srt
        x264
        x265_head
      ];
    };

    editor-env = self.buildEnv {
      name = "editorEnv";
      paths = with self; [
        #libreoffice
        sublime-text
      ];
    };

    rclone-env = self.buildEnv {
      name = "rcloneEnv";
      paths = with self; [
        goPackages.rclone.bin
      ];
    };

    p2p-env = self.buildEnv {
      name = "p2pEnv";
      paths = with self; [
        #goPackages.syncthing.bin
        python3Packages.guessit
        lftp
        ncdc
        #python35Packages.acd-cli
        python2Packages.deluge
        python2Packages.flexget
        #python3Packages.youtube-dl
        resilio
        #rtorrent
        transmission_head
        transmission-remote-gtk
        task-spooler
      ];
    };

    factorio-env = self.buildEnv {
      name = "factorioEnv";
      paths = with self; [
        factorio
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
        google-chrome_stable
      ];
    };

    /*firefox-env = self.buildEnv  {
      name = "firefoxEnv";
      paths = with self; [
        firefox
      ];
    };*/

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
