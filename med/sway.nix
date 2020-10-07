{ kor, pkgs, uyrld, hob, krimyn, config, darkOrLight, ... }:
let
  inherit (builtins) readFile mapAttrs;
  inherit (kor) mkIf optionals optionalString matcSaiz;
  inherit (krimyn.spinyrz) saizAtList iuzColemak izUniksDev izSemaDev;
  inherit (krimyn) saiz;

  izDark = darkOrLight == "dark";

  waylandQtpass = pkgs.qtpass.override { pass = waylandPass; };
  waylandPass = pkgs.pass.override { x11Support = false; waylandSupport = true; };

  shellLaunch = command: "${shell} -c '${command}'";
  homeDir = config.home.homeDirectory;
  nixProfileExec = name: "${homeDir}/.nix-profile/bin/${name}";

  shell = nixProfileExec "mksh";
  zshEksek = nixProfileExec "zsh";
  neovim = nixProfileExec "nvim";
  elementaryCode = nixProfileExec "io.elementary.code";
  termVis = shellLaunch "exec ${terminal} -e  ${nixProfileExec "vis"}";
  termNeovim = shellLaunch "exec ${terminal} -e ${neovim}";
  termBrowser = shellLaunch "exec ${terminal} -e ${nixProfileExec "w3m"}";
  terminal = matcSaiz saiz "" "${nixProfileExec "alacritty"}" "${nixProfileExec "alacritty"}" "${nixProfileExec "alacritty"}";

  swayArgz = {
    inherit iuzColemak optionalString;
    waybarEksek = nixProfileExec "waybar";
    swaylockEksek = nixProfileExec "swaylock";
    browser = matcSaiz saiz "" termBrowser "${nixProfileExec "qutebrowser"}" "${nixProfileExec "qutebrowser"}";
    editor = matcSaiz saiz termVis termNeovim termNeovim termNeovim;
    launcher = "${nixProfileExec "wofi"} --show run";
    shellTerm = shellLaunch "export SHELL=${zshEksek}; exec ${terminal} -e ${zshEksek}";
  };

  fontDeriveicynz = [ pkgs.noto-fonts-cjk ]
    ++ (optionals saizAtList.med [
    uyrld.nerd-fonts.firaCode
    pkgs.fira-code
  ]);

  mkFcCache = pkgs.makeFontsCache { fontDirectories = fontDeriveicynz; };

  mkFontPaths = kor.concatMapStringsSep "\n"
    (path: "<dir>${path}/share/fonts</dir>")
    fontDeriveicynz;

  mkFontConf = ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>
      ${mkFontPaths}
      <cachedir>${mkFcCache}</cachedir>
    </fontconfig>
  '';

  alacrittyThemeFile =
    if izDark then
      "${hob.base16-alacritty.mein}/colors/base16-bright.yml"
    else
      "${hob.base16-alacritty.mein}/colors/base16-gruvbox-light-hard.yml";

  mkSoundScript = sound:
    pkgs.writeScript "soundScript" ''
      #!${pkgs.mksh}/bin/mksh
      mpv ${sound}
    '';

in
{
  services = {
    dunst = {
      enable = true;
      package = uyrld.dunst;
      waylandDisplay = "wayland-0";
      settings = {
        global = {
          geometry = "300x5-30+50";
          transparency = 10;
          frame_color = "#eceff1";
          font = "Fira Code 10";
        };

        urgency_normal = {
          background = "#37474f";
          foreground = "#eceff1";
          timeout = 10;
        };

        dino = {
          desktop_entry = "im.Dino.dino";
          # script = toString (mkSoundScript soundTheme.notification);
        };
      };
    };

    redshift = {
      enable = true;
      package = pkgs.redshift-wlr;
      latitude = "20";
      longitude = "102";
      temperature = {
        day = 5500;
        night = 2700;
      };
    };

  };

  xdg.configFile = {
    "fontconfig/conf.d/10-niksIuzyr-fonts.conf".text = mkFontConf;
  };

  programs = {
    alacritty = {
      enable = true;
      package = uyrld.alacritty;
      settings = {
        import = [ alacrittyThemeFile ];
        font = {
          size = 11;
          normal = {
            family = "Fira Code";
          };
        };
      };
    };
  };

  home = {
    packages = with pkgs; [
      # C
      # ctags
      swaylock
      grim
      waybar
      zathura
      wl-clipboard
      libnotify
      imv
      wf-recorder
      libva-utils
      ffmpeg
      # start("GTK")
      wofi
      gitg
      pavucontrol
      uyrld.dino
      transmission-remote-gtk
      ptask
      bookworm
      pantheon.elementary-files
      pantheon.elementary-code
      # start("Qt")
      nheko
      adwaita-qt
      qgnomeplatform
      waylandQtpass
      qtox
      waylandPass
      qjackctl
      # TODO('hyraizyn language')
      (hunspellWithDicts [ hunspellDicts.en-us-large ])
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      hunspellDicts.en-us-large
    ]
    ++ (optionals izUniksDev (with pkgs; [
    ]))
    ++ (optionals izSemaDev (with pkgs; [
      inkscape
      shotwell
      gthumb
    ]));

    file = {
      ".config/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-application-prefer-dark-theme=${if izDark then "1" else "0"}
      '';

      ".config/sway/config".text = import ./swayConf.nix swayArgz;

      ".config/waybar/config".source = ../nonNix/waybar/config.json;
      ".config/waybar/style.css".source = ../nonNix/waybar/style.css;

      ".config/IJHack/QtPass.conf".text = ''
        [General]
        autoclearSeconds=20
        passwordLength=32
        useTrayIcon=false
        hideContent=false
        hidePassword=true
        clipBoardType=1
        hideOnClose=false
        passExecutable=${waylandPass}/bin/pass
        passTemplate=login\nurl
        pwgenExecutable=${pkgs.pwgen}bin/pwgen
        startMinimized=false
        templateAllFields=false
        useAutoclear=true
        useTrayIcon=false
        version=${pkgs.qtpass.version}
      '';

    };
  };
}
