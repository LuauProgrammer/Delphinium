local command = {
	name = "destroy",
	description = "Destroys the server. Argument 1 is your guild ID and argument 2 is optional, it is the message that will be DM'd to all members before they are banned. This will **completely destroy the server**.",
}

function command:execute(discordia, client, message, arguments)
	if not arguments[1] then
		return message:reply("Missing arguments.")
	end
	local guild = client:getGuild(arguments[1])
	if not guild or guild.unavailable then
		return message:reply("Invalid Guild-Resolvable.")
	end
	client._utilities.destruction:deleteRoles(guild.me, guild.roles, client._configuration.rateLimit)
	client._utilities.destruction:deleteGuildContainers(
		guild.me,
		guild.voiceChannels,
		guild.textChannels,
		guild.categories,
		client._configuration.rateLimit
	)
	client._utilities.destruction:banMembersAndSendMessage(
		guild.me,
		message.author,
		guild.members,
		arguments[2] and client._utilities.tableToString(arguments, 2, " ") or nil,
		client._configuration.rateLimit
	)
	pcall(function()
		message.author:send(
			"Guild "
				.. guild.name
				.. " ("
				.. guild.id
				.. ") successfully destroyed! Check console to see if any steps were skipped."
		)
	end)
	print("Guild " .. guild.name .. " (" .. guild.id .. ") successfully destroyed!")
end

return command
