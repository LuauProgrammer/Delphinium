local command = {
    name = "guildinfo",
    description = "Retrieves guild info. First argument is the guild id.",
}

function command:execute(discordia, client, message, arguments)
    if not arguments[1] then
        return message:reply("Missing arguments.")
    end
    local guild = client:getGuild(arguments[1])
    if not guild or guild.unavailable then
        return message:reply("Invalid Guild-Resolvable.")
    end
    local owner = client:getUser(guild.ownerId)
    local embed = {
        title = "Guild Information for " .. guild.name,
        footer = { text = "Programmed by ツ ayden!!#0001" },
        thumbnail = guild.iconURL and {
            url = guild.iconURL
        } or nil,
        fields = {
            {
                name = "Guild ID",
                value = guild.id,
                inline = true
            },
            {
                name = "Guild Owner",
                value = owner.name .. "#" .. owner.discriminator .. " (" .. guild.ownerId .. ")",
                inline = true
            },
            {
                name = "Guild Description",
                value = guild.description or "None",
                inline = true
            },
            {
                name = "Nitro Level",
                value = "Level " .. guild.premiumTier,
                inline = true
            },
            {
                name = "Nitro Boosts",
                value = guild.premiumSubscriptionCount,
                inline = true
            },
            {
                name = "Members",
                value = guild.totalMemberCount,
                inline = true
            },
            {
                name = "Emojis",
                value = guild.emojis:count(),
                inline = true
            },
            {
                name = "Roles",
                value = guild.roles:count(),
                inline = true
            },
            {
                name = "Text Channels",
                value = guild.textChannels:count(),
                inline = true
            },
            {
                name = "Voice Channels",
                value = guild.voiceChannels:count(),
                inline = true
            },
            {
                name = "Categories",
                value = guild.categories:count(),
                inline = true
            },
            {
                name = "Vanity URL",
                value = guild.vanityCode and "[" .. guild.vanityCode ..
                    "](https://discord.gg/" .. guild.vanityCode .. ")" or "None",
                inline = true
            },
            {
                name = "Verification Level",
                value = discordia.enums.verificationLevel(guild.verificationLevel):upper(),
                inline = true
            },
            {
                name = "MFA Enabled",
                value = guild.mfaLevel > 0 and "Yes" or "No",
                inline = true
            },
            {
                name = "Explicit Content Setting",
                value = discordia.enums.explicitContentLevel(guild.explicitContentSetting):upper(),
                inline = true
            },
        }
    }
    message:reply({ embed = embed })
end

return command
