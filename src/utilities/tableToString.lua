return function(table, ignore, separator)
    separator = separator or " "
    if #table > 0 then
        local string = table[ignore]
        for index, value in ipairs(table) do
            if index > ignore then
                string = string .. separator .. value
            end
        end
        return string
    end
end
