local Command = {}

function Command.getTeamNumber()
    local path = vim.uv.cwd() .. "/.wpilib/wpilib_preferences.json"
    if vim.fn.filereadable(path) == 0 then return nil end

    local lines = vim.fn.readfile(path)
    local content = table.concat(lines, "\n")
    local ok, data = pcall(vim.json.decode, content)

    if ok and type(data) == "table" then
        return data.teamNumber
    end
    return nil
end

function Command.setTeam(args)
    local currentTeam = Command.getTeamNumber()

    if not args or not args[1] then
        vim.notify("Team Number: " .. tostring(currentTeam or "not set"))
        return
    end

    local num = tonumber(args[1])
    if not num then
        vim.notify("Invalid team number", vim.log.levels.ERROR)
        return
    end

    local file = vim.uv.cwd() .. "/.wpilib/wpilib_preferences.json"
    local lines = vim.fn.readfile(file)
    local data = vim.json.decode(table.concat(lines, "\n"))

    data.teamNumber = num
    vim.fn.writefile({ vim.json.encode(data) }, file)
    vim.notify("Set team number to " .. num)
end

return Command
