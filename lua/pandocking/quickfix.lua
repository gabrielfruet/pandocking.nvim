local M = {}

function M.generate_toc_quickfix()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local quickfix_list = {}

    for i, line in ipairs(lines) do
        local level, header = line:match("^(#+)%s+(.*)")
        if level and header then
            local indent_level = string.rep("  ", #level - 1)
            table.insert(quickfix_list, {
                bufnr = 0,
                lnum = i + 1,
                col = 1,
                text = indent_level .. header,
            })
        end
    end

    if #quickfix_list > 0 then
        vim.fn.setqflist(quickfix_list, "r")
        vim.cmd("copen")
    else
        print("No headers found to create Table of Contents.")
    end
end

vim.api.nvim_create_user_command("PandocToc", M.generate_toc_quickfix, {})

return M
