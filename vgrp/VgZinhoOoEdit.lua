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

Cfg = {
    ["Legacy"] = {
        ["RefreshTime"] = 1, -- Tempo em minutos para dar refresh nas funções legacy (addCommandHandler, bindKey)
        ["RefreshAttempts"] = 5, -- Tentativas iniciais para dar refresh nas funções legacy (addCommandHandler, bindKey)
    }
}

function notify(player, msg, type)
    if localPlayer then 
        return exports["s_infobox"]:addIncInfobox(msg, type)
    else 
        return exports["s_infobox"]:addInsInfobox(player, msg, type)
    end
end