local M = {}

function M.setup(opts)
    opts.default_variables = opts.default_variables or {}

    local PandocCmdTemplate = require('pandocking.template')
    PandocCmdTemplate.defaults = vim.tbl_deep_extend('keep', opts.default_variables, PandocCmdTemplate.defaults)

    require('pandocking.commands').setup(opts)
    require('pandocking.bindings').setup(opts.keybindings)
end

return M
