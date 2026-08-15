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


dbConnection = nil
dbReady = false

local function connectMySQL()
    return dbConnect("mysql",
        "dbname="..Cfg["Geral"]["Database"]..";host="..Cfg["Geral"]["Host"]..";port="..Cfg["Geral"]["Port"]..";charset=utf8mb4",
        Cfg["Geral"]["User"], Cfg["Geral"]["Password"],
        "autoreconnect=1;use_ssl=0"
    )
end

local function connectSQLite()
    return dbConnect("sqlite",
        "vgrp.db",
        "autoreconnect=1"
    )
end

addEventHandler("onResourceStart", resourceRoot, function()
    local tipo = string.lower(Cfg["Geral"]["Tipo"] or "mysql")

    if tipo == "mysql" then
        dbConnection = connectMySQL()
    elseif tipo == "sqlite" then
        dbConnection = connectSQLite()
    else
        outputDebugString("[DATABASE] Tipo de banco inválido em Cfg.Geral.Tipo: '"..tostring(Cfg["Geral"]["Tipo"]).."'. Use 'mysql' ou 'sqlite'.", 1)
        return
    end

    if not dbConnection then
        outputDebugString("[DATABASE] Falha ao conectar ao banco ("..tipo..")!", 1)
        return
    end

    dbReady = true
    outputDebugString("[DATABASE] Conectado com sucesso via "..tipo.."!")
end)

addEventHandler("onResourceStop", resourceRoot, function()
    if dbConnection then
        dbReady = false
    end
end)