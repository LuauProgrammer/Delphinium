--[[
    Author: LuauProgrammer
    Date: 10/2/2022
    Script: commandHandler.lua
]]

--//Libraries

local fs = require("fs")

--//Main

return function(discordia, client)
    for _, fileName in ipairs(fs.readdirSync("./src/commands/")) do
        if fileName:endswith(".lua") then
            local module = require("../commands/" .. fileName)
            local type = type(module)
            assert(type == "table", "Expected table, got " .. type)
            assert(module.execute and module.name,
                "Missing required fields from command table (ie: name, execute function, permissions,  cooldown, restricted)") --//Bare-bones properties/functions needed to operate.
            assert(not client._commands[module.name], "Duplicate commands are not allowed.")
            client._commands[module.name] = module
        end
    end
end
