-- Script entièrement développer par Torskoo_ (Discord : Torskoo_)
-- Le menu est entièrement configurable et est disponible sans aucun support fourni.

ESX = exports["es_extended"]:getSharedObject()

local MenuOpen = false
-- Main Menu
local main_menu = RageUI.CreateMenu("Menu Personnel", Config.ServerName)
-- Sub Menu
local inv_menu = RageUI.CreateSubMenu(main_menu, "Inventaire", Config.ServerName)
local weapon_menu = RageUI.CreateSubMenu(main_menu, "Armes", Config.ServerName)
local wallet_menu = RageUI.CreateSubMenu(main_menu, "Portefeuille", Config.ServerName)
local clothes_menu = RageUI.CreateSubMenu(main_menu, "Vêtements", Config.ServerName)
local vehicle_menu = RageUI.CreateSubMenu(main_menu, "Véhicule", Config.ServerName)
local help_menu = RageUI.CreateSubMenu(main_menu, "Aide", Config.ServerName)
-- Action Menu inventaire
local action_inv_menu = RageUI.CreateSubMenu(inv_menu, "Inventaire", Config.ServerName)
local action_weapon_menu = RageUI.CreateSubMenu(weapon_menu, "Armes", Config.ServerName)
-- Action Menu portefeuille
local identity_wallet_menu = RageUI.CreateSubMenu(wallet_menu, "Mes papiers", Config.ServerName)
local billing_wallet_menu = RageUI.CreateSubMenu(wallet_menu, "Factures", Config.ServerName)
local billing = {}
-- Variable et tableau gestion du véhicule
local door = 1
local IndexDoor = {}
-- Variable et tableau gestion des vêtements
local clothes = 1
local IndexClothes = {}
-- Variable et tableau pour l'inventaire
local inv = 1 
local IndexInventaire = {}
local selectedOptions = {}



-- Menu Open / Close
main_menu.Closed = function ()
    MenuOpen = false
end
-- Ouvrir le menu (commande /menupersonnel)
RegisterKeyMapping("menupersonnel", "Ouvrir votre menu personel", "keyboard", "F5") -- Touche d'ouverture du menu



-- Menu RageUI
function OpenMenu()
    if not MenuOpen then
        function updateMoney()
            -- Récupère les infos du joueur à chaque ouverture du menu (optimisation)
            ESX.TriggerServerCallback('Torskoo_:valueCash',function(money)
                valueCash = money
            end)
            ESX.TriggerServerCallback('Torskoo_:valueblack_money',function(money)
                black_money = money
            end)
            -- Récupération des armes
            ESX.PlayerData = ESX.GetPlayerData()
            ESX.WeaponData = ESX.GetWeaponList()
            for i = 1, #ESX.WeaponData, 1 do
                if ESX.WeaponData[i].name == 'WEAPON_UNARMED' then
                    ESX.WeaponData[i] = nil
                else
                    ESX.WeaponData[i].hash = GetHashKey(ESX.WeaponData[i].name)
                end
            end
            -- Mises à jours des job
            job1 = ESX.PlayerData.job.label
            job1grade = ESX.PlayerData.job.grade_label
            job2 = ESX.PlayerData.job2.label
            job2grade = ESX.PlayerData.job2.grade_label
        end
        updateMoney()
        ESX.TriggerServerCallback('Torskoo_:getBills', function(bills)
            billing = bills
            ESX.PlayerData = ESX.GetPlayerData()
        end)
        
        MenuOpen = true
        RageUI.Visible(main_menu, true)
        while MenuOpen do
            -- Menu principale (main)
            RageUI.IsVisible(main_menu, function()
                if Config.Menu.Inventaire.Affichage.Main then
                    RageUI.Button('Inventaire', nil, { RightLabel = "→→"}, true, {onSelected = function() getInventory() end }, inv_menu)
                end
                if Config.Menu.Armes.Affichage.Main then
                    RageUI.Button("Armes", nil, {RightLabel = "→→"}, true, {onSelected = function() getInventory() end }, weapon_menu)
                end
                if Config.Menu.Portefeuille.Affichage.Main then
                    RageUI.Button("Portefeuille", nil, {RightLabel = "→→"}, true, {}, wallet_menu)
                end
                if Config.Menu.Vetements.Affichage.Main then
                    RageUI.Button("Vêtements", nil, {RightLabel = "→→"}, true, {}, clothes_menu)
                end
                if Config.Menu.Vehicule.Affichage.Main then
                    local ped = PlayerPedId()
                    local InVehicle = IsPedSittingInAnyVehicle(ped)
                    if InVehicle then     
                        RageUI.Button("Gestion véhicule", nil, {RightLabel = "→→"}, true, {}, vehicle_menu)
                    else
                        RageUI.Button("Gestion véhicule", "Vous devez vous trouver dans un véhicule pour le gérer", {RightLabel = "→→"}, false, {}, vehicle_menu)
                    end
                end
                if Config.Menu.Aide.Affichage.Main then
                    RageUI.Separator("__________________")
                    RageUI.Button("Aide (touches)", "Un doute sur les touches du serveur ? Tout est ici.", {RightLabel = "→→"}, true, {}, help_menu)
                end
                
            end)
            -- Menu d'inventaire
            RageUI.IsVisible(inv_menu, function()
                ESX.PlayerData = ESX.GetPlayerData()
                for k, v in pairs(ESX.PlayerData.inventory) do 
                    if v.count > 0 then 
                        if not selectedOptions[k] then
                            selectedOptions[k] = 1  -- Par défaut, sélectionnez "Utiliser"
                        end
                        RageUI.List("x" ..Config.Menu.Color.Premiere.. "" ..v.count.. " ~s~" ..v.label.."", {"Utiliser", "Donner"}, selectedOptions[k], nil, {}, true, {
                            onListChange = function(IndexInventaire) 
                                selectedOptions[k] = IndexInventaire
                            end,
                            onSelected = function(IndexInventaire)
                                local count = v.count 
                                local label  = v.label
                                local name = v.name
                                local remove = v.canRemove
            
                                if IndexInventaire == 1 then -- Utiliser
                                    TriggerServerEvent('esx:useItem', name)
                                    count = count - 1
                                    if count < 0 then 
                                        RageUI.GoBack()
                                    end
                                elseif IndexInventaire == 2 then -- Donner
                                    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
                                    if closestPlayer ~=-1 and closestPlayerDistance < 3.0 then
                                        local quantityString = KeyboardInput("Nombres d'items que vous voulez donner", '', 2)
                                        local quantity = tonumber(quantityString)
                                        if quantity then
                                            local closestPed = GetPlayerPed(closestPlayer)
                                            if IsPedOnFoot(closestPed) then
                                                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', name, quantity)
                                            else
                                                ESX.ShowNotification("Le montant est ~r~invalide ~s~!")
                                            end 
                                        else
                                            ESX.ShowNotification("Le montant est ~r~invalide ~s~!")
                                        end
                                    else
                                        ESX.ShowNotification("Il n'y a aucun joueur à ~r~proximité ~s~!")
                                    end
                                end
                            end
                        })
                    end
                end
            end)

            -- Menu d'armes
            RageUI.IsVisible(weapon_menu, function ()
                ESX.PlayerData = ESX.GetPlayerData()
                for i = 1, #ESX.WeaponData, 1 do
                    if HasPedGotWeapon(PlayerPedId(), ESX.WeaponData[i].hash, false) then
                        local ammo = GetAmmoInPedWeapon(PlayerPedId(), ESX.WeaponData[i].hash)
                        RageUI.Button("" ..ESX.WeaponData[i].label.. " [" ..Config.Menu.Color.Deuxieme..  ""..ammo.."~s~]", nil, { RightLabel = "Donner →→"}, true, {
                            onSelected = function()
                                ammoo = ammo 
                                name = ESX.WeaponData[i].name 
                                label = ESX.WeaponData[i].label
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)
                                    if IsPedOnFoot(closestPed) then
                                        TriggerServerEvent("esx:giveInventoryItem", GetPlayerServerId(closestPlayer), "item_weapon", name, nil)
                                    else
                                        ESX.ShowNotification('Le joueur ne doit pas se trouver dans un " ..Config.Menu.Color.Premiere..  "véhicule ~s~!')
                                    end
                                else
                                    ESX.ShowNotification("Il n'y a aucun joueur à ~r~proximité ~s~!")
                                end
                        end
                        })
                        
                    end
                end
                if Config.Menu.Armes.Affichage.Animation then
                    RageUI.Separator('__________________')
                    RageUI.Button("Changer l'animation d'arme", "Cliquez pour changer les animations", { RightLabel = "→→"}, true, {
                        onSelected= function()
                            ExecuteCommand(Config.Menu.Armes.Animation.Command)
                        end
                    })
                end
            end)
            -- Menus d'action armes
            RageUI.IsVisible(action_weapon_menu, function ()
                RageUI.Separator("Nom : " ..Config.Menu.Color.Deuxieme..  ""..tostring(label).." ~s~/ Balles : " ..Config.Menu.Color.Deuxieme..  ""..tostring(ammoo).."")
                RageUI.Button("Donner", nil, {RightLabel = "→→"}, true, {onSelected = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestDistance ~= -1 and closestDistance <= 3 then
                        local closestPed = GetPlayerPed(closestPlayer)
                        if IsPedOnFoot(closestPed) then
                            TriggerServerEvent("esx:giveInventoryItem", GetPlayerServerId(closestPlayer), "item_weapon", name, nil)
                            MenuOpen = false
                            RageUI.CloseAll()
                        else
                            ESX.ShowNotification('Le joueur ne doit pas se trouver dans un " ..Config.Menu.Color.Premiere..  "véhicule ~s~!')
                        end
                    else
                        ESX.ShowNotification("Il n'y a aucun joueur à ~r~proximité ~s~!")
                    end
                end})
            end)
            -- Menu du portefeuille
            RageUI.IsVisible(wallet_menu, function()
                -- Affichage des jobs du joueur
                RageUI.Separator("" ..Config.Menu.Color.Premiere..  "" ..job1.. " ~s~: " ..job1grade.. "")
                RageUI.Separator("" ..Config.Menu.Color.Deuxieme..  "" ..job2.. " ~s~: " ..job2grade.. "")

                local valueCash = "Liquide : " ..Config.Menu.Color.Deuxieme..  "" .. tostring(valueCash) .. "~s~ $"
                RageUI.Button(valueCash, nil, {RightLabel = "Donner →→"}, true, {onSelected = function()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestDistance ~= -1 and closestDistance <= 3 then
                        local quantityString = KeyboardInput("Combien d'argent voulez-vous donner ?", '', 10)
                        local quantity = tonumber(quantityString)
                        if quantity then
							local closestPed = GetPlayerPed(closestPlayer)
							if IsPedOnFoot(closestPed) then
								TriggerServerEvent('Torskoo_:giveCash', GetPlayerServerId(closestPlayer), quantity)
							else
								ESX.ShowNotification('Le joueur ne doit pas se trouver dans un " ..Config.Menu.Color.Premiere..  "véhicule ~s~!')
							end
                        else
                            ESX.ShowNotification("Le montant est ~r~invalide ~s~!")
                        end
					else
						ESX.ShowNotification("Il n'y a aucun joueur à ~r~proximité ~s~!")
					end
                end})                
                local black_money = "Argent sale : ~r~" .. tostring(black_money) .. "~s~ $"
                RageUI.Button(black_money, "Vous devez d'abbord blanchir cet argent avant de pouvoir en donner aux autres", {RightLabel = ""}, true, {})
                if Config.Menu.Portefeuille.Affichage.Papiers or Config.Menu.Portefeuille.Affichage.Factures then
                    RageUI.Separator("__________________")
                end
                if Config.Menu.Portefeuille.Affichage.Papiers then
                    RageUI.Button("Mes papiers", nil, {RightLabel = "→→"}, true, {}, identity_wallet_menu)
                end
                if Config.Menu.Portefeuille.Affichage.Factures then
                    RageUI.Button("Mes factures", nil, {RightLabel = "→→"}, true, {}, billing_wallet_menu)
                end
            end)
            -- Menu identitée du portefeuille
            RageUI.IsVisible(identity_wallet_menu, function()
                RageUI.Button("Regarder ma " ..Config.Menu.Color.Deuxieme..  "carte d'identitée", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                    end
                })
                RageUI.Button("Montrer ma " ..Config.Menu.Color.Premiere..  "carte d'identitée", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("Il n'y a aucun joueur à ~r~proximité ~s~!")
                        end
                    end
                })
                RageUI.Separator("__________________")
                RageUI.Button("Regarder mon " ..Config.Menu.Color.Deuxieme..  "permis de conduire", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                    end
                })
                RageUI.Button("Montrer mon " ..Config.Menu.Color.Premiere..  "permis de conuire", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
                        else
                            ESX.ShowNotification("Il n'y a aucun joueur à ~r~proximité ~s~!")
                        end
                    end
                })
                RageUI.Separator("__________________")
                RageUI.Button("Regarder mon " ..Config.Menu.Color.Deuxieme..  "permis port d'arme", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
                    end
                })
                RageUI.Button("Montrer mon " ..Config.Menu.Color.Premiere..  "permis port d'arme", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
                        else
                            ESX.ShowNotification("Il n'y a aucun joueur à ~r~proximité ~s~!")
                        end
                    end
                })
            end)
            RageUI.IsVisible(billing_wallet_menu, function ()
                if #billing == 0 then
                    RageUI.Separator("Aucune facture à votre nom")
                end
                for i = 1, #billing, 1 do
                    RageUI.Button(billing[i].label, nil, {RightLabel = '[' ..Config.Menu.Color.Deuxieme..  '$' .. ESX.Math.GroupDigits(billing[i].amount.."~s~] →")}, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback('esx_billing:payBill', function()
                                ESX.TriggerServerCallback('Torskoo_:getBills', function(bills) billing = bills end)
                            end, billing[i].id)
                        end
                    })
                end
            end)
            RageUI.IsVisible(clothes_menu, function()
                local plyPed = PlayerPedId()
                RageUI.List("Mettre / Retirer", {"Haut", "Pantalon", "Chaussures", "Sac"}, clothes, nil, {}, true, {
                    onListChange = function(IndexClothes) 
                        clothes = IndexClothes;
                    end,
                    onSelected = function(IndexClothes)
                        if IndexClothes == 1 then -- Haut
                            setUniform('torso', plyPed)
                        elseif IndexClothes == 2 then -- Pantalon
                            setUniform('pants', plyPed)
                        elseif IndexClothes == 3 then -- Chaussures
                            setUniform('shoes', plyPed)
                        elseif IndexClothes == 4 then -- Sac
                            setUniform('bag', plyPed)
                        end
                        ESX.ShowNotification('Vous venez de vous ~b~changer !')
                    end
                })
            end)
            RageUI.IsVisible(vehicle_menu, function()
                local ped = PlayerPedId()
                local vehicle = GetVehiclePedIsUsing(ped)
                local InVehicule = IsPedSittingInAnyVehicle(ped)
                local vehicle = GetVehiclePedIsUsing(ped)
                local vehicle_body_status = math.floor(GetVehicleBodyHealth(vehicle) / 10)
                local vehicle_engine_status = math.floor(GetVehicleEngineHealth(vehicle) / 10)
                if vehicle_engine_status < 0 then
                    vehicle_engine_status = 0
                end
                if InVehicule then
                    RageUI.Separator("Status de la carosserie : " ..Config.Menu.Color.Premiere.. "" ..vehicle_body_status.."")
                    RageUI.Separator("Status du moteur : " ..Config.Menu.Color.Deuxieme.. "" ..vehicle_engine_status.."")
                    RageUI.List("Ouvrir/Fermer", DoorSettings.Doors, door, nil, {}, true, {
                        onListChange = function(IndexDoor)
                            door = IndexDoor;
                        end,
                        onSelected = function(IndexDoor)
                            if IndexDoor == 1 then
                                if not DoorSettings.DoorsStatus.opennedBeforeDoorLeft then
                                    DoorSettings.DoorsStatus.opennedBeforeDoorLeft = true
                                    DoorSettings.DoorsStatus.closedBeforeDoorLeft = false
                                    SetVehicleDoorOpen(vehicle, 0, false, false)
                                elseif not closedBeforeDoorLeft then
                                    DoorSettings.DoorsStatus.closedBeforeDoorLeft = true
                                    DoorSettings.DoorsStatus.opennedBeforeDoorLeft = false
                                    SetVehicleDoorShut(vehicle, 0, false)
                                end
                            end

                            if IndexDoor == 2 then
                                if not DoorSettings.DoorsStatus.opennedBeforeDoorRight then
                                    DoorSettings.DoorsStatus.opennedBeforeDoorRight = true
                                    DoorSettings.DoorsStatus.closedBeforeDoorRight = false
                                    SetVehicleDoorOpen(vehicle, 1, false, false)
                                elseif not DoorSettings.DoorsStatus.closedBeforeDoorRight then
                                    DoorSettings.DoorsStatus.closedBeforeDoorRight = true
                                    DoorSettings.DoorsStatus.opennedBeforeDoorRight = false
                                    SetVehicleDoorShut(vehicle, 1, false)
                                end
                            end

                            if IndexDoor == 3 then
                                if not DoorSettings.DoorsStatus.opennedBackDoorLeft then
                                    DoorSettings.DoorsStatus.opennedBackDoorLeft = true
                                    DoorSettings.DoorsStatus.closedBackDoorLeft = false
                                    SetVehicleDoorOpen(vehicle, 2, false, false)
                                elseif not DoorSettings.DoorsStatus.closedBackDoorLeft then
                                    DoorSettings.DoorsStatus.closedBackDoorLeft = true
                                    DoorSettings.DoorsStatus.opennedBackDoorLeft = false
                                    SetVehicleDoorShut(vehicle, 2, false)
                                end
                            end

                            if IndexDoor == 4 then
                                if not DoorSettings.DoorsStatus.opennedBackDoorRight then
                                    DoorSettings.DoorsStatus.opennedBackDoorRight = true
                                    DoorSettings.DoorsStatus.closedBackDoorRight = false
                                    SetVehicleDoorOpen(vehicle, 3, false, false)
                                elseif not DoorSettings.DoorsStatus.closedBackDoorRight then
                                    DoorSettings.DoorsStatus.closedBackDoorRight = true
                                    DoorSettings.DoorsStatus.opennedBackDoorRight = false
                                    SetVehicleDoorShut(vehicle, 3, false)
                                end 
                            end

                            if IndexDoor == 5 then
                                if not DoorSettings.DoorsStatus.opennedCapot then
                                    DoorSettings.DoorsStatus.opennedCapot = true
                                    DoorSettings.DoorsStatus.closedCapot = false
                                    SetVehicleDoorOpen(vehicle, 4, false, false)
                                elseif not closedCapot then
                                    DoorSettings.DoorsStatus.closedCapot = true
                                    DoorSettings.DoorsStatus.opennedCapot = false
                                    SetVehicleDoorShut(vehicle, 4, false)
                                end 
                            end

                            if IndexDoor == 6 then
                                if not DoorSettings.DoorsStatus.opennedCoffre then
                                    DoorSettings.DoorsStatus.opennedCoffre = true
                                    DoorSettings.DoorsStatus.closedCoffre = false
                                    SetVehicleDoorOpen(vehicle, 5, false, false)
                                elseif not DoorSettings.DoorsStatus.closedCoffre then
                                    DoorSettings.DoorsStatus.closedCoffre = true
                                    DoorSettings.DoorsStatus.opennedCoffre = false
                                    SetVehicleDoorShut(vehicle, 5, false)
                                end 
                            end
                        end
                    })
                else 
                    RageUI.Separator("Vous n'êtes pas dans un véhicule")
                end
            end)
            RageUI.IsVisible(help_menu, function()
                for _, item in ipairs(Config.Aide) do
                    RageUI.Button(item.Label, item.Description, {RightLabel = item.Touche}, true, {})
                end
            end)
            Wait(1)
            
        end
    end
end


-- Fonctions du menu
function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(0, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(1.0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        return result
    else
        Wait(500)
        return nil
    end
end


-- Fonctions du changement de vêtements
function setUniform(value, plyPed)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:getSkin', function(skina)
			if value == 'torso' then
				if skin.torso_1 ~= skina.torso_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
				end
			elseif value == 'pants' then
				if skin.pants_1 ~= skina.pants_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 61, ['pants_2'] = 1})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})
					end
				end
			elseif value == 'shoes' then
				if skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 34, ['shoes_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 35, ['shoes_2'] = 0})
					end
				end
			elseif value == 'bag' then
				if skin.bags_1 ~= skina.bags_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			end
		end)
	end)
end

function getInventory()   
	ESX.TriggerServerCallback('Torskoo_:getInventory', function(object)
		inventaire = object
	end)
end

-- Ouverture du menu
RegisterCommand("menupersonnel", function() 
    OpenMenu()
end)

