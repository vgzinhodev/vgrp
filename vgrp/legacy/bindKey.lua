--[[
 __      __   _______       _            ____               _____ _                 
 \ \    / /  |___  (_)     | |          / __ \             / ____| |                
  \ \  / /_ _   / / _ _ __ | |__   ___ | |  | | ___       | (___ | |_ ___  _ __ ___ 
   \ \/ / _` | / / | | '_ \| '_ \ / _ \| |  | |/ _ \       \___ \| __/ _ \| '__/ _ \
    \  / (_| |/ /__| | | | | | | | (_) | |__| | (_) |      ____) | || (_) | | |  __/
     \/ \__, /_____|_|_| |_|_| |_|\___/ \____/ \___/      |_____/ \__\___/|_|  \___|
         __/ |                                                                      
        |___/                                                                       

Caso tenha dúvidas consulte: 
Discord: https://discord.gg/NjeRXA475g
Documentação para este script: https://docs.vgzinhostore.com
]]
local registeredBinds = {}

function addClientBind(eventName, bind, state, ...)
    if not registeredBinds[eventName] then 
        iprint("[VGRP] - Add a client Bind", eventName)

        local handlerFunc = function(_, _, ...)
            triggerServerEvent(eventName, localPlayer, localPlayer, bind, state, ...)
        end

        bindKey(bind, state, handlerFunc, ...)
        registeredBinds[eventName] = {bind = bind, state = state, handler = handlerFunc} 
    end
end
addEvent("vgrp:addClientBind", true)
addEventHandler("vgrp:addClientBind", getRootElement(), addClientBind)

function removeClientBind(eventName, bind, state)
    local entry = registeredBinds[eventName]
    if entry then 
        iprint("[VGRP] - Remove a client Bind", eventName)
        unbindKey(entry.bind, entry.state, entry.handler)
        registeredBinds[eventName] = nil 
    end
end
addEvent("vgrp:removeClientBind", true)
addEventHandler("vgrp:removeClientBind", getRootElement(), removeClientBind)

function newPlayer()
    setTimer(function()
        iprint("[VGRP] - Check Pending Binds")
        triggerServerEvent("vgrp:releasePendingBind", localPlayer)
    end, (Cfg["Legacy"]["RefreshTime"] * 10000), Cfg["Legacy"]["RefreshAttempts"])
end
addEventHandler("onClientResourceStart", resourceRoot, newPlayer)