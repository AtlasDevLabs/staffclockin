local playerClockIns = {}

RegisterNetEvent('atlas:staffclockin:clockIn')
AddEventHandler('atlas:staffclockin:clockIn', function()
local source = source
playerClockIns[source] = {time = os.time()} 
    local discordId
    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(identifier, 1, string.len("discord:")) == "discord:" then
            discordId = string.gsub(identifier, "discord:", "")
        end
    end
    SendNotification(source, Config.ClockinMessage, 'success')
    if discordId then
        local webhookURL = Config.Webhook
        local embedData = {
            ["color"] = 5763719, 
            ["title"] = "Clockin",
            ["description"] = "\n**Discord**: <@".. discordId ..">",
            ["footer"] = {
                ["text"] = "Atlas Dev Labs - 2024",
            },
        }
        sendHttpRequest(webhookURL, {username = username, embeds = {embedData}})
    end
end)

RegisterNetEvent('atlas:staff:clockOut')
AddEventHandler('atlas:staff:clockOut', function() 
    local source = source
    local currentTime = os.time()
    local clockData = playerClockIns[source]
    if not clockData then
        SendNotification(source, "You aren't clocked in.", 'error') 
        return
    end
    local clockInTime = clockData.time
    local totalTimeWorked = currentTime - clockInTime
    playerClockIns[source] = nil 
    local discordId
    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(identifier, 1, string.len("discord:")) == "discord:" then
            discordId = string.gsub(identifier, "discord:", "")
        end
    end
    SendNotification(source, Config.ClockoutMessage, 'error')
    if discordId then
        local webhookURL = Config.Webhook
        local embedData = {
            ["color"] = 15548997, 
            ["title"] = "Clockout",
            ["description"] = "\n**Discord**: <@" .. discordId .. "> " .. formatTime(totalTimeWorked), 
            ["footer"] = {
                ["text"] = "Atlas Dev Labs - 2024",
            },
        }
        sendHttpRequest(webhookURL, {username = username, embeds = {embedData}})
    end
end)
