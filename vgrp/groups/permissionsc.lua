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
addCommandHandler("group", function(_, targetID, groupName)
    if not targetID or not groupName then
        infoBoxC(localPlayer, "Uso correto: /setgroup <ID> <Grupo>", "info")
        return
    end
    
    triggerServerEvent("setPlayerGroup", localPlayer, targetID, groupName)
end)

addCommandHandler("remgroup", function(_, targetID, groupName)
    if not targetID or not groupName then
        infoBoxC(localPlayer, "Uso correto: /remgroup <ID> <Grupo>", "info")
        return
    end
    
    triggerServerEvent("removePlayerGroup", localPlayer, targetID, groupName)
end)

addCommandHandler("vgroups", function(_, targetID)
    triggerServerEvent("listPlayerGroups", localPlayer, targetID)
end)

function infoBoxC(player, msg, type)
    return exports["s_infobox"]:addIncInfobox(msg, type)
end