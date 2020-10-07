{ kor, pkgs, krimyn, darkOrLight, ... }:
let
  inherit (kor) optionals;
  inherit (krimyn.spinyrz) izUniksDev izSemaDev;

  uniksDevPackages = with pkgs; [
  ];

  semaDevPackages = with pkgs; [
    mindforger
    krita
    calibre
    pandoc
  ];

in
{
  imports = [ ./firefox.nix ];

  home = {
    packages = with pkgs; [
      # freecad # broken
      element-desktop
    ]
    ++ (optionals izUniksDev uniksDevPackages)
    ++ (optionals izSemaDev semaDevPackages);
  };
}
