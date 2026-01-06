local QBCore = exports['qb-core']:GetCoreObject()
local recentlyHit = false
local blackout = false


local timeTillTurnOn = Config.BlackoutTime
local coolDownTime = Config.Cooldown


local boxModel = CreateObjectNoOffset( 
GetHashKey("reh_prop_reh_b_computer_04a"),
713.9,
160.55,
79.75,
true,
false,
false
)
FreezeEntityPosition(boxModel, true)
SetEntityHeading(boxModel, 239.98)

--// Events
RegisterNetEvent("ss-blackout:blackout", function()
    if blackout == false then
        if recentlyHit == false then

            blackout = true
            SetEntityCoords(boxModel, 713.9, 160.55, 30.0, true, true, false, false)
            TriggerClientEvent("ss-blackout:enterbox", source)

            Citizen.Wait(17000)
            SetEntityCoords(boxModel, 713.9, 160.55, 79.75, true, true, false, false)

            TriggerEvent("ss-blackout:blackouton")
        
        else
            TriggerClientEvent("ss-blackout:recentlyhitnotification", source)
        end
    else
        TriggerClientEvent("ss-blackout:blackoutactivenotification", source)
    end

    Citizen.Wait(Config.BlackoutTime)

    blackout = false
    TriggerEvent("ss-blackout:blackoutoff")

    recentlyHit = true
    Citizen.Wait(Config.Cooldown)
    recentlyHit = false
end)

RegisterNetEvent("ss-blackout:blackouton", function()
    exports["qb-weathersync"]:setBlackout(true)
end)

RegisterNetEvent("ss-blackout:blackoutoff", function()
    exports["qb-weathersync"]:setBlackout(false)
end)

RegisterCommand('blackoutactive', function(source)
    if source ~= 0 and not IsPlayerAceAllowed(source, 'ss.blackout.active') then
        TriggerClientEvent('QBCore:Notify', source, 'No permission', 'error')
        return
    end

    if blackout then
        if source ~= 0 then
            TriggerClientEvent('QBCore:Notify', source, 'Blackout already active', 'error')
        end
        return
    end

    blackout = true
    recentlyHit = false

    TriggerEvent('ss-blackout:blackouton')

    if source ~= 0 then
        TriggerClientEvent('QBCore:Notify', source, 'Blackout activated', 'success')
    end
end, false)

RegisterCommand('blackoutrestore', function(source)
    if source ~= 0 and not IsPlayerAceAllowed(source, 'ss.blackout.restore') then
        TriggerClientEvent('QBCore:Notify', source, 'No permission', 'error')
        return
    end

    if not blackout then
        if source ~= 0 then
            TriggerClientEvent('QBCore:Notify', source, 'Blackout is not active', 'error')
        end
        return
    end

    blackout = false
    recentlyHit = false

    TriggerEvent('ss-blackout:blackoutoff')

    if source ~= 0 then
        TriggerClientEvent('QBCore:Notify', source, 'Blackout restored (lights on)', 'success')
    end
end, false)
