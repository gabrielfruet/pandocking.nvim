---@class PandocCmd
---@field cmd string
local PandocCmd = {}
PandocCmd.__index = PandocCmd

function PandocCmd.new(tbl)
    local self = setmetatable({}, PandocCmd)

    self.cmd = tbl.cmd

    return self
end
