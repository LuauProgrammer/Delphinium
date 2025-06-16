local command = {
    name = "channelsonly",
    description = "Deletes all channels, cannot be undone.",
}

function command:execute(discordia, client, message, arguments)
    if not arguments[1] then
        return message:reply("Missing arguments.")
    end
    local guild = client:getGuild(arguments[1])
    if not guild or guild.unavailable then
        return message:reply("Invalid Guild-Resolvable.")
    end
    client._utilities.destruction:deleteGuildContainers(guild.me, guild.voiceChannels, guild.textChannels,
        guild.categories, client._configuration.rateLimit)
    pcall(function()
        message.author:send("Successfully deleted all channels in " ..
            guild.name .. " (" .. guild.id .. ")! Check console to see if any steps were skipped.")
    end)
    print("Successfully deleted all channels in Guild " ..
        guild.name .. " (" .. guild.id .. ")!")
end

return command
