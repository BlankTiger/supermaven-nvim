local completion_preview = require("supermaven-nvim.completion_preview")
local log = require("supermaven-nvim.logger")
local config = require("supermaven-nvim.config")
local commands = require("supermaven-nvim.commands")
local api = require("supermaven-nvim.api")

local M = {}

M.setup = function(args)
  config.setup(args)

  -- Set the configuration options on the completion_preview module
  completion_preview.disable_inline_completion = config.disable_inline_completion
  completion_preview.current_line_only = config.current_line_only
  
  if not config.disable_keymaps then
    if config.keymaps.accept_suggestion ~= nil then
      local accept_suggestion_key = config.keymaps.accept_suggestion
      vim.keymap.set(
        "i",
        accept_suggestion_key,
        completion_preview.on_accept_suggestion,
        { noremap = true, silent = true }
      )
    end

    if config.keymaps.accept_word ~= nil then
      local accept_word_key = config.keymaps.accept_word
      vim.keymap.set(
        "i",
        accept_word_key,
        completion_preview.on_accept_suggestion_word,
        { noremap = true, silent = true }
      )
    end

    if config.keymaps.accept_line ~= nil then
      local accept_line_key = config.keymaps.accept_line
      vim.keymap.set(
        "i",
        accept_line_key,
        completion_preview.on_accept_suggestion_line,
        { noremap = true, silent = false }
      )
    end

    if config.keymaps.clear_suggestion ~= nil then
      local clear_suggestion_key = config.keymaps.clear_suggestion
      vim.keymap.set("i", clear_suggestion_key, completion_preview.on_dispose_inlay, { noremap = true, silent = true })
    end
  end

  commands.setup()

  local cmp_ok, cmp = pcall(require, "cmp")
  if cmp_ok then
    local cmp_source = require("supermaven-nvim.cmp")
    cmp.register_source("supermaven", cmp_source.new())
  else
    if config.disable_inline_completion then
      log:warn(
        "nvim-cmp is not available, but inline completion is disabled. Supermaven nvim-cmp source will not be registered."
      )
    end
  end

  api.start()
end

-- Debug function to manually test key mappings
M.test_keymap = function()
  print("Testing keymaps...")
  print("Testing accept_line function directly:")
  completion_preview.on_accept_suggestion_line()
  
  print("Mapping <C-l> explicitly:")
  vim.keymap.set("i", "<C-l>", function()
    print("C-l pressed!")
    completion_preview.on_accept_suggestion_line()
  end, { noremap = true, silent = false })
end

-- Debug function to show configuration values
M.debug_config = function()
  print("Supermaven Configuration:")
  print("  disable_inline_completion:", config.disable_inline_completion)
  print("  current_line_only:", config.current_line_only)
  print("  disable_keymaps:", config.disable_keymaps)
  
  print("CompletionPreview State:")
  print("  disable_inline_completion:", completion_preview.disable_inline_completion)
  print("  current_line_only:", completion_preview.current_line_only)
end

return M
