local dpp_src = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp.vim"
-- プラグイン内のLuaモジュールを読み込むため、先にruntimepathに追加する必要があります。
vim.opt.runtimepath:prepend(dpp_src)
local dpp = require("dpp")

local dpp_base = "~/.cache/dpp/"
local dpp_config = "~/.config/nvim/dpp.ts"

local denops_src = "$HOME/.cache/dpp/repos/github.com/vim-denops/denops.vim"

local ext_toml = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml"
local ext_lazy = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy"
local ext_installer = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer"
local ext_git = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-protocol-git"

vim.opt.runtimepath:append(ext_toml)
vim.opt.runtimepath:append(ext_git)
vim.opt.runtimepath:append(ext_lazy)
vim.opt.runtimepath:append(ext_installer)

--function file_exists(make_state_path)
--  vim.print(make_state_path)
--  if type(make_state_path) ~= "string" then
--    return false
--  end
--  local f = io.open(make_state_path, "r")
--  if f then
--    io.close(f)
--    return true
--  else
--    return false
--  end
--end
--
--local make_state_path = os.getenv("HOME") .. "/.cache/dpp/nvim/state.vim"
--
--if file_exists(make_state_path) then
--  os.remove(make_state_path)
--end

---- denops shared serverの設定
---- vim.g.denops_server_addr = "127.0.0.1:34141"
--
-- denopsのデバッグフラグ
-- denopsプラグインの開発をしない場合は0(デフォルト)にしてください
-- vim.g["denops#debug"] = 1
local is_state_stale_or_missing = dpp.load_state(vim.g.dpp_cache) --[[@as boolean]]
if is_state_stale_or_missing then
  vim.opt.runtimepath:prepend(denops_src)

  vim.api.nvim_create_autocmd("User", {
    pattern = "DenopsReady",
    callback = function()
--      vim.notify("vim load_state is failed")
      dpp.make_state(dpp_base, dpp_config)
    end,
  })
end

if dpp.load_state(dpp_base) then
  vim.opt.runtimepath:prepend(denops_src)

  vim.api.nvim_create_autocmd("User", {
    pattern = "DenopsReady",
    callback = function()
      vim.notify("vim load_state is failed")
      dpp.make_state(dpp_base, dpp_config)
    end,
  })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "Dpp:makeStatePost",
  callback = function()
    vim.notify("dpp make_state() is done")
  end,
})

require("keymaps")
require("settings")

--vim.api.nvim_create_augroup("MyLSPAutoFormat", { clear = true })
--vim.api.nvim_create_autocmd("BufWritePre", {
--	pattern = { "*.lua" },
--	callback = function()
--		vim.lsp.buf.format({ async = false })
--	end,
--	group = "MyLSPAutoFormat",
--})
