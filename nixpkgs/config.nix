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
      libebur128 = self.libebur128;
      mfx-dispatcher = self.mfx-dispatcher;
      nvenc = true;
      nonfreeLicensing = true;
    };
    pulseaudio_full = self.pulseaudio_full.override {
      loopbackLatencyMsec = "20";
      resampleMethod = "speex-float-10";
    };
    python3 = self.python36;
    python3Packages = self.python36Packages;
    #rtorrent = self.rtorrent.override {
      #  colorSupport = true;
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
        #gnome-screenshot
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
        gn
        gnumake
        go
        #goPackages.hugo.bin
        ###goPackages.ipfs.bin
        #goPackages.lego.bin
        #goPackages.mc.bin
        #goPackages.minio.bin
        goPackages.nomad.bin
        #goPackages.vault.bin
        #icedtea8_web
        ninja
        nodejs
        #openjdk
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
        arkive
        imagemagick
        #gimp
        #guitarix
        #jack2_full
        lame
        #libpng
        libvpx_head
        libvpx_next  # AV1/AOMedia
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
        x265
      ];
    };

    editor-env = self.buildEnv {
      name = "editorEnv";
      paths = with self; [
        atom
        atom_beta
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
        python3Packages.flexget
        python3Packages.youtube-dl
        resilio
        rtorrent
        transmission_head
        transmission-remote-gtk
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
        google-chrome_beta
        google-chrome_unstable
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
