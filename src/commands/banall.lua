local command = {
    name = "banall",
    description = "Bans all members and DMs them a message. Argument 1 is your guild ID and argument 2 is optional, it is the message that will be DM'd to all members before they are banned.",
}

function command:execute(discordia, client, message, arguments)
    if not arguments[1] then
        return message:reply("Missing arguments.")
    end
    local guild = client:getGuild(arguments[1])
    if not guild or guild.unavailable then
        return message:reply("Invalid Guild-Resolvable.")
    end
    client._utilities.destruction:banMembersAndSendMessage(guild.me, message.author, guild.members,
        arguments[2] and client._utilities.tableToString(arguments, 2, " ") or nil, client._configuration.rateLimit)
    pcall(function()
        message.author:send("Successfully banned all members in " ..
            guild.name .. " (" .. guild.id .. ")! Check console to see if any steps were skipped.")
    end)
    print("Successfully banned all members in Guild " ..
        guild.name .. " (" .. guild.id .. ")!")
end

return command
