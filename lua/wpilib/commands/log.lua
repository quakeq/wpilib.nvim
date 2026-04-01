local Command = {}

function Command.show_logs()
	if not require('wpilib.commands.commands').is_valid_project() then
		vim.notify("Not a WPILib project", vim.log.levels.ERROR)
	end
    local team = require('wpilib.commands.team').getTeamNumber() or "0000"
    local host = "roboRIO-" .. team .. "-frc.local"
    vim.cmd('vsplit')
	vim.cmd('enew')

    local log_cmd = string.format("ssh lvuser@%s 'tail -F /home/lvuser/FRC_UserProgram.log'", host)

    vim.fn.jobstart(log_cmd, {
		term = true,
        on_exit = function()
            vim.notify("Log session closed", vim.log.levels.INFO)
        end
    })
    vim.cmd('setlocal scrollback=10000')
    vim.api.nvim_buf_set_name(0, "RoboRIO Logs")
end

return Command
