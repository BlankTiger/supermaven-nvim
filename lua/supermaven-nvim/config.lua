local default_config = {
  keymaps = {
    accept_suggestion = "<C-Tab>",
    clear_suggestion = "<C-]>",
    accept_word = "<C-j>",
    accept_line = "<Tab>",
  },
  ignore_filetypes = {},
  disable_inline_completion = false,
  current_line_only = false,
  disable_keymaps = false,
  condition = function()
    return false
  end,
  log_level = "info",
}

local M = {
  config = vim.deepcopy(default_config),
}

M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(default_config), args)
end

return setmetatable(M, {
  __index = function(_, key)
    if key == "setup" then
      return M.setup
    end
    return rawget(M.config, key)
  end,
})
