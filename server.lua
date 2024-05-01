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
        SendNotification(source, "You have clocked in.", "dispatch")
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
        SendNotification(source, "No Permission", "dispatch")
    end
end)

RegisterCommand("clockout", function(source, args, rawCommand)
    local currentTime = os.time()
    local clockData = playerClockIns[source]
    if not clockData then
        SendNotification(source, "You arent clocked in.", "dispatch")
        return
    end
    local clockInTime = clockData.time
    local totalTimeWorked = currentTime - clockInTime
    SendNotification(source, "You have clocked off", "dispatch")
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


function SendNotification(recipient, message, type)
    if Config.NotificationSystem == 0 then 
        if type == "dispatch" then 
            local type = "Dispatch"
            local message = "[ " .. type .. "] " .. message
            TriggerClientEvent('chat:addMessage', recipient, message)
        elseif type == "911" then 
            local message = "[ " .. type .. "] " .. message
            TriggerClientEvent('chat:addMessage', recipient, message)
        end
    elseif Config.NotificationSystem == 1 then 
        if type == "dispatch" then 
            TriggerClientEvent('okokNotify:Alert', recipient, 'Dispatch', message, 4500, 'info', true)
        elseif type == "911" then 
            TriggerClientEvent('okokNotify:Alert', recipient, '911', message, 7000, 'info', true)
        end
    elseif Config.NotificationSystem == 2 then 
        if type == "dispatch" then 
            TriggerClientEvent('codem-notification', recipient, message, 8000, 'check')
        elseif type == "911" then 
            TriggerClientEvent('codem-notification', recipient, message, 8000, 'check')
        end
    elseif Config.NotificationSystem == 3 then 
        if type == "dispatch" then 
            TriggerClientEvent('mythic_notify:client:SendAlert', recipient, { type = 'inform', text = message, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
        elseif type == "911" then 
            TriggerClientEvent('mythic_notify:client:SendAlert', recipient, { type = 'inform', text = message, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
        end
    end
end

