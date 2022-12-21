
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
src = {}
Tunnel.bindInterface("discord",src)

-----------------------------
--# DISCORD
-----------------------------
function src.discord()
    local source = source
    local user_id = vRP.getUserId(source)
    local name = ""

    if user_id then
        local identity = vRP.getUserIdentity(user_id)
        name = identity.name
    end


    local quantidade = 0
    local users = vRP.getUsers()

    for k,v in pairs(users) do
        quantidade = quantidade + 1
    end

    return parseInt(quantidade),user_id,name
end

