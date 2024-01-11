-- Script entièrement développer par Torskoo_ (Discord : Torskoo_)
-- Le menu est entièrement configurable et est disponible sans aucun support fourni.

ESX = exports["es_extended"]:getSharedObject()


-- Mettre les item de l'inventaire dans une table dédiée.
ESX.RegisterServerCallback('Torskoo_:getInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local objects = xPlayer.inventory
    local inventoryTable = {}
    for k, v in pairs(objects) do
        if v.count > 0 then
            table.insert(inventoryTable, {label = v.label, item = v.name, nb = v.count})
        end
    end
    cb(inventoryTable)
end)

-- Récupérer l'argent en cash du joueur
ESX.RegisterServerCallback("Torskoo_:valueCash", function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local valueCash = xPlayer.getAccount('money').money
	cb(valueCash)
end)
-- Récupérer l'argent sale en en cash du joueur
ESX.RegisterServerCallback("Torskoo_:valueblack_money", function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local black_money = xPlayer.getAccount('black_money').money
	cb(black_money)
end)

-- Donner de l'argent (de joueur en joueur)
RegisterServerEvent('Torskoo_:giveCash')
AddEventHandler('Torskoo_:giveCash', function(targetPlayerId, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(targetPlayerId)
    if xPlayer and targetXPlayer then
        if amount > 0 and xPlayer.getAccount('money').money >= amount then
            xPlayer.removeAccountMoney('money', amount)
            targetXPlayer.addAccountMoney('money', amount)

            TriggerClientEvent('esx:showNotification', _source, 'Vous avez envoyé ~y~' ..amount.. '~s~$')
            TriggerClientEvent('esx:showNotification', targetPlayerId, 'Vous avez reçu ~y~' ..amount.. '~s~$')
        else
            TriggerClientEvent('esx:showNotification', _source, 'Montant invalide ou fonds insuffisants.')
        end
    end
end)

ESX.RegisterServerCallback('Torskoo_:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}
		for i = 1, #result do
			bills[#bills + 1] = {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			}
		end
		cb(bills)
	end)
end)





