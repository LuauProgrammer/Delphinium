local command = {
    name = "botinfo",
    description = "Retrieves available client info.",
}

function command:execute(discordia, client, message, arguments)
    local embed = {
        title = "Bot Information for " .. client.user.username .. "#" .. client.user.discriminator,
        footer = { text = "Programmed by LuauProgrammer" },
        thumbnail = {
            url = client.user.avatarURL
        },
        fields = {
            {
                name = "Bot User ID",
                value = client.user.id,
                inline = true
            },
            {
                name = "Bot Owner",
                value = client.owner.name .. "#" .. client.owner.discriminator .. " (" .. client.owner.id .. ")",
                inline = true
            },
            {
                name = "Bot Uptime",
                value = math.round(os.clock()).." Seconds",
                inline = true
            },
            {
                name = "Guilds",
                value = client.guilds:count(),
                inline = true
            },
            {
                name = "DM Channels",
                value = client.privateChannels:count(),
                inline = true
            },
            {
                name = "Users",
                value = client.users:count(),
                inline = true
            },
            {
                name = "Shards managed by this client",
                value = client.shardCount or 0,
                inline = true
            },
            {
                name = "Total shard count",
                value = client.totalShardCount or 0,
                inline = true
            },
        }
    }
    message:reply({ embed = embed })
end

return command
