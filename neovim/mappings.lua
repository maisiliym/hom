-- Leader
command([[let mapleader = "\<Space>"]])
command([[let maplocalleader = ","]])
nnoremap("<Space>", "<nop>")
tnoremap('<C-Q>', [[<C-\><C-n>]])

nmap('<leader>kl',
  '<cmd>lua print(vim.uri_from_bufnr(vim.api.nvim_get_current_buf()))<cr>')
-- start('Miksd')
nmap("-", ":NvimTreeFindFile<cr>")
nmap("<Leader>w", ":w<CR>")
nnoremap("<Leader><space>q", "<C-W>q<CR>")
nmap("<Leader><Esc>", ":nohlsearch<cr>")
-- end('Miksd')
-- start('Foziz')
nmap('<leader>gf', '<cmd>lua niovi.telescope.builtin()<cr>')
nmap('<leader>fh', [[:Files! ~/dev<CR>]])
nmap('<leader>fH',
  [[:lua niovi.telescope.find_files{ search_dirs = {'~/dev',} }<CR>]])
nmap('<leader>fj', [[:Files! ./<CR>]])
nmap('<leader>fJ', [[:lua niovi.telescope.git_files()<CR>]])
nmap('<leader>ff', [[:History!<CR>]])
nmap('<leader>fF', [[:Telescope frecency<CR>]])
nmap('<leader>jj', [[:ContentRg!<CR>]])
nmap('<leader>jJ', [[:lua niovi.telescope.live_grep()<CR>]])
nmap('<leader>jf', [[:TypedRg<CR>]])
nmap('<leader>jf', [[:TypedRg!<CR>]])
nmap('<leader>jk', [[:ParentRg<CR>]])
nmap('<leader>jK', [[:ParentRg!<CR>]])
nmap('<leader>nj', [[:Lines<CR>]])
nmap('<leader>nJ', [[:Lines!<CR>]])
nmap('<leader>jl', [[:BLines<CR>]])
nmap('<leader>jL', [[:BLines!<CR>]])
nmap('<leader>nf', [[:Buffers<CR>]])
nmap('<leader>mf', [[:Marks<CR>]])
nmap('<leader>fd', [[:Files! /git<CR>]])
-- end('Foziz')
-- start('lsp')
nmap('<leader>kj', [[:lua vim.lsp.buf.document_symbol()<CR>]])
nmap('<leader>kf', [[:lua vim.lsp.buf.workspace_symbol()<CR>]])
nmap('<leader>kd', [[:lua vim.lsp.buf.definition()<CR>]])
nmap('<leader>kn', [[:lua vim.lsp.buf.hover()<CR>]])
nmap('<leader>kr', [[:lua vim.lsp.buf.rename()<CR>]])
nmap('<leader>kg', [[:lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]])
nmap('<leader>ka', [[:lua vim.lsp.diagnostic.goto_prev()<CR>]])
nmap('<leader>kp', [[:lua vim.lsp.diagnostic.goto_next()<CR>]])
nmap('<leader>kl', [[:Vista!!<CR>]])
-- end('lsp')
-- start('kakoune')
-- nmap("<leader>ia", ":! termite -e 'kak %'<CR>")
noremap("U", ":redo<CR>")
noremap("gl", [[$]])
noremap("gh", "0")
noremap("gj", "G")
noremap("gk", "gg")
-- start('kakoune')
-- start('git')
nmap("<leader>dd", ":LazyGit<cr>")
nmap("<leader>df", ":GFiles!?<cr>")
nmap("<leader>dn", ":Gina status --opener=split<cr>")
nmap("<leader>dj", ":Commits!<cr>")
nmap("<leader>du", ":GV<cr>")
nmap("<leader>dl", ":BCommits!<cr>")
-- nmap("<leader>ds", ":Gina branch --opener=split<cr>")
nmap("<leader>dw", ":Gina add %<cr>")
nmap("<leader>dc", ":Gina commit --opener=split<cr>")
nmap("<leader>dr",
  ":Gina commit --amend --allow-empty-message --opener=split<cr>")
nmap("<leader>dy", ":Gina pull<CR>")
nmap("<leader>dp", ":Gina push<CR>")
nmap("<leader>dm", ":Gina blame<CR>")
nmap("<leader>dk", ":Gina commit --allow-empty-message --message=''<CR>")
-- end('git')
-- start('nvim')
nmap("<leader>lg", "<CMD>Help<CR>")
nmap("<leader>lG", "<CMD>Help!<CR>")
nmap('<leader>lf', [[:History:<CR>]])
nmap('<leader>ls', [[:Maps<CR>]])
nmap('<leader>ld', [[:Commands<CR>]])
-- end('nvim')
