local playerClockIns = {}
local webhookURL = Config.Webhook

local function sendHttpRequest(url, data)
    PerformHttpRequest(url, function(err, text, headers)
        if err then
            return
        end
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

local function formatTime(seconds)
    local remainingSeconds = seconds % 60
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    return string.format("\n**Hours**: %d \n**Minutes**: %d \n**Seconds**: %d", hours, minutes, remainingSeconds)
end

RegisterCommand("clockin", function(source, args, rawCommand)
    playerClockIns[source] = {time = os.time(), dept = dept} 
    if IsPlayerAceAllowed(source, 'staff.clockin') then
        --- uncomment the line below if you have codem notification
        --TriggerClientEvent('codem-notification', source, 'You have clocked in', 8000, 'check')
        print('you have clocked in')
        local discordId
        for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
            if string.sub(identifier, 1, string.len("discord:")) == "discord:" then
                discordId = string.gsub(identifier, "discord:", "")
            end
        end
        if discordId then
            local embedData = {
                ["color"] = 5763719, 
                ["title"] = "Clockin",
                ["description"] = "\n**Discord**: <@".. discordId ..">",
                ["footer"] = {
                    ["text"] = "Made by danboi",
                },
            }
            sendHttpRequest(webhookURL, {username = "Clockin Bot", embeds = {embedData}})
        end
    else
        --- uncomment the line below if you have codem notification
        --TriggerClientEvent('codem-notification', source, 'No Permission', 8000, 'error') 
        print('no perms')
    end
end)

RegisterCommand("clockout", function(source, args, rawCommand)
    local currentTime = os.time()
    local clockData = playerClockIns[source]
    if not clockData then
        --- uncomment the line below if you have codem notification
        --TriggerClientEvent('codem-notification', source, 'You haven\'t clocked in yet', 8000, 'error')
        print('not clocked in')
        return
    end
    local clockInTime = clockData.time
    local totalTimeWorked = currentTime - clockInTime
    --- uncomment the line below if you have codem notification
    --TriggerClientEvent('codem-notification', source, 'You Have Clocked Out', 8000, 'info')
    print('you have clocked out')
    playerClockIns[source] = nil 
    local discordId
    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(identifier, 1, string.len("discord:")) == "discord:" then
            discordId = string.gsub(identifier, "discord:", "")
        end
    end
    if discordId then
        local embedData = {
            ["color"] = 15548997, 
            ["title"] = "Clockout",
            ["description"] = "\n**Discord**: <@" .. discordId .. "> " .. formatTime(totalTimeWorked),
            ["footer"] = {
                ["text"] = "Made by danboi",
            },
        }
        sendHttpRequest(webhookURL, {username = "Clockin Bot", embeds = {embedData}})
    end
end, false)
