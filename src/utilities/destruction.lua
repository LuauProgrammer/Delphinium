local destruction = {}

local timer = require("timer")

local function deleteAbstractGuildContainer(container) --//Generic container deleter. Works for most guild channels
	xpcall(function()
		if container:delete() then
			print("Successfully deleted guild container " .. container.name .. " (" .. container.id .. ")")
		end
	end, function(error)
		print("An error occured whilst deleting a container\n" .. error)
	end)
end

function destruction:deleteRoles(clientMember, roles, rateLimit) --//Deletes a defined set of roles
	if not clientMember:hasPermission("manageRoles") then --//Make sure the bot has the permissions to change role data.
		print("Lacking permission 'manageRoles', skipping step.")
		return false
	end
	roles:forEach(function(role) --//Loop thru roles
		xpcall(function()
			if role.managed then --//Basic checks
				return print("Role is managed by an integration, cannot delete.")
			end
			if role.position == 0 then
				return print("Role is position 0, cannot delete.")
			end
			if clientMember.highestRole.position <= role.position then --//Can't delete roles above us
				return print(
					"Role position ("
						.. role.position
						.. ") is higher or equal to the bots highest role positon ("
						.. clientMember.highestRole.position
						.. "), cannot delete."
				)
			end
			if role:delete() then
				print("Successfully deleted role " .. role.name .. " (" .. role.id .. ")")
			end
			if rateLimit > 0 then --//Ratelimiter
				timer.sleep(rateLimit * 1000)
			end
		end, function(error)
			print("An error occured whilst deleting a role\n" .. error)
		end)
	end)
	print("Roles successfully deleted!")
	return true
end

function destruction:deleteGuildContainers(clientMember, voiceChannels, textChannels, categories, rateLimit)
	if not clientMember:hasPermission("manageChannels") then
		print("Lacking permission 'manageChannels', skipping step.")
		return false
	end
	textChannels:forEach(deleteAbstractGuildContainer)
	voiceChannels:forEach(deleteAbstractGuildContainer)
	categories:forEach(deleteAbstractGuildContainer)
	print("Guild containers successfully deleted!")
	return true
end

function destruction:banMembersAndSendMessage(clientMember, authorMember, members, message, rateLimit)
	if not clientMember:hasPermission("banMembers") then
		print("Lacking permission 'banMembers', skipping step.")
		return false
	end
	members:forEach(function(member)
		xpcall(function()
			if member == clientMember or member.user == authorMember then
				return
			end
			if message then
				pcall(function()
					member.user:send(message)
				end)
			end
			if clientMember.highestRole.position <= member.highestRole.position then
				return print(
					"Role position ("
						.. member.highestRole.position
						.. ") is higher or equal to the bots highest role positon ("
						.. clientMember.highestRole.position
						.. "), cannot ban member."
				)
			end
			if member:ban() then
				print(
					"Successfully banned member "
						.. member.user.name
						.. "#"
						.. member.user.discriminator
						.. " ("
						.. member.user.id
						.. ")"
				)
			end
			if rateLimit > 0 then
				timer.sleep(rateLimit * 1000)
			end
		end, function(error)
			print("An error occured whilst banning a member\n" .. error)
		end)
	end)
	print("Members successfully banned!")
	return true
end

function destruction:sendMembersMessage(clientMember, authorMember, members, message, rateLimit)
	members:forEach(function(member)
		xpcall(function()
			if member == clientMember or member.user == authorMember then
				return
			end
			pcall(function()
				member.user:send(message)
			end) --//no rate limit as theres no way a bot can detect it
		end, function(error)
			print("An error occured whilst DMing a member\n" .. error)
		end)
	end)
	print("Members successfully DM'd!")
	return true
end

return destruction
