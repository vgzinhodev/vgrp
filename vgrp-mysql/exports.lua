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

function isDatabaseReady()
    return dbReady
end

function dbExecute(query, ...)
    if not dbReady then
        outputDebugString("[DATABASE] Tentativa de query sem conexão pronta: " .. query, 1)
        return false
    end

    local result = dbExec(dbConnection, query, ...)
    if not result then
        outputDebugString("[DATABASE] Erro ao executar query: " .. query, 1)
    end
    return result
end

function dbSelect(query, ...)
    if not dbReady then
        outputDebugString("[DATABASE] Tentativa de select sem conexão pronta: " .. query, 1)
        return {}
    end

    local qh = dbQuery(dbConnection, query, ...)
    local result = dbPoll(qh, -1)

    return result or {}
end