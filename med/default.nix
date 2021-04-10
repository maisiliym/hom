{ kor, krimyn, pkgs, uyrld, hyraizyn, ... }:
let
  inherit (builtins) readFile toJSON;
  inherit (kor) optionalString optionals;
  inherit (uyrld) kynvyrt;
  inherit (krimyn.spinyrz) izUniksDev iuzColemak;

  inherit (pkgs) mksh;
  tokenaizdGhcli = pkgs.writeScriptBin "gh" ''
    #!${mksh}/bin/mksh
    export GITHUB_TOKEN=''${GITHUB_TOKEN:-''$(${pkgs.gopass}/bin/gopass show -o github.com/token)}
    exec "${pkgs.gitAndTools.gh}/bin/gh" "$@"
  '';

  tokenaizdHub = pkgs.writeScriptBin "hub" ''
    #!${mksh}/bin/mksh
    export GITHUB_TOKEN=''${GITHUB_TOKEN:-''$(${pkgs.gopass}/bin/gopass show -o github.com/token)}
    exec "${pkgs.gitAndTools.hub}/bin/hub" "$@"
  '';

  uniksDevPackages = with pkgs; [
    # start('bash')
    nix-prefetch-git
    # start('pythonPackages')
    ranger
    # C/C++
    binutils
    openssh
    nginx
    socat
    tldr # cli help
    sdcv # cli dictionary
    jq
    tizonia-openmax-il
    djvulibre
    #== go
    ghq
    elvish
    lf
    tokenaizdGhcli
    tokenaizdHub
    vgo2nix
    #== rust
    uyrld.nightlyRust.rust
    git-series
    tree-sitter
    gitAndTools.gitui
    # Python
    uyrld.kibord.kpBootCli
    # Manuals
    unbound.man
  ];

  gedit-markdown-preview = fetchTree {
    type = "git";
    url = file:///git/github.com/maoschanz/gedit-plugin-markdown_preview;
    rev = "c259554ccb0c478a2a31eb66373c6b799cfe40a6";
  };

in
{
  imports = [
    ./sway.nix
    ./qutebrowser.nix
  ];

  programs = {
    starship = {
      enable = true;
      settings = {
        cmd_duration = {
          show_notification = true;
          min_time_to_notify = 10000; #TODO('requires build flag')
        };
        git_status = {
          disabled = true;
        };
      };
    };
  };

  home = {
    packages = with pkgs; [
      # start('bash')
      taskwarrior
      # start('pythonPackages')
      youtube-dl
      # ocrmypdf
      # C/C++
      tesseract4
      imagemagick
      flite
      opusTools
      mediainfo
      #== go
      gopass
      git-bug
      lazygit
      #== rust
    ]
    ++ optionals izUniksDev uniksDevPackages;

    file = {
      # ".config/jesseduffield/lazygit/config.yml".text = { };

      # start('gedit plugins')
      # BOG('missing python env')
      ".local/share/gedit/plugins/markdown_preview.plugin".source = "${gedit-markdown-preview}/markdown_preview.plugin";
      ".local/share/gedit/plugins/markdown_preview".source = "${gedit-markdown-preview}/markdown_preview";

      "gh/config.yml".text = toJSON {
        gitProtocol = "ssh";
      };

      ".config/rustfmt/rustfmt.toml".source = kynvyrt {
        neim = "rustfmt.toml";
        format = "toml";
        valiu = {
          edition = "2021";
        };
      };

      ".config/luaformatter/config.yaml".source = kynvyrt {
        neim = "luaFormatterConfig.yaml";
        format = "yaml";
        valiu = {
          indent_width = 2;
          continuation_indent_width = 2;
          align_args = false;
          align_parameter = false;
          align_table_field = false;
          spaces_inside_table_braces = true;
        };
      };

      # start('pythonConfigs')
      ".config/youtube-dl/config".text = ''
        -f 'bestvideo[ext=mp4]+bestaudio[ext=webm]/best[ext=webm]/best'
      '';

      ".config/ranger/rc.conf".text = '' ''
        + (optionalString iuzColemak readFile ./colemak.conf);
      # end('pythonConfigs')

    };
  };
}
