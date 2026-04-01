local M = {}

local util = require('wpilib.util')
local new_project = require('wpilib.new_project')
local Menu = require('nui.menu')

function M.menu()
	local cfg = require('wpilib.config').load_config()
	if not cfg then
        vim.notify("No WPILib config found. Please select a version first.", vim.log.levels.WARN)
	end
	local menu = Menu(
		util.menu_opts,
		{
			lines = {
				Menu.item('New Project', { id = 'new' }),
				Menu.item('Manage Vendordeps', { id = 'vdeps' }),
			},
			enter = true,
			on_submit = function (item)
				local actions = {
					['new'] = function ()
						if cfg and cfg.version then
							new_project.new_project(cfg.version)
						else
							vim.notify("No WPILib version configured.", vim.log.levels.ERROR)
						end
					end,
					['vdeps'] = function ()
						print('Not implemented')
					end,
				}
				actions[item.id]()
			end
		}
	)

	vim.schedule(function()
		menu:mount()
	end)
end

return M

