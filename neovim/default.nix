{ kor, pkgs, uyrld, krimyn, config, darkOrLight, hyraizyn, ... }:
let
  inherit (builtins) concatStringsSep readFile elem;
  inherit (kor) optionalString optionals mkIf mapAttrsToList optional;
  inherit (krimyn.spinyrz) izUniksDev saizAtList iuzColemak;
  inherit (hyraizyn) astra;
  inherit (uyrld) vimPloginz;

  aolPloginz = pkgs.vimPlugins // vimPloginz;

  minVimLPloginz = with vimPloginz; [
    dwm-vim
    vim-visual-multi
    fzf-vim
    zoxide-vim
    astronauta-nvim
  ];

  medVimlPlogins = with aolPloginz; [
    nvim-yarp # UpdateRemotePlugin replacement
    gina-vim # git
    vista-vim # Tags
    vim-toml
    ron-vim
    tokei-vim
    vim-nix
    dhall-vim
    vim-markdown
    vim-ledger
    vim-surround
    vim-pager
    vim-rooter
    ultisnips
    vim-snippets
    bufferize-vim
    minimap-vim
  ];

  maxVimlPlogins = with aolPloginz; [
    vim-fugitive # git
    gv-vim
  ];

  vimlPloginz = minVimLPloginz
    ++ (optionals saizAtList.med medVimlPlogins)
    ++ (optionals saizAtList.max maxVimlPlogins);

  luaPloginz = minLuaPloginz
    ++ (optionals saizAtList.med medLuaPloginz)
    ++ (optionals saizAtList.max maxLuaPloginz);

  minLuaPloginz = with vimPloginz; [
    plenary-nvim
    popup-nvim
    nvim-tree-lua
    lir-nvim
    completion-nvim
    completion-buffers
    nvim-treesitter
    nvim-treesitter-refactor
    barbar-nvim
    telescope-nvim
    FTerm-nvim
    neogit # bogi
    gitsigns-nvim # bogi
    BufOnly-nvim
    nvim-autopairs
    nvim-fzf
    nvim-fzf-commands
    kommentary
  ];

  medLuaPloginz = with vimPloginz; [
    nvim-lspconfig
    lsp-status-nvim
    nvim-lspfuzzy
    nvim-web-devicons
    galaxyline-nvim
    nvim-colorizer-lua
    nvim-base16-lua
    nvim-lazygit
    fzf-lsp-nvim
    formatter-nvim
  ];

  maxLuaPloginz = with vimPloginz; [
    lspsaga-nvim
    nvim-treesitter-context
  ];

  izLight = darkOrLight == "light";

  themeKod =
    let
      lightTheme = "gruvbox-light-hard";
      darkTheme = "bright";
      theme = if izLight then lightTheme else darkTheme;
    in
    ''
      vim.g.syntax_cmd = 'skip'
      local base16 = require 'base16'
      base16(base16.themes['${theme}'], true)
      command('hi def link NeogitDiffAddHighlight SignColumn')
      command('hi def link NeogitDiffDeleteHighlight SignColumn')
      command('hi def link NeogitDiffContextHighlight SignColumn')
      command('hi def link NeogitHunkHeader SignColumn')
      command('hi def link NeogitHunkHeaderHighlight SignColumn')
    '';

  ctagsKod = ''
    vim.g['loaded_gentags#gtags'] = 1
    vim.g['gen_tags#ctags_bin'] = '${pkgs.universal-ctags}/bin/ctags'
  '';

  treeGrammars = pkgs.tree-sitter.builtGrammars;
  treesitterParserz = ''
    vim.treesitter.require_language("rust", [[${treeGrammars.tree-sitter-rust}/parser]])
    vim.treesitter.require_language("c", [[${treeGrammars.tree-sitter-c}/parser]])
    vim.treesitter.require_language("cpp", [[${treeGrammars.tree-sitter-cpp}/parser]])
    vim.treesitter.require_language("go", [[${treeGrammars.tree-sitter-go}/parser]])
    vim.treesitter.require_language("html", [[${treeGrammars.tree-sitter-html}/parser]])
    vim.treesitter.require_language("java", [[${treeGrammars.tree-sitter-java}/parser]])
    vim.treesitter.require_language("javascript", [[${treeGrammars.tree-sitter-javascript}/parser]])
    vim.treesitter.require_language("json", [[${treeGrammars.tree-sitter-json}/parser]])
    vim.treesitter.require_language("lua", [[${treeGrammars.tree-sitter-lua}/parser]])
    vim.treesitter.require_language("php", [[${treeGrammars.tree-sitter-php}/parser]])
    vim.treesitter.require_language("python", [[${treeGrammars.tree-sitter-python}/parser]])
    vim.treesitter.require_language("nix", [[${treeGrammars.tree-sitter-nix}/parser]])
  '';

  raPath = "${uyrld.rust-analyzer}/bin/rust-analyzer";
  clangdPath = "${pkgs.llvmPackages_latest.clang-unwrapped}/bin/clangd";
  cmakeLSPath = "${pkgs.cmake-language-server}/bin/cmake-language-server";
  goplsPath = "${pkgs.gopls}/bin/gopls";
  hlsWrapperPath = "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper";
  pylsPath = "${pkgs.python3Packages.python-language-server}/bin/pyls";
  luaLSPath = "${uyrld.luaLS.lua-lsp}/bin/lua-lsp";

  minKod = ''
    require'nvim-treesitter.configs'.setup {
      incremental_selection = {
        keymaps = {
  '' + (if iuzColemak then ''
    node_decremental = "<C-N>",
    node_incremental = "<C-E>",
  '' else ''
    node_decremental = "<C-J>",
    node_incremental = "<C-K>",
  '') + ''
        },
      },
    }
  '';

  medLangServers = {
    rust_analyzer = { cmd = [ raPath ]; };
    rnix = { cmd = [ "${uyrld.rnix-lsp}/bin/rnix-lsp" ]; };
    clangd = { cmd = [ clangdPath "--background-index" ]; };
    # cmake = { cmd = [ cmakeLSPath ]; }; # broken
  };

  maxLangServers = {
    pyls = { cmd = [ pylsPath ]; };
    gopls = { cmd = [ goplsPath ]; };
    hls = { cmd = [ hlsWrapperPath "--lsp" ]; };
  };

  mkLSKod = name: value@{ iuzHak ? true, ... }:
    let
      cmd = concatStringsSep "\", \"" value.cmd;
    in
    ''
      lspconfig.${name}.setup {
        cmd = { "${cmd}" };
    '' + optionalString iuzHak ''
      capabilities = vim.tbl_deep_extend('force',
      default_capabilities,
      {
        codeAction = {
          dynamicRegistration = false;
          codeActionLiteralSupport = {
            codeActionKind = {
              valueSet = {
                 "", "quickfix", "refactor", "refactor.extract",
                 "refactor.inline", "refactor.rewrite",
                 "source", "source.organizeImports",
              };
            };
          };
        };
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = true,
            };
          };
        };
      })
    '' + ''
      };
    '';

  mapLSzKod = LSz: ''
    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  ''
  + (concatStringsSep "\n" (mapAttrsToList mkLSKod LSz));

  medKod = ''
    local lspconfig = require'lspconfig'
    ${mapLSzKod medLangServers}

     vim.g.sql_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'

    vim.g.UltiSnipsJumpBackwardTrigger = '<c-h>'
  '' + (if iuzColemak then ''
    vim.g.UltiSnipsJumpForwardTrigger = '<c-i>'
  '' else ''
    vim.g.UltiSnipsJumpForwardTrigger = '<c-l>'
  '');

  maxKod = ''
    ${mapLSzKod maxLangServers}
    vim.g.gitblame_enabled  = 0
    require('lspsaga').init_lsp_saga()
  '';

  medLuaKod = medKod
    + (readFile ./med.lua)
    + ctagsKod;

  maxLuaKod = maxKod;

  initLuaKod = (readFile ./vimLib.lua)
    + (readFile ./niovi.lua)
    + (optionalString iuzColemak readFile ./colemak.lua)
    + (readFile ./mappings.lua)
    + (optionalString (!iuzColemak) (readFile ./qwerty.lua))
    + (readFile ./dwm.lua)
    + treesitterParserz
    + (readFile ./treesitter.lua)
    + minKod
    + (readFile ./min.lua)
    + themeKod
    + (readFile ./galaxyline.lua)
    + (optionalString (izUniksDev && saizAtList.med)
    (medLuaKod + optionalString saizAtList.max maxLuaKod));

  luaVimrc = pkgs.writeText "vimrc.lua" initLuaKod;

  minPackages = with pkgs; [ ];

  medPackages = with pkgs; [
    w3m-nographics
    llvmPackages_latest.clang
    universal-ctags
    go
    neovim-remote
    uyrld.nixpkgs-fmt
    sqlite
  ];

  maxPackages = with pkgs; [ ghc cabal-install stack ];

in
{
  home = {
    packages = minPackages
      ++ (optionals (izUniksDev && saizAtList.med)
      (medPackages ++ (optionals saizAtList.max maxPackages)));

    sessionVariables = {
      EDITOR =
        if saizAtList.med then
          "nvr -cc split --remote-wait +'set bufhidden=wipe'" else "nvim";
    };
  };

  programs = {
    neovim = {
      package = uyrld.neovim;
      enable = true;
      withPython = false;
      withRuby = false;
      vimAlias = true;
      plugins = vimlPloginz ++ luaPloginz;

      extraConfig = readFile ./leftovers.vim
        + "luafile ${luaVimrc}";
    };

  };
}
