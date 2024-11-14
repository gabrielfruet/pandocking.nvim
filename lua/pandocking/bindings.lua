local M = {}

local default_bindings = {
    ['PDKHotReload'] = '<leader>ph',
    ['PDKStopHotReload'] = '<leader>ps',
    ['PDKViewer'] = '<leader>pv',
    ['PDKConfig'] ='<leader>pc',
}

M.setup = function (opts)
    opts = opts or {}
    local bindings = vim.tbl_extend('keep', opts, default_bindings)
    for command, keybinding in pairs(bindings) do
        vim.keymap.set('n', keybinding, ('<cmd>%s<CR>'):format(command), {})
    end
end

return M
