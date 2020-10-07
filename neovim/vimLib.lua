command = vim.api.nvim_command

function nmap(kimap, akcyn)
  vim.api.nvim_set_keymap( 'n', kimap, akcyn, { noremap = false, silent = true, })
end

function nnoremap(kimap, akcyn)
  vim.api.nvim_set_keymap( 'n', kimap, akcyn, { noremap = true, silent = true, })
end

function inoremap(kimap, akcyn)
  vim.api.nvim_set_keymap( 'i', kimap, akcyn, { noremap = true, silent = true, })
end

function imap(kimap, akcyn)
  vim.api.nvim_set_keymap( 'i', kimap, akcyn, { noremap = false, silent = true, })
end

function noremap(kimap, akcyn)
  vim.api.nvim_set_keymap( 'n', kimap, akcyn, { noremap = true, silent = true, })
  vim.api.nvim_set_keymap( 'v', kimap, akcyn, { noremap = true, silent = true, })
  vim.api.nvim_set_keymap( 'o', kimap, akcyn, { noremap = true, silent = true, })
end

function noremap(kimap, akcyn)
  vim.api.nvim_set_keymap( 'n', kimap, akcyn, { noremap = true, silent = true, })
  vim.api.nvim_set_keymap( 'v', kimap, akcyn, { noremap = true, silent = true, })
  vim.api.nvim_set_keymap( 'o', kimap, akcyn, { noremap = true, silent = true, })
end

function noremapEks(kimap, akcyn)
  vim.api.nvim_set_keymap( '!', kimap, akcyn, { noremap = true, silent = true, })
end

function nnoremapBufferExpr(kimap, akcyn)
  vim.api.nvim_buf_set_keymap( 0, 'n', kimap, akcyn, { noremap = true, silent = true, expr = true, })
end

function tmap(kimap, akcyn)
  vim.api.nvim_set_keymap( 't', kimap, akcyn, { noremap = false, silent = true, })
end

function tnoremap(kimap, akcyn)
  vim.api.nvim_set_keymap( 't', kimap, akcyn, { noremap = true, silent = true, })
end
