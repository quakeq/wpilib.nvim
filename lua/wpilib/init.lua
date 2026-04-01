--[[
	wpilib.nvim
		Unofficial Neovim plugin for FRC
	
	(c) 2023 frc4533-lincoln & 2026 SnarkyDev
]]

local M = {}

local function setup_paths()
    local script_path = debug.getinfo(1).source:sub(2)
    local deps_path = script_path:match("(.*[/\\])") .. "deps/lua-?/init.lua"

    if not package.path:find(deps_path, 1, true) then
        package.path = package.path .. ";" .. deps_path
    end
end

setup_paths()


function M.setup()
    local util = require('wpilib.util')

    if vim.fn.isdirectory(util.storage_path) == 0 then
        vim.fn.mkdir(util.storage_path, "p")
    end

    local storage_lua = util.storage_path .. '/?.lua'
    if not package.path:find(storage_lua, 1, true) then
        package.path = package.path .. ';' .. storage_lua
    end

    require('wpilib.commands.commands').init_commands()
end

return M
