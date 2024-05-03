lib.registerMenu({
    id = 'clock_menu',
    title = 'Clock Menu',
    position = 'top-right',
    options = {
        {label = 'Clock In', description = 'Clock into Staff', args = {clockin = 'clock_in'}},
        {label = 'Clock Out', description = 'Clockout of Staff', args = {clockout = 'clock_out'}},
    },
}, function(selected, scrollIndex, args)
    if args.clockin == 'clock_in' then
        TriggerServerEvent('atlas:staffclockin:clockIn')
    elseif args.clockout == 'clock_out' then
        TriggerServerEvent('atlas:staffclockout:clockOut')
    end
end)

RegisterCommand('clockin', function()
    lib.showMenu('clock_menu')
end)

local keybind = lib.addKeybind({
    name = 'StaffClockin',
    description = 'Staff Clockin Keybind',
    defaultKey = Config.Keybind,
    onPressed = function()
        lib.showMenu('clock_menu')
    end,
})

TriggerEvent('chat:addSuggestion', '/clockin', 'Open the clockin menu!')
