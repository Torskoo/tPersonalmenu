# Menu F5 FiveM - RageUI v2

Ce script FiveM propose un menu F5 entièrement configurable, conçu spécifiquement pour ESX Legacy. Le menu est optimisé pour une utilisation fluide avec une utilisation minimale du CPU (0.00ms). Veuillez noter que ce script est mis à disposition sans support, en cas de report de problème, veuillez me contacter sur Discord (Torskoo_), script toujours maintenu à jours.

## Configuration

### Activation/Désactivation des menus et configuration

Dans le fichier `config.lua`, vous pouvez activer ou désactiver les menus en ajustant les paramètres sous la section `Menu`. Par exemple, pour désactiver le menu d'inventaire, modifiez la valeur de `Main` sous `Inventaire` à `false`. De même, ajustez les paramètres d'autres menus selon vos préférences.

```lua
Menu = {
    Inventaire = {
        Affichage = {
            Main = true -- Afficher l'inventaire
        }
    },
    Armes = {
        Affichage = {
            Main = true,
            Animation = true
        },
        Animation = {
            Command = 'wam'
        }
    },
    Portefeuille = {
        Affichage = {
            Main = true,
            Papiers = true,
            Factures = true
        }
    },
    Vetements = {
        Affichage = {
            Main = true
        }
    },
    Vehicule = {
        Affichage = {
            Main = true
        }
    },
    Aide = {
        Affichage = {
            Main = true
        }
    },
    Color = {
        Premiere = '~b~',
        Deuxieme = '~y~'
    }
}```

### Personnalisation des touches d'aide

La section Aide du fichier de configuration contient des raccourcis clavier pour diverses fonctionnalités. Vous pouvez personnaliser ces raccourcis en modifiant les valeurs des touches, labels et descriptions.

```lua
Aide = {
    {
        Touche = "F1",
        Label = "Téléphone",
        Description = "Utiliser votre téléphone"
    },
    {
        Touche = "U",
        Label = "Ouvrir un véhicule",
        Description = "Ouvrir votre véhicule quand vous êtes assez proche"
    },
    {
        Touche = "J",
        Label = "Tomber par terre",
        Description = "Tomber par terre, rappuyer pour vous relever"
    },
    {
        Touche = "F6",
        Label = "Menu entreprises",
        Description = "Menu d'utilisation des entreprises"
    },
    {
        Touche = "F4",
        Label = "Menu animations",
        Description = "Vous aimez danser ?"
    },
    {
        Touche = "K",
        Label = "Mettre sa ceinture",
        Description = "Utilisez sa ceinture en voiture"
    },
    {
        Touche = "T",
        Label = "Chat",
        Description = "Ouvrez le chat pour y taper des commandes"
    }
}```

### Personnalisation avancée

Pour une personnalisation plus poussée, vous pouvez modifier les déclencheurs (trigger) et les noms des monnaies (money) dans le fichier server.lua. Cela vous permet de faire correspondre le script à d'autres frameworks ou modes de jeu que ESX Legacy.

**Avertissement** : Assurez-vous de comprendre le fonctionnement de ESX Legacy et du framework RageUI v2 avant de procéder à des modifications avancées.
