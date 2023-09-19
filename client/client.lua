local QBCore = exports[Config.CoreName]:GetCoreObject()

Citizen.CreateThread(function()
    for k,v in pairs (Config.Locations) do 
        local blip = AddBlipForCoord(v.blip.coords)
        SetBlipSprite(blip, v.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, v.blip.scale)
        SetBlipColour(blip, v.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.name)
        EndTextCommandSetBlipName(LifeInvader)
        RequestModel(GetHashKey(v.ped.model))
        while not HasModelLoaded(GetHashKey(v.ped.model)) do
            Wait(1)
        end
        local ped = CreatePed(5, GetHashKey(v.ped.model), v.ped.coords, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
        exports['qb-target']:AddBoxZone('paycheck-' .. v.name, v.target.coords, 2.5, 2.6, {
            name = "paycheck-" .. v.name,
            heading = v.target.heading,
            debugPoly = false
        }, {
            options = {
                {
                    type = "client",
                    event = "rv_paychecks:client:PaycheckMenu",
                    icon = "fas fa-money-check-alt",
                    label = v.target.label
                }
            }
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = Config.PayCheckInterval *  60000
        Citizen.Wait(wait)
        TriggerServerEvent('rv_paychecks:server:GetPaycheck')
    end
end)

RegisterNetEvent('rv_paychecks:client:PaycheckMenu', function()
    local p = promise.new()
    local paycheckAmount = 0
    QBCore.Functions.TriggerCallback('rv_paychecks:server:GetPaycheckAmount', function(result)
        p:resolve(result)
    end)
    paycheckAmount = Citizen.Await(p)
    lib.registerContext({
        id = 'paycheck_menu',
        title = 'Life Invader',
        options = {
          {
            title = string.gsub(Config.Menu.title, "amount", paycheckAmount)
          },
          {
            title = Config.Menu.collect,
            description = Config.Menu.description,
            icon = Config.Menu.icon,
            onSelect = function()
                TriggerServerEvent('rv_paychecks:server:CollectPaycheck')
            end,
          }
        }
      })
    lib.showContext('paycheck_menu')

end)