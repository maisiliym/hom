vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.autoread = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.showbreak = '  '
vim.o.mouse = "a"
vim.o.title = true
vim.o.wrap = true
vim.o.cursorline = false

-- Disabling slow/incorrect features
vim.g.loaded_matchparen = 1 
vim.g.did_load_ftplugin = 1 
vim.g.lspconfig = 1 -- avoid incorrect build system
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.did_indent_on = 1
command([[let did_indent_on = 1]])
-- command([[syntax off]]) -- missing some treesitter parsers

vim.g.cursorhold_updatetime = 500

command([[au BufRead,BufNewFile *.aski set filetype=ron]])
command([[au BufRead,BufNewFile flake.lock set filetype=json]])
command([[au BufRead,BufNewFile *.nix set filetype=nix]])
command([[autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"]])

command('augroup explorer')
command([[au BufReadCmd file://* :lua niovi.fileUrlEdit(vim.fn.expand("<amatch>"))]])
command('augroup end')

require('nvim-autopairs').setup()
require('gitsigns').setup()

niovi.fozi = require('fzf-commands')

vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_hide_dotfiles = 1
vim.g.nvim_tree_width_allow_resize = 1
vim.g.nvim_tree_show_icons = {
  git = 0,
  folders = 1,
  files = 1,
}
niovi.tri = require('nvim-tree')
niovi.tri.lib = require('nvim-tree.lib')

local actions = require'lir.actions'
require'lir'.setup {
  show_hidden_files = false,
  devicons_enable = true,
  mappings = {
    ['l']     = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,
    ['h']     = actions.up,
    ['q']     = actions.quit,
    ['K']     = actions.mkdir,
    ['N']     = actions.newfile,
    ['R']     = actions.rename,
    ['@']     = actions.cd,
    ['Y']     = actions.yank_path,
    ['.']     = actions.toggle_show_hidden,
  }
}

local previewers = require'telescope.previewers'

require('telescope').setup {
  extensions = { };
  defaults = {
    file_previewer = previewers.vim_buffer_cat.new;
    grep_previewer = previewers.vim_buffer_vimgrep.new;
    qflist_previewer = previewers.vim_buffer_qflist.new;
    width = 0.95,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 1,
  };
};

niovi.telescope = require('telescope.builtin')

-- start('completion')
vim.o.completeopt = [[noinsert,menuone]]
vim.g.completion_enable_auto_popup = 1
vim.g.completion_timer_cycle = 120
vim.g.completion_enable_auto_paren = 1
vim.g.completion_enable_snippet = 'UltiSnips'
vim.g.completion_auto_change_source = 1
command([[autocmd BufEnter * lua require'completion'.on_attach()]])
vim.g.completion_chain_complete_list = {
  default = {
    default = {
      { complete_items = { "snippet" } },
      { complete_items = { "lsp" } },
      { complete_items = { 'buffers' } },
      { complete_items = {"path"}, triggered_only = {'/'} },

    },
    comment = {
      { complete_items = { 'buffers' } },
    },
    string = {
      { complete_items = { 'buffers' } },
      { complete_items = {"path"}, triggered_only = {'/'} },
    },
  },
}
-- end('completion')
-- start('legacy')
vim.g.rooter_silent_chdir = true

vim.g.vim_markdown_folding_disabled = true
vim.g.vim_markdown_follow_anchor = true
vim.g.vim_markdown_fenced_languages = {
  'c++=cpp',  'rust', 'viml=vim', 'bash=sh', 'ini=dosini', 'c'
}

vim.g.indent_guides_guide_size = true
vim.g.indent_guides_enable_on_vim_startup = true
vim.g.indent_guides_exclude_filetypes = {
  'help', 'w3m', 'man', 'markdown', 'skim', 'neoterm', 'vista',
  'netrw', 'defx', 'toggleterm'
}

vim.g.fzf_buffers_jump = true
vim.g.fzf_action = {
  ['ctrl-t'] = 'tab split',
  ['ctrl-x'] = 'split',
  ['ctrl-v'] = 'vsplit',
}
vim.g.fzf_layout = { down = '~61%' }
vim.g.fzf_colors = {
  fg =      {'fg', 'Normal'},
  bg =      {'bg', 'Normal'},
  hl =      {'fg', 'Comment'},
  ['fg+'] =     {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
  ['bg+'] =     {'bg', 'CursorLine', 'CursorColumn'},
  ['hl+'] =     {'fg', 'Statement'},
  info =    {'fg', 'PreProc'},
  border =  {'fg', 'Ignore'},
  prompt =  {'fg', 'Conditional'},
  pointer = {'fg', 'Exception'},
  marker =  {'fg', 'Keyword'},
  spinner = {'fg', 'Label'},
  header =  {'fg', 'Comment'}
}
-- end('legacy')
-- vim:sw=2 ts=2 et
