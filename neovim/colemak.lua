vim.o.langmap = [[fe,FE,pr,PR,gt,GT,jy,JY,lu,LU,ui,UI,yo,YO,rs,RS,sd,SD,tf,TF,dg,DG,nj,NJ,ek,EK,il,IL,op,OP,kn,KN]]

remapTable = {
  f = 'e';
  n = 'k';
  ['<C-N>'] = '<C-K>';
}

vim.g.nremap = remapTable
vim.g.xremap = remapTable
vim.g.oremap = remapTable

noremap("<C-f>", "<C-e>") noremapEks("<C-f>", "<C-e>")
noremap("<C-p>", "<C-r>") noremapEks("<C-p>", "<C-r>")
noremap("<C-g>", "<C-t>") noremapEks("<C-g>", "<C-t>")
noremap("<C-j>", "<C-y>") noremapEks("<C-j>", "<C-y>")
noremap("<C-l>", "<C-u>") noremapEks("<C-l>", "<C-u>")
noremap("<C-u>", "<C-i>") noremapEks("<C-u>", "<C-i>")
noremap("<C-y>", "<C-o>") noremapEks("<C-y>", "<C-o>")
noremap("<C-o>", "<C-p>") noremapEks("<C-o>", "<C-p>")
noremap("<C-r>", "<C-s>") noremapEks("<C-r>", "<C-s>")
noremap("<C-s>", "<C-d>") noremapEks("<C-s>", "<C-d>")
noremap("<C-t>", "<C-f>") noremapEks("<C-t>", "<C-f>")
noremap("<C-d>", "<C-g>") noremapEks("<C-d>", "<C-g>")
noremap("<C-n>", "<C-j>") noremapEks("<C-n>", "<C-j>")
noremap("<C-e>", "<C-k>") noremapEks("<C-e>", "<C-k>")
noremap("<C-i>", "<C-l>") noremapEks("<C-i>", "<C-l>")
noremap("<C-k>", "<C-n>") noremapEks("<C-k>", "<C-n>")

tnoremap('e', 'f') tnoremap('E', 'F')
tnoremap('r', 'p') tnoremap('R', 'P')
tnoremap('t', 'g') tnoremap('T', 'G')
tnoremap('y', 'j') tnoremap('Y', 'J')
tnoremap('u', 'l') tnoremap('U', 'L')
tnoremap('i', 'u') tnoremap('I', 'U')
tnoremap('o', 'y') tnoremap('O', 'Y')
tnoremap('s', 'r') tnoremap('S', 'R')
tnoremap('d', 's') tnoremap('D', 'S')
tnoremap('f', 't') tnoremap('F', 'T')
tnoremap('g', 'd') tnoremap('G', 'D')
tnoremap('j', 'n') tnoremap('J', 'N')
tnoremap('k', 'e') tnoremap('K', 'E')
tnoremap('l', 'i') tnoremap('L', 'I')
tnoremap('p', 'o') tnoremap('P', 'O')
tnoremap('n', 'k') tnoremap('N', 'K')

tmap('<C-U>', '<Cmd>FTermToggle<CR>')
nmap('<C-U>', '<Cmd>FTermToggle<CR>')
nnoremap("<C-n>", "<C-W>w")
nnoremap("<C-e>", "<C-W>W")
nmap('<C-i>', '<Plug>DWMGrowMaster')

vim.g.VM_maps = {
  ['Find Under'] = '<C-k>',
}

inoremap("<C-e>", "<C-p>")
-- imap('<c-h>', '<Plug>(completion_prev_source)')
-- imap('<c-i>', '<Plug>(completion_next_source)')

-- vim:sw=2 ts=2 et
