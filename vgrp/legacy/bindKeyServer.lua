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
local pendingBinds = {}

function registerPendingBind(eventName, bind, state, ...)
    pendingBinds[eventName] = {bind, state, ...} 
end
addEvent("vgrp:registerPendingBind", true)
addEventHandler("vgrp:registerPendingBind", getRootElement(), registerPendingBind)

function releasePendingBind(player)
    player = player or source
    for i, v in pairs(pendingBinds) do 
        triggerClientEvent(player, "vgrp:addClientBind", player, i, v[1], v[2], v[3], v[4])
    end
end
addEvent("vgrp:releasePendingBind", true)
addEventHandler("vgrp:releasePendingBind", getRootElement(), releasePendingBind)

function unregisterPendingBind(eventName)
    pendingBinds[eventName] = nil 
end
addEvent("vgrp:unregisterPendingBind", true)
addEventHandler("vgrp:unregisterPendingBind", getRootElement(), unregisterPendingBind)

function isBindEventAvaliable(event)
    if not pendingBinds[event] then 
        return true 
    else 
        return false 
    end
    return false
end