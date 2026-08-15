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

local CacheData = {}

addEventHandler("onResourceStart", resourceRoot, function()
    if not exports["vgrp-mysql"]:isDatabaseReady() then
        outputDebugString("[USER-DATA] Database não está pronto!", 1)
        return
    end

    exports["vgrp-mysql"]:dbExecute([[
        CREATE TABLE IF NOT EXISTS vgrp_user_data (
            id INT UNSIGNED NOT NULL,
            `key` VARCHAR(100) NOT NULL,
            `value` LONGTEXT DEFAULT NULL,
            PRIMARY KEY (id, `key`),
            CONSTRAINT fk_user_data_accounts FOREIGN KEY (id) REFERENCES accounts(id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

    for _, player in ipairs(getElementsByType("player")) do
        local id = getElementData(player, "Vg:ID")
        if id then
            loadPlayerCache(id)
        end
    end
end)

function loadPlayerCache(id)
    if not id then return end

    CacheData[id] = {}

    local result = exports["vgrp-mysql"]:dbSelect("SELECT `key`, `value` FROM vgrp_user_data WHERE id = ?", id)
    if result then
        for _, row in ipairs(result) do
            CacheData[id][row.key] = row.value
        end
    end
end

function savePlayerCache(id, clearMemory)
    if not id or not CacheData[id] then return end

    for key, _ in pairs(CacheData[id]) do
        local val = CacheData[id][key]
        
        exports["vgrp-mysql"]:dbExecute([[
            INSERT INTO vgrp_user_data (id, `key`, `value`) 
            VALUES (?, ?, ?) 
            ON DUPLICATE KEY UPDATE `value` = VALUES(`value`)
        ]], id, key, val)
    end

    if clearMemory then
        CacheData[id] = nil
    end
end

addEvent("vgrp:prepareDatas", true)
addEventHandler("vgrp:prepareDatas", root, function()
    local id = getElementData(source, "Vg:ID")
    if id then
        loadPlayerCache(id)
    end
end)

addEventHandler("onPlayerQuit", root, function()
    local id = getElementData(source, "Vg:ID")
    if id then
        savePlayerCache(id, true)
    end
end)

addEventHandler("onResourceStop", resourceRoot, function()
    for _, player in ipairs(getElementsByType("player")) do
        local id = getElementData(player, "Vg:ID")
        if id then
            savePlayerCache(id, false)
        end
    end
end)

function setUserData(id, key, value)
    if not id or not key then return false end
    
    if not CacheData[id] then
        CacheData[id] = {}
    end

    if type(value) == "table" then
        value = toJSON(value)
    end

    CacheData[id][key] = value

    return true
end

function getUserData(id, key)
    if not id or not key then return nil end

    if CacheData[id] and CacheData[id][key] ~= nil then
        return CacheData[id][key]
    end

    return nil
end