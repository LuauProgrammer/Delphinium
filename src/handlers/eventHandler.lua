--[[
    Author: LuauProgrammer
    Date: 10/2/2022
    Script: eventHandler.lua
]]

--//Libraries

local fs = require("fs")

--//Main

return function(discordia, client)
    for _, fileName in ipairs(fs.readdirSync("./src/events/")) do
        if fileName:endswith(".lua") then
            local module = require("../events/" .. fileName)
            local type = type(module)
            assert(type == "function", "Expected function, got " .. type)
            client:on(fileName:match("(.+)%..+$"), function(...)
                module(discordia, client, ...) --//Cannot directly pass in the function as we need to pass in the client and discordia.
            end)
        end
    end
end
