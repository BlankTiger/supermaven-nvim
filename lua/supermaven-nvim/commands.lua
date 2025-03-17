local log = require("supermaven-nvim.logger")
local api = require("supermaven-nvim.api")
local completion_preview = require("supermaven-nvim.completion_preview")

local M = {}

M.setup = function()
  vim.api.nvim_create_user_command("SupermavenStart", function()
    api.start()
  end, {})

  vim.api.nvim_create_user_command("SupermavenStop", function()
    api.stop()
  end, {})

  vim.api.nvim_create_user_command("SupermavenRestart", function()
    api.restart()
  end, {})

  vim.api.nvim_create_user_command("SupermavenToggle", function()
    api.toggle()
  end, {})

  vim.api.nvim_create_user_command("SupermavenStatus", function()
    log:trace(string.format("Supermaven is %s", api.is_running() and "running" or "not running"))
  end, {})

  vim.api.nvim_create_user_command("SupermavenUseFree", function()
    api.use_free_version()
  end, {})

  vim.api.nvim_create_user_command("SupermavenUsePro", function()
    api.use_pro()
  end, {})

  vim.api.nvim_create_user_command("SupermavenLogout", function()
    api.logout()
  end, {})

  vim.api.nvim_create_user_command("SupermavenShowLog", function()
    api.show_log()
  end, {})

  vim.api.nvim_create_user_command("SupermavenClearLog", function()
    api.clear_log()
  end, {})

  vim.api.nvim_create_user_command("SupermavenAcceptSuggestion", function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "i" or mode == "ic" then
      completion_preview.on_accept_suggestion()
    else
      vim.api.nvim_feedkeys("i", "n", false)
      completion_preview.on_accept_suggestion()
    end
  end, { desc = "Accept cursor suggestion" })

  vim.api.nvim_create_user_command("SupermavenAcceptWord", function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "i" or mode == "ic" then
      completion_preview.on_accept_suggestion_word()
    else
      vim.api.nvim_feedkeys("i", "n", false)
      completion_preview.on_accept_suggestion_word()
    end
  end, { desc = "Accept cursor suggestion up to next word" })

  vim.api.nvim_create_user_command("SupermavenAcceptLine", function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "i" or mode == "ic" then
      completion_preview.on_accept_suggestion_line()
    else
      vim.api.nvim_feedkeys("i", "n", false)
      completion_preview.on_accept_suggestion_line()
    end
  end, { desc = "Accept only the current line of the suggestion" })
  
  vim.api.nvim_create_user_command("SupermavenClearSuggestion", function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "i" or mode == "ic" then
      completion_preview.on_dispose_inlay()
    else
      vim.api.nvim_feedkeys("i", "n", false)
      completion_preview.on_dispose_inlay()
    end
  end, { desc = "Clear cursor suggestion" })

  vim.api.nvim_create_user_command("SupermavenDebug", function()
    completion_preview.debug_state()
    local parent_module = require("supermaven-nvim")
    parent_module.debug_config()
  end, { desc = "Debug inlay hints state" })
end

return M
