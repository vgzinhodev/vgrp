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
local registeredCommands = {}

function addClientCommand(cmd)
    if not registeredCommands[cmd] then 
        iprint("[VGRP] - Add a client command", cmd)

        addCommandHandler(cmd, function(cmd2, ...)
            triggerServerEvent(cmd, localPlayer, localPlayer, cmd2, ...)
        end)
        registeredCommands[cmd] = true 
    end
end
addEvent("vgrp:addClientCommand", true)
addEventHandler("vgrp:addClientCommand", getRootElement(), addClientCommand)

function newPlayer()
    setTimer(function()
        triggerServerEvent("vgrp:releasePendingCommand", localPlayer)
    end, (Cfg["Legacy"]["RefreshTime"] * 10000), Cfg["Legacy"]["RefreshAttempts"])
end
addEventHandler("onClientResourceStart", resourceRoot, newPlayer)

function removeClientCommand(cmd)
    if registeredCommands[cmd] then 
        iprint("[VGRP] - Remove a client command", cmd)
        removeCommandHandler(cmd)
        registeredCommands[cmd] = nil 
    end
end
addEvent("vgrp:removeClientCommand", true)
addEventHandler("vgrp:removeClientCommand", getRootElement(), removeClientCommand)