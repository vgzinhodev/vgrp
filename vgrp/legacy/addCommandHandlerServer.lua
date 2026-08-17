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
local pendingCommands = {}

function registerPendingCommand(cmd)
    pendingCommands[cmd] = true 
end
addEvent("vgrp:registerPendingCommand", true)
addEventHandler("vgrp:registerPendingCommand", getRootElement(), registerPendingCommand)

function releasePendingCommand(player)
    player = player or source
    for i, v in pairs(pendingCommands) do 
        triggerClientEvent(player, "vgrp:addClientCommand", player, i)
    end
end
addEvent("vgrp:releasePendingCommand", true)
addEventHandler("vgrp:releasePendingCommand", getRootElement(), releasePendingCommand)

function unregisterPendingCommand(cmd)
    pendingCommands[cmd] = nil 
end
addEvent("vgrp:unregisterPendingCommand", true)
addEventHandler("vgrp:unregisterPendingCommand", getRootElement(), unregisterPendingCommand)