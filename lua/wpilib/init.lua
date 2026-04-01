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
    local config = require('wpilib.config')
    if vim.fn.isdirectory(util.storage_path) == 0 then
        vim.fn.mkdir(util.storage_path, "p")
    end

    local storage_lua = util.storage_path .. '/?.lua'
    if not package.path:find(storage_lua, 1, true) then
        package.path = package.path .. ';' .. storage_lua
    end

    local cfg = config.load_config()
    if not cfg then
        require('wpilib.new_project').fetch_versions()
        vim.schedule(function()
            config.init_config_ui()
        end)
	end
	require('wpilib.commands.commands').init_commands()
end

return M
