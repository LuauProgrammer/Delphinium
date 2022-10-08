local command = {
    name = "ping",
    description = "Ping Pong!",
    category = "Utilities",
    cooldown = 0,
    restricted = false,
    permissions = { requireAll = false, }
}

function command:execute(discordia, client, message, arguments)
    message:reply("Pong!")
end

return command
