local buf_template = require('pandocking.buftemplate')
local template = require('pandocking.template')

local kset = vim.keymap.set
local hot_reload = false

local buf = vim.api.nvim_get_current_buf()
local fpath_w_extension = vim.fn.expand('%')
local fname = vim.fn.expand('%:tr')

local function open_viewer()
    vim.fn.jobstart(buf_template[buf].template:viewer{})
end

local function activate_hot_reload()
    hot_reload = true
    vim.print("Hot reload enabled")
end

local function stop_hot_reload()
    hot_reload = true
    vim.print("Hot reload disabled")
end

buf_template[buf] = {
    template = template.new{
        arguments = {
            output_name = fname,
        }
    },
    open_viewer = open_viewer,
    activate_hot_reload = activate_hot_reload,
    stop_hot_reload = stop_hot_reload,
}

kset('n', '<leader>zo', open_viewer, {buffer=buf,noremap=true,})
kset('n', '<leader>re', activate_hot_reload, {buffer=buf,noremap=true,})
kset('n', '<leader>rs', stop_hot_reload , {buffer=buf,noremap=true,})

local function stder_handler(cmd)
    return function (job_id, data, event)
        -- Check if there's any data in the stderr output
        if data and #data > 1 then
            -- Join the data array (it may come in chunks) and print to the user
            local error_message = table.concat(data, "\n")
            -- Print the error message
            vim.api.nvim_err_writeln("Error from \'" .. cmd .. "\' " .. job_id .. ": " .. error_message)
        end
    end
end

vim.api.nvim_create_autocmd('BufWritePost', {
    group=vim.api.nvim_create_augroup('hot_reload_to_pandoc', {clear=true}),
    buffer=buf,
    callback=function ()
        if not hot_reload then return end
        local cmd = buf_template[buf].template:compile{
            input_path = fpath_w_extension
        }

        vim.fn.jobstart(cmd, {
            detach=true,
            on_stderr=stder_handler(cmd)
        })
    end
})

vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'

