--[[
    Author: LuauProgrammer
    Date: 10/2/2022
    Script: messageCreate.lua
]]

--//Libraries

local timer = require("timer")

--//Main

local function cooldown(client, commandName, userId, guildId)
    if client._cooldowns[guildId] then
        client._cooldowns[guildId][commandName][userId] = nil
    end
end

local function checkTable(table, field)
    for _, value in ipairs(table) do
        if value == field then
            return true
        end
    end
    return false
end

local function getPermissions(user, permissions, bypassTable)
    if #permissions > 0 then
        local userPermissions = {}
        for _, permission in ipairs(permissions) do
            if user:hasPermission(permission) then
                if not permissions.requireAll then
                    return true
                else
                    table.insert(userPermissions, permission)
                end
            end
        end
        if #userPermissions < #permissions then
            return false
        end
    end
    return true
end

return function(discordia, client, message)
    if message.guild then
        local arguments = message.content:split(" ")
        if message.author ~= client.user and arguments[1]:startswith(client._configuration.prefix) then
            local commandName = arguments[1]:lower():sub(2)
            table.remove(arguments, 1)
            if client._commands[commandName] then
                if not client._cooldowns[message.guild.id] then
                    client._cooldowns[message.guild.id] = {} --//Initialize cooldown table for guilds.
                    for commandName in pairs(client._commands) do
                        client._cooldowns[message.guild.id][commandName] = {}
                    end
                end
                if not client._cooldowns[message.guild.id][commandName][message.author.id] then
                    if getPermissions(message.guild:getMember(message.author), client._commands[commandName].permissions)
                        and not client._commands[commandName].restricted
                        or checkTable(client._configuration.bypass, tostring(message.author.id)) then
                        client._cooldowns[message.guild.id][commandName][message.author.id] = true
                        timer.setTimeout(client._commands[commandName].cooldown * 1000, cooldown, client, commandName,
                            message.author.id,
                            message.guild.id)
                        client._commands[commandName]:execute(discordia, client, message, arguments)
                    else
                        message:reply(message.author.mentionString ..
                            ", You are lacking the appropriate permissions to run this command!")
                    end
                else
                    message:reply(message.author.mentionString .. ", A little too quick there.")
                end
            end
        end
    end
end
