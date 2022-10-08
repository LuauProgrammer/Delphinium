--[[
    Author: LuauProgrammer
    Date: 10/2/2022
    Script: messageCreate.lua
]]

--//Main

return function(discordia, client, message)
    if not client._configuration.restrictCommandsToBotOwner or message.author == client.owner then
        local arguments = message.content:split(" ")
        if message.author ~= client.user and arguments[1]:startswith(client._configuration.prefix) then
            local commandName = arguments[1]:lower():sub(2)
            table.remove(arguments, 1)
            if client._commands[commandName] then
                client._commands[commandName]:execute(discordia, client, message, arguments)
            end
        end
    end
end
