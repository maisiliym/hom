{ kor, pkgs, uyrld, krimyn, hyraizyn, config, darkOrLight, ... }:
let
  inherit (builtins) concatStringsSep toString readFile toJSON;
  inherit (kor) optionalString optionals mkIf mapAttrsToList;
  inherit (uyrld) toFormat;
  inherit (hyraizyn) astra;
  inherit (krimyn.spinyrz) iuzColemak hazPriKriom
    gitSigningKey matrixID saizAtList izUniksDev;

  homeDir = config.home.homeDirectory;
  izDark = darkOrLight == "dark";

  zshEksek = "${pkgs.zsh}/bin/zsh";

  zoxideZshInit = pkgs.runCommandLocal "zoxideInit.zsh"
    { nativeBuildInputs = [ uyrld.zoxide ]; }
    "zoxide init zsh > $out";

  fzfBinds = [ ];
  fzfColemakBinds = import ./fzfColemak.nix;

  mkFzfBinds = list: "--bind=" + (concatStringsSep "," list);

  fzfBindsString = mkFzfBinds (fzfBinds ++ (optionals iuzColemak fzfColemakBinds));

  fzfColors = if izDark then import ./fzfDark.nix else import ./fzfLight.nix;
  fzfBase16Map = import ./fzfBase16map.nix;

  mkFzfColor = n: v:
    let color = fzfColors.${v};
    in "${n}:${color}";

  fzfColorString = "--color=" + (concatStringsSep ","
    (mapAttrsToList mkFzfColor fzfBase16Map));

  fzfOptsString = toString [ fzfBindsString fzfColorString ];

  ovyridynFzf = uyrld.fzf.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs
      ++ [ pkgs.makeWrapper ];
    postInstall = oldAttrs.postInstall +
      ''
         wrapProgram $out/bin/fzf \
        --set-default FZF_DEFAULT_OPTS "${fzfOptsString}" \
        --set-default FZF_DEFAULT_COMMAND "${pkgs.fd}/bin/fd --type file" \
      '';
  });

  brootConfig = toJSON { };

  mpv = pkgs.wrapMpv
    (pkgs.mpv-unwrapped.override {
      x11Support = false;
      xineramaSupport = false;
      xvSupport = false;
      waylandSupport = true;
      screenSaverSupport = false;
    })
    { youtubeSupport = saizAtList.med; };

  nixpkgsPackages = with pkgs; [
    mksh # saner bash
    alsaUtils
    pamixer
    ncpamixer
    mpv
    flac
    shntool
    dvtm
    abduco # Multiplexer/session
    vis # regex Editor
    tree
    ncdu # File visualizing
    unzip
    unrar
    fuse
    cryptsetup
    # Network
    sshfs-fuse
    ifmetric
    curl
    wget
    transmission
    rsync
    nload
    nmap
    iftop
    # Wireless
    iw
    wirelesstools
    acpi
    sox # audio capture
    tio # serial tty
    androidenv.androidPkgs_9_0.platform-tools # adb/fastboot
    #== rust
    sd
    ripgrep
    fd
    exa
    bat
    broot
    tokei # loc counter
    eva # tui calculator

  ] ++ (optionals izUniksDev [
    cpulimit
    usbutils
    pciutils
    efivar # Hardware
    lshw
    gptfdisk
    parted # Disk utils
  ] ++ (optionals (astra.mycin.ark == "x86-64") [
    i7z
  ]));

  uyrldPackages = with uyrld; [
    skrips
    ovyridynFzf
    #== rust
    zoxide
  ];

in
{
  services = {
    gpg-agent = mkIf hazPriKriom {
      enable = true;
      verbose = true;
      pinentryFlavor = "gnome3";
      defaultCacheTtl = 10800;
      maxCacheTtl = 86400;
      defaultCacheTtlSsh = 3600;
      maxCacheTtlSsh = 86400;
      enableSshSupport = true;
      sshKeys = [ krimyn.priKriomz.${astra.neim}.keygrip ];
    };
  };

  programs = {
    git = {
      enable = true;
      userEmail = matrixID;
      userName = krimyn.neim;
      signing = mkIf hazPriKriom {
        key = gitSigningKey;
        signByDefault = true;
      };
      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "main";
      };
    };

    gpg = {
      enable = true;
      settings = { };
    };

    bat = {
      enable = true;
      config = {
        theme = "gruvbox-${darkOrLight}";
        pager = "less -FR";
      };
    };

    htop = {
      enable = true;
      highlightBaseName = true;
      showProgramPath = false;
    };

    starship = {
      enable = true;
    };

    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      history = {
        ignoreDups = true;
        expireDuplicatesFirst = true;
      };

      defaultKeymap = "viins";

      sessionVariables = {
        FZF_DEFAULT_OPTS = "${fzfOptsString}";
        FZF_DEFAULT_COMMAND = "${pkgs.fd}/bin/fd --type file";
      };

      shellAliases = {
        tsync = "rsync --progress --recursive";
        nsync = "rsync --checksum --progress --recursive";
        dsync = "rsync --checksum --progress --recursive --delete";
      };

      initExtra = builtins.readFile ../nonNix/zshrc +
        ''
          if [[ $options[zle] = on ]]; then
          . ${ovyridynFzf}/share/fzf/completion.zsh
          . ${ovyridynFzf}/share/fzf/key-bindings.zsh
          . ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh
          fi
        ''
        + (readFile zoxideZshInit)
        + (optionalString iuzColemak (builtins.readFile ../nonNix/colemak.zsh));
    };

  };

  home = {
    packages = nixpkgsPackages ++ uyrldPackages;

    file = {
      ".config/broot/conf.toml".text = brootConfig;

      ".mkshrc".text = ''
        [[ -n "$PS1" ]] && SHELL=${zshEksek} exec ${zshEksek}
      '';

      ".cargo/config.toml".source = toFormat {
        neim = "cargo-config";
        valiu = {
          build.target-dir = "${homeDir}/.cargo/sharedTarget";
          registries.crates-io.index = "file:///hob/github.com/rust-lang/crates.io-index/.git";
          unstable.weak-dep-features = true;
        };
      };
    };

  };
}
