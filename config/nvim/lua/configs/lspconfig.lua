local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg and type(msg) == "string" and msg:match("lspconfig") then
    return
  end
  return original_notify(msg, level, opts)
end

local on_attach = require("nvchad.configs.lspconfig").on_attach

local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then return end

-- Список серверов, которые ты хочешь запустить
local servers = { "html", "cssls" }

-- Настройка стандартных серверов
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- Отдельная настройка для Rust
lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  -- Это поможет LSP понять, где корень твоего Rust-проекта
  root_dir = lspconfig.util.root_pattern("Cargo.toml"),
  settings = {
    ["rust-analyzer"] = {
      -- ИСПРАВЛЕНИЕ ТУТ:
      check = {
        command = "clippy", -- Теперь команда внутри блока check
      },
      -- Если хочешь, чтобы он просто проверял при сохранении:
      checkOnSave = true, 
    },
  },
}
