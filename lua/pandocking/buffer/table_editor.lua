---@class TableEditor
---@field table table
---@field key string
local TableEditor = {}
TableEditor.__index = TableEditor

function TableEditor.new(tbl, key)
    local instance = setmetatable({}, TableEditor)
    instance.key = key
    instance.table = tbl
    return instance
end

-- Function to open a floating window to edit the table
--- @param valid_cb fun(tbl: table): boolean, table
function TableEditor:edit_table_in_floating_window(valid_cb)
    -- Create a buffer and set it as modifiable
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'lua')

    local edited_table = self.table[self.key]

    -- Populate the buffer with the table in `'key'='value'` format
    local lines = {}
    for k, v in pairs(edited_table) do
        table.insert(lines, string.format("%s='%s'", tostring(k), tostring(v)))
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Define the floating window's size and position
    local width = 40
    local height = #lines
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        style = 'minimal',
        border = 'rounded',
    }
    local win = vim.api.nvim_open_win(buf, true, opts)

    self.buf = buf
    self.win = win

    -- Keymap to save changes and update the original table
    vim.keymap.set('n', '<CR>', function() self:save_changes(valid_cb) end, { noremap = true, silent = true, buffer=buf})
    vim.keymap.set('n', 'q', ':close<CR>', { noremap = true, silent = true, buffer=buf})

end

-- Function to save changes back to the original table
--- @param valid_cb fun(tbl: table): boolean, table
function TableEditor:save_changes(valid_cb)
    local lines = vim.api.nvim_buf_get_lines(self.buf, 0, -1, false)
    local updated_table = {}

    for _, line in ipairs(lines) do
        local key, value = line:match("^([%w_]+)%s*=%s*'(.-)'$")
        if key and value then
            updated_table[key] = value
        else
            vim.api.nvim_err_writeln("Invalid syntax on line: " .. line)
            return
        end
    end
    local ok, inconsistent = valid_cb(updated_table)
    if not ok then
        local error_string = "Table cannot be updated, due to the inconsistency of some keys\n"
        for k,v in pairs(inconsistent) do
            if type(v) == 'table' then
                error_string = error_string .. ("%s:\n"):format(k)

                for _, v2 in pairs(v) do
                    error_string = error_string .. ("%s, \n"):format(v2)
                end
            else
                error_string = error_string .. ("%s: %s\n"):format(k,v)
            end
        end
        vim.api.nvim_err_write(error_string)
        return
    end

    -- Update the original table if parsing was successful
    self.table[self.key] = updated_table
    vim.api.nvim_win_close(self.win, true)

    self.buf = nil
    self.win = nil
    print("Table updated successfully!")
end

return TableEditor
