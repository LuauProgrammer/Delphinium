local command = {
	name = "dmmembers",
	description = "DMs all members a message. Argument 1 is your guild ID and argument 2 is the message that will be DM'd to all members before they are banned.",
}

function command:execute(discordia, client, message, arguments)
	if not arguments[1] or not arguments[2] then --//Guard clause
		return message:reply("Missing arguments.")
	end
	local guild = client:getGuild(arguments[1])
	if not guild or guild.unavailable then --//Guard clause
		return message:reply("Invalid Guild-Resolvable.")
	end
	client._utilities.destruction:sendMembersMessage(
		guild.me,
		message.author,
		guild.members,
		client._utilities.tableToString(arguments, 2, " ")
	)
	pcall(function() --//Protect the thread
		message.author:send(
			"Successfully DM'd all members in "
				.. guild.name
				.. " ("
				.. guild.id
				.. ")! Check console to see if any steps were skipped."
		)
	end)
	print("Successfully DM'd all members in Guild " .. guild.name .. " (" .. guild.id .. ")!")
end

return command
