local QBCore = exports[Config.CoreName]:GetCoreObject()

QBCore.Functions.CreateCallback("rv_paychecks:server:GetPaycheckAmount", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local response = MySQL.query.await('SELECT * FROM players WHERE citizenid = @citizenid', {
        ["@citizenid"] = Player.PlayerData.citizenid
    })
    cb(response[1].paychecks)
end)

RegisterNetEvent('rv_paychecks:server:CollectPaycheck', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local response = MySQL.query.await('SELECT * FROM players WHERE citizenid = @citizenid', {
        ["@citizenid"] = Player.PlayerData.citizenid
    })
    local current = response[1].paychecks
    if current <= 0 then
        TriggerClientEvent('QBCore:Notify', src, Config.Messages.noneAvailable, 'error')
        return
    end
    Player.Functions.AddMoney('cash', current)
    TriggerClientEvent('QBCore:Notify', src, string.gsub(Config.Messages.collected, "amount", current), 'success')
    MySQL.Async.execute('UPDATE players SET paychecks = ? WHERE citizenid = ?', {
        0, Player.PlayerData.citizenid
    })
end)

RegisterNetEvent('rv_paychecks:server:GetPaycheck', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Config.RequireOnDuty and not Player.PlayerData.job.onduty then
        return
    end
    local response = MySQL.query.await('SELECT * FROM players WHERE citizenid = @citizenid', {
        ["@citizenid"] = Player.PlayerData.citizenid
    })
    local current = response[1].paychecks
    MySQL.Async.execute('UPDATE players SET paychecks = ? WHERE citizenid = ?', {
        current + Player.PlayerData.job.payment, Player.PlayerData.citizenid
    })
    TriggerClientEvent('QBCore:Notify', src, string.gsub(Config.Messages.paycheckAvailable, "amount", current + Player.PlayerData.job.payment), 'success')
end)