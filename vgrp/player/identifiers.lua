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

local Config = {
    startingID = 1000
}

addEventHandler("onResourceStart", resourceRoot, function()
    if not exports["vgrp-mysql"]:isDatabaseReady() then
        outputDebugString("[ACCOUNTS] Database não está pronto!", 1)
        return
    end

    exports["vgrp-mysql"]:dbExecute([[
        CREATE TABLE IF NOT EXISTS accounts (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            serial VARCHAR(64) NOT NULL,
            discord VARCHAR(30) DEFAULT NULL,
            whitelist TINYINT(1) NOT NULL DEFAULT 0,
            ip VARCHAR(45) NOT NULL,
            name VARCHAR(50) NOT NULL DEFAULT '',
            surname VARCHAR(50) NOT NULL DEFAULT '',
            gender TINYINT(1) NOT NULL DEFAULT 0,
            age TINYINT UNSIGNED NOT NULL DEFAULT 18,
            bank INT UNSIGNED NOT NULL DEFAULT 0,
            gems INT UNSIGNED NOT NULL DEFAULT 0,
            rec TINYINT(1) NOT NULL DEFAULT 0,
            uses INT UNSIGNED NOT NULL DEFAULT 0,
            PRIMARY KEY (id),
            UNIQUE KEY serial_unique (serial)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

    exports["vgrp-mysql"]:dbExecute(
        "ALTER TABLE accounts AUTO_INCREMENT = ?",
        Config.startingID
    )
end)

function getPlayerIdentifier(player)
    local identifiers = parseIdentifiers(player)
    return identifiers.serial, identifiers
end
createEventS("getPlayerIdentifier", getPlayerIdentifier)