pkgs: {
  allowUnfree = true;
  cabal.libraryProfiling = true;

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
      libvpx = self.libvpx_head;
      #nvidia-cuda-toolkit = self.nvidia-cuda-toolkit;
      #nvidia-drivers = self.nvidia-drivers_latest;
      nonfreeLicensing = true;
      opus = self.opus_head;
      x265 = self.x265_head;
      zimg = self.zimg;
    };
    mpd = self.mpd.override {
      ffmpeg = self.ffmpeg_head;
      opus = self.opus_head;
    };
    mpv = self.mpv.override {
      channel = "999";
      ffmpeg = ffmpeg_head;
      #nvidia-cuda-toolkit = self.nvidia-cuda-toolkit;
      #nvidia-drivers = self.nvidia-drivers_latest;
    };
    # python3 = self.python36;
    # python3Packages = self.python36Packages;
    # rtorrent = self.rtorrent.override {
    #   colorSupport = true;
    # };
    vapoursynth_head = self.python3Packages.vapoursynth_head.override {
      ffmpeg = self.ffmpeg_head;
    };
    #desktop = self.haskellPackages.ghcWithPackages (self: with self; [
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
        elvish
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
        lm-sensors
        mtr
        nftables
        nmap
        openssh
        openssl
        p7zip
        psmisc
        python3Packages.speedtest-cli
        smartmontools
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
        discord
        dmenu
        eog
        evince
        file-roller
        gnome-calculator
        gnome-screenshot
        gnome-terminal
        light-locker
        #mumble_git
        nautilus
        networkmanager
        networkmanager-applet
        #nvidia-settings
        pavucontrol
        pulseaudio_full
        stalonetray
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
        #goPackages.consul.bin
        #goPackages.docker.bin
        #goPackages.hugo.bin
        ###goPackages.ipfs.bin
        #goPackages.lego.bin
        #goPackages.mc.bin
        #goPackages.minio.bin
        #goPackages.nomad.bin
        #goPackages.vault.bin
        #icedtea8_web
        libxml2
        ninja
        nodejs
        openjdk
        perl
        # FIXME: errors with python 3.6
        #python3Packages.aws-cli
        python2Packages.bazaar
        #python2Packages.certbot
        python3Packages.python
        #rustc
        #swig
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
        totem
      ];
    };

    multimedia-tools-env = self.buildEnv {
      name = "multimediaToolsEnv";
      paths = with self; [
        aomedia
        #arkive
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
        #mediainfo
        #mixxx
        #mkvtoolnix
        opus-tools
        split2flac
        #qjackctl
        ufraw
        vapoursynth_head
        #vobsub2srt
        x264
        x265_head
      ];
    };

    editor-env = self.buildEnv {
      name = "editorEnv";
      paths = with self; [
        atom_beta
      ];
    };

    ipfs-env = self.buildEnv {
      name = "ipfsEnv";
      paths = with self; [
        goPackages.ipfs.bin
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
        ncdc
        #python2Packages.deluge
        #python2Packages.deluge_head
        python3Packages.flexget
        python3Packages.youtube-dl
        resilio
      ];
    };

    /*factorio-env = self.buildEnv {
      name = "factorioEnv";
      paths = with self; [
        factorio_0-16
      ];
    };*/

    /*chromium-env = self.buildEnv  {
      name = "chromiumEnv";
      paths = with self; [
        chromium
      ];
    };*/

    google-chrome-env = self.buildEnv  {
      name = "googleChromeEnv";
      paths = with self; [
        #google-chrome_beta
        google-chrome_stable
      ];
    };

    /*firefox-env = self.buildEnv  {
      name = "firefoxEnv";
      paths = with self; [
        firefox
      ];
    };*/

    /*steamEnv = self.buildEnv {
      name = "steam-env";
      ignoreCollisions = true;
      paths = with self; [
        steam
      ];
    };*/
  };
}
