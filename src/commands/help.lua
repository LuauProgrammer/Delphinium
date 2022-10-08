local command = {
    name = "help",
    description = "Get all command info.",
    category = "Misc",
    cooldown = 0,
    restricted = false,
    permissions = { requireAll = false }
}

local function tableToString(table)
    if #table > 0 then
        local string = table[1]
        for index, value in ipairs(table) do
            if index > 1 then
                string = string .. ", " .. value
            end
        end
        return string
    end
end

function command:execute(discordia, client, message, arguments)
    local categories = {}
    local embed = {
        title = "Bot Commands",
        fields = {},
        color = client._configuration.colors.bot
    }
    for _, commandModule in pairs(client._commands) do
        if not categories[commandModule.category] then
            categories[commandModule.category] = ""
        end
        local permissions = commandModule.permissions
        permissions.requireAll = nil
        permissions = #permissions > 0 and "\n**Permissions:** " .. tableToString(permissions) or ""
        categories[commandModule.category] = categories[commandModule.category] .. "\n\n**Name:** " ..
            commandModule.name ..
            "\n**Cooldown:** " ..
            commandModule.cooldown ..
            " Seconds" ..
            permissions .. "\n**Description:** " .. commandModule.description
    end
    for category, field in pairs(categories) do
        table.insert(embed.fields, {
            name = category,
            value = field,
            inline = false
        })
    end
    message:reply { embed = embed }
end

return command
