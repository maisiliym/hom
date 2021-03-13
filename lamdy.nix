argz@{ kor, hyraizyn, krimyn, input, uyrld, hob }:
let
  inherit (kor) optional;
  inherit (argz.uyrld) pkdjz;
  inherit (krimyn.spinyrz) saizAtList;
  inherit (pkdjz) home-manager;
  inherit (home-manager.extendedLib) evalModules;

  beisModule = import ./beisModule.nix;

  homModules = [ beisModule ]
    ++ (optional saizAtList.min (import ./neovim))
    ++ (optional saizAtList.min (import ./min))
    ++ (optional saizAtList.med (import ./med))
    ++ (optional saizAtList.max (import ./max));

  darkOrLight = if input.tyrget.dark then "dark" else "light";

  uyrld = argz.uyrld // pkdjz; /* Lazy Hak */

  argzModule = {
    _module.args = {
      inherit kor pkdjz uyrld hob darkOrLight krimyn hyraizyn;
    };
  };

  ival = evalModules {
    modules = homModules
      ++ home-manager.modules
      ++ [ argzModule ];
  };

in
ival.config.home.activationPackage
