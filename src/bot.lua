--[[
    Author: LuauProgrammer
    Date: 10/2/2022
    Script: bot.lua
]]

--//Libraries

local json = require("json")
local discordia = require('discordia')
local fs = require("fs")

--//Variables

local configuration = assert(io.open("./config.json", "r"))
local client = discordia.Client { cacheAllMembers = true, largeThreshold = 4000 } --//4000 since I don't want the bot to perish.

--//Get all useful extensions

discordia.extensions()

--//Initialize client variables

client._configuration = json.decode(configuration:read("*all")) --//We can only use _configuration because for some reason it HAS to have a leading underscore.
client._utilities = {}
client._commands = {}

--//Load utilities

for _, fileName in ipairs(fs.readdirSync("./src/utilities")) do --//FS is weird and we have to do ./src/utilities
    if fileName:endswith(".lua") then --//Only get lua files.
        local noExtension = fileName:match("(.+)%..+$")
        assert(not client._commands[noExtension], "Duplicate utilities are not allowed.")
        client._utilities[noExtension] = require("./utilities/" .. fileName)
    end
end

--//Setup our handlers

for _, fileName in ipairs(fs.readdirSync("./src/handlers")) do
    if fileName:endswith(".lua") then --//Again, only get lua files.
        local module = require("./handlers/" .. fileName)
        local type = type(module)
        assert(type == "function", "Expected function, got " .. type)
        module(discordia, client) --//These should ALWAYS be functions and not a table.
    end
end


--//Finish everything up

configuration:close() --//Close our file.
client:run('Bot ' .. client._configuration.token, { status = "idle" })
