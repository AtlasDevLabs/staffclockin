local playerClockIns = {}

RegisterCommand("clockin", function(source, args, rawCommand)
    playerClockIns[source] = {time = os.time(), dept = dept} 
    if IsPlayerAceAllowed(source, Config.AcePerm) then
        SendNotification(source, "You have clocked in.", 'success')
        local discordId
        for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
            if string.sub(identifier, 1, string.len("discord:")) == "discord:" then
                discordId = string.gsub(identifier, "discord:", "")
            end
        end
        if discordId then
            local webhookURL = Config.Webhook
            local embedData = {
                ["color"] = 5763719, 
                ["title"] = "Clockin",
                ["description"] = "\n**Discord**: <@".. discordId ..">",
                ["footer"] = {
                    ["text"] = "Atlas Development - 2024",
                },
            }
            sendHttpRequest(webhookURL, {username = "Staff Clockin", embeds = {embedData}})
        end
    else
        SendNotification(source, "No Permission", 'error')
    end
end)

RegisterCommand("clockout", function(source, args, rawCommand)
    local currentTime = os.time()
    local clockData = playerClockIns[source]
    if not clockData then
        SendNotification(source, "You arent clocked in.", 'error')
        return
    end
    local clockInTime = clockData.time
    local totalTimeWorked = currentTime - clockInTime
    SendNotification(source, "You have clocked out.", 'error')
    playerClockIns[source] = nil 
    local discordId
    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(identifier, 1, string.len("discord:")) == "discord:" then
            discordId = string.gsub(identifier, "discord:", "")
        end
    end
    if discordId then
        local webhookURL = Config.Webhook
        local embedData = {
            ["color"] = 15548997, 
            ["title"] = "Clockout",
            ["description"] = "\n**Discord**: <@" .. discordId .. "> " .. formatTime(totalTimeWorked),
            ["footer"] = {
                ["text"] = "Atlas Development - 2024",
            },
        }
        sendHttpRequest(webhookURL, {username = "Staff Clockin", embeds = {embedData}})
    end
end, false)
