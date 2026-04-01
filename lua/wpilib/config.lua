--[[
	wpilib.nvim
		Unofficial Neovim plugin for FRC
	
	(c) 2023 frc4533-lincoln & 2026 SnarkyDev
]]

local M = {}
local util = require('wpilib.util')

local config_path = util.storage_path .. '/config.json'

-- Internal helper to save
function M.save_config(data)
    local f = io.open(config_path, 'w')
    if f then
        f:write(vim.json.encode(data))
        f:close()
    end
end

-- This is the UI flow, now separated from the "getter"
function M.init_config_ui(callback)
    local versions = require('wpilib.versions')
    local Menu = require('nui.menu')

    local items = {}
    for _, v in ipairs(versions) do
        table.insert(items, Menu.item(v.tag, { unstable = not v.stable }))
    end

    local menu = Menu(util.menu_opts, {
        lines = items,
        enter = true,
        on_submit = function(item)
            local cfg = { version = item.text }
            M.save_config(cfg)
            if callback then callback(cfg) end
            vim.notify("WPILib version set to " .. item.text)
        end
    })

    menu:mount()
end

function M.load_config()
    local f = io.open(config_path, 'r')
    if f then
        local content = f:read('*a')
        f:close()
        local ok, cfg = pcall(vim.json.decode, content)
        if ok and cfg then return cfg end
    end
    return nil
end

return M

