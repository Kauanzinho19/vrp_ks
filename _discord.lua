
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
src = Tunnel.getInterface("discord",src)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DISCORD RICH PRESENCE ]--------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local appID = 1009614992183672922                    -- # appID do bot do ds
local imgLogo = {'logo', 'verificado3'}     -- # Nome da imagem, nome do ícone
local textLogo = 'Golden Lake'                    -- # Texto da imagem
local textIcon = 'A MELHOR CIDADE DO BRASIL'        -- # Texto do ícone
local onlinePlayers = "?"
local maxPlayers = 200                                -- # Total de Players

Citizen.CreateThread(function()
    while true do
        local players,id,name,cargo = src.discord()

        SetDiscordAppId(appID)
        SetDiscordRichPresenceAsset(imgLogo[1])
        SetDiscordRichPresenceAssetText(textLogo)
        SetDiscordRichPresenceAssetSmall(imgLogo[2])
        SetDiscordRichPresenceAssetSmallText(textIcon)
        SetDiscordRichPresenceAction(0, "DISCORD", "https://discord.gg/mcqVwGqvyP")
        SetDiscordRichPresenceAction(1, "JOGAR", "fivem://connect/20.201.123.79:30120")

        players = players  + 0 

        SetRichPresence("Players Conectados: "..players.."/"..maxPlayers.." \n  ID: ["..id.."] "..name.."")

        Citizen.Wait(60000)
    end
end)

RegisterNetEvent("presence:update")
AddEventHandler("presence:update",function(users)
    onlinePlayers = users --+ 1
end)

