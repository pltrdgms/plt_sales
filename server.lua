local PLT = plt_sales

QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("plt_plants:plt_sales")
AddEventHandler("plt_plants:plt_sales", function(item,price,label)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local xitem = xPlayer.Functions.GetItemByName(item)
    if xitem then 
      local total = xitem.amount
      if total and total >= 1 then
        xPlayer.Functions.RemoveItem(item, total)
        xPlayer.Functions.AddMoney('bank', total*price)
        TriggerClientEvent('okokNotify:Alert', src, 'Title', total.." time "..label.." sell. "..(total*price).. "$ won.", 5000, 'type')
      else
          TriggerClientEvent('okokNotify:Alert', src, 'Title', 'Yo dont have item!', 5000, 'type')
      end
    else
      TriggerClientEvent('okokNotify:Alert', src, 'Title', 'Yo dont have item!', 5000, 'type')
    end

end)
