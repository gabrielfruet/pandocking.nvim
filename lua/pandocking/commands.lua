local M = {}

M.setup = function (opts)
    local buftemplate = require('pandocking.buftemplate')
    local function get_buf_or_error()
        local buf = vim.api.nvim_get_current_buf()
        return buftemplate[buf]
    end

    vim.api.nvim_create_user_command('PDKConfig',
        function()
            get_buf_or_error().template:edit()
        end, {})
    vim.api.nvim_create_user_command('PDKStopHotReload',
        function()
            get_buf_or_error().stop_hot_reload()
        end, {})

    vim.api.nvim_create_user_command('PDKHotReload',
        function()
            get_buf_or_error().activate_hot_reload()
        end, {})

    vim.api.nvim_create_user_command('PDKViewer',
        function()
            get_buf_or_error().open_viewer()
        end, {})
end

return M
