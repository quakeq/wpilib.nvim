--[[
	wpilib.nvim
		Unofficial Neovim plugin for FRC
	
	(c) 2023 frc4533-lincoln & 2026 SnarkyDev
]]

local M = {}

local Menu = require('nui.menu')

local function init_config()
	local f = io.open(require('wpilib.util').storage_path .. '/config.json', 'w')

	if f then
		local versions = {}
		for i, v in ipairs(require('wpilib.versions')) do
			versions[i] = Menu.item(v.tag, { unstable = not v.stable })
		end

		local cfg = {}
		local menu = Menu(require('wpilib.util').menu_opts, {
			lines = versions,
			enter = true,
			on_submit = function (item)
				f:write(vim.json.encode({ version = item.text }))
				cfg = { version = item.text }
			end
		})

		vim.schedule(function ()
			menu:mount()
		end)

		return cfg
	end
end

function M.load_config()
    local path = require('wpilib.util').storage_path .. '/config.json'
    local f = io.open(path, 'r')
    
    if f then
        local content = f:read('*a')
        f:close()
        if content and #content > 0 then
            local status, cfg = pcall(vim.json.decode, content)
            if status and cfg then
                return cfg
            end
            vim.print('Invalid configuration file')
        end
    end
    
	return init_config()
end

return M
