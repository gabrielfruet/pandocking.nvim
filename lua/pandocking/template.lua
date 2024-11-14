--- @class PandocCmdVariables
--- @field input_format string
--- @field output_format string
--- @field output_extension string
--- @field output_path string
--- @field input_path string
--- @field output_name string
--- @field render_engine string
--- @field args string
local PandocCmdVariables = {}
PandocCmdVariables.__index = PandocCmdVariables

--- @class PandocCmdTemplate
--- @field arguments PandocCmdVariables
--- @field table_editor TableEditor
--- @field compile_cmd string
--- @field viewer_cmd string
local PandocCmdTemplate = {}
PandocCmdTemplate.__index = PandocCmdTemplate

local strmanip = require('pandocking.strmanip')
local TableEditor = require('pandocking.buffer.table_editor')
local pandoc_validator =  require('pandocking.pandoc.validator')

PandocCmdTemplate.defaults = {
    arguments = {
        output_path = '.pandoc/',
        input_format = 'markdown',
        output_format = 'latex',
        output_extension = 'pdf',
        render_engine = 'zathura',
        args = '',
    },
    compile_cmd = 'pandoc {args} -f {input_format} -t {output_format} {input_path} -o {output_path}{output_name}.{output_extension}',
    viewer_cmd = '{render_engine} {output_path}{output_name}.{output_extension}'
}

---@return PandocCmdTemplate
function PandocCmdTemplate.new(tbl)
    local instance = vim.tbl_deep_extend('keep', tbl, PandocCmdTemplate.defaults)

    instance.arguments = setmetatable(instance.arguments, PandocCmdVariables)
    instance = setmetatable(instance, PandocCmdTemplate)

    local ok, _ = pandoc_validator.verify(instance.arguments)
    if not ok then
        error('Something went wrong on the default values of template')
    end

    os.execute('mkdir -p ' .. instance.arguments.output_path)

    instance.table_editor = TableEditor.new(instance, 'arguments')

    return instance
end

function PandocCmdTemplate:edit()
    self.table_editor:edit_table_in_floating_window(
        pandoc_validator.verify
    )
end

---@param values table<string, string> | nil
---@return string | nil
function PandocCmdTemplate:compile(values)
    values = values or {}
    local final_values = vim.tbl_extend('force', self.arguments, values)
    return strmanip.subs(self.compile_cmd, final_values)
end

---@param values table<string, string> | nil
---@return string | nil
function PandocCmdTemplate:viewer(values)
    values = values or {}
    local final_values = vim.tbl_extend('force', self.arguments, values)
    return strmanip.subs(self.viewer_cmd, final_values)
end

return PandocCmdTemplate
