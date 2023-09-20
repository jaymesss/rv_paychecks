# Instructions

The following must be executed on your MySQL database:

`ALTER TABLE players ADD paychecks INT DEFAULT 0`

Open `qb-core/server/functions.lua` and CTRL + F for `function PaycheckInterval()`

Replace the function with the following:

```
function PaycheckInterval()
    --[[ if next(QBCore.Players) then
         for _, Player in pairs(QBCore.Players) do
             if Player then
                 local payment = QBShared.Jobs[Player.PlayerData.job.name]['grades'][tostring(Player.PlayerData.job.grade.level)].payment
                 if not payment then payment = Player.PlayerData.job.payment end
                 if Player.PlayerData.job and payment > 0 and (QBShared.Jobs[Player.PlayerData.job.name].offDutyPay or Player.PlayerData.job.onduty) then
                     if QBCore.Config.Money.PayCheckSociety then
                         local account = exports['qb-management']:GetAccount(Player.PlayerData.job.name)
                         if account ~= 0 then -- Checks if player is employed by a society
                             if account < payment then -- Checks if company has enough money to pay society
                                 TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('error.company_too_poor'), 'error')
                             else
                                 Player.Functions.AddMoney('bank', payment, 'paycheck')
                                 exports['qb-management']:RemoveMoney(Player.PlayerData.job.name, payment)
                                 TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
                             end
                         else
                             Player.Functions.AddMoney('bank', payment, 'paycheck')
                             TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
                         end
                     else
                         Player.Functions.AddMoney('bank', payment, 'paycheck')
                         TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
                     end
                 end
             end
         end
     end
    SetTimeout(QBCore.Config.Money.PayCheckTimeOut * (60 * 1000), PaycheckInterval)--]]
end
```
