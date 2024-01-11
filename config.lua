-- Script entièrement développer par Torskoo_ (Discord : Torskoo_)
-- Le menu est entièrement configurable et est disponible sans aucun support fourni.

Config = {
    ServerName = "Fantaisie", -- Nom du serveur (pour les descriptions des menus)
    Menu = { -- Choix de l"affichage des menus
        Inventaire = { -- Paramètres menu d'inventaire
            Affichage = {
                Main = true -- Afficher l'inventaire
            }
        },
        Armes = { -- Paramètres menu d'arme
            Affichage = {
                Main = true, -- Afficher les armes
                Animation = true -- Afficher le bouton pour changer d'animation d'armes
            },
            Animation = {
                Command = 'wam' -- Commande du menu d'animations d'armes
            }
        },
        Portefeuille = { -- Paramères menu portefeuille
            Affichage = {
                Main = true, -- Afficher le portefeuille
                Papiers = true, -- Afficher le sous-menu de la gestion des papier
                Factures = true -- Afficher le sous-menu de la gestion des factures (voir et payer)
            }
        },
        Vetements = { -- Paramètres menu vêtements
            Affichage = {
                Main = true -- Afficher le menu des vêtements
            }
        },
        Vehicule = { -- Paramètres menu véhicule
            Affichage = {
                Main = true -- Afficher le menu de la gestion des véhicules
            }
        },
        Aide = { -- Paramètres menu aide
            Affichage = {
                Main = true -- Afficher le menu de la gestion des véhicules
            }
        },
        Color = {
            Premiere = '~b~', -- Couleur principal du menu (~b~ = bleu)
            Deuxieme = '~y~' -- Couleur secondaire du menu (~y~ = jaune)
        }
    },
    Aide = {
        {
            Touche="F1", 
            Label="Téléphone", 
            Description="Utiliser votre téléphone"
        },{
            Touche="U", 
            Label="Ouvrir un véhicule", 
            Description="Ouvrir votre véhicule quand vous êtes assez proche"
        },{
            Touche="J", 
            Label="Tomber par terre", 
            Description="Tomber par terre, rappuyer pour vous relever"
        },{
            Touche="F6", 
            Label="Menu entreprises", 
            Description="Menu d'utilisation des entreprises"
        },{
            Touche="F4", 
            Label="Menu animations", 
            Description="Vous aimez danser ?"
        },{
            Touche="K", 
            Label="Mettre sa ceinture", 
            Description="Utilisez sa ceinture en voiture"
        },{
            Touche="T", 
            Label="Chat", 
            Description="Ouvrez le chat pour y taper des commandes"
        }
    }
}

DoorSettings = { -- Ne pas toucher (sauf pour renommer le nom des éventuels portes)
    Doors = {
        {Name = "Portière avant gauche", Value = 1},
        {Name = "Portière avant droit", Value = 2},
        {Name = "Portière arrière gauche", Value = 3},
        {Name = "Portière arrière droit", Value = 4},
        {Name = "Capot", Value = 5},
        {Name = "Coffre", Value = 6}
    },
    DoorsStatus = {
        opennedBeforeDoorLeft = false,
        closedBeforeDoorLeft = true,
        opennedBeforeDoorRight = false,
        closedBeforeDoorRight = true,
        opennedBackDoorLeft = false,
        closedBackDoorLeft = true,
        opennedBackDoorRight = false,
        closedBackDoorRight = true,
        opennedCapot = false,
        closedCapot = true,
        opennedCoffre = false,
        closedCoffre = true,
    }
}