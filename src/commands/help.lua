local command = {
    name = "help",
    description = "Get all command info.",
}

function command:execute(discordia, client, message, arguments)
    local embed = {
        title = "Bot Commands",
        fields = {},
        footer = { text = "Programmed by LuauProgrammer" }
    }
    for name, commandModule in pairs(client._commands) do
        table.insert(embed.fields, {
            name = name,
            value = commandModule.description,
            inline = true,
        })
    end
    message:reply { embed = embed }
end

return command
