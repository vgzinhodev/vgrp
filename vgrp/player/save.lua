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

local SaveKeys = {
    SKIN = "skin",
    HEALTH = "health",
    ARMOR = "armor",
    POS_G = "pos_g",

    INTERIOR = "interior",
    DIMENSION = "dimension",
    WEAPONS = "weapons"
}

function savePlayerData(player)
    if not isElement(player) then return false end
    
    local id = getElementData(player, "Vg:ID")
    if not id then return false end
    
    local x, y, z = getElementPosition(player)
    local health = getElementHealth(player) or 71
    local armor = getPedArmor(player) or 71
    local skin = getElementModel(player) or 1
    local interior = getElementInterior(player) or 0
    local dimension = getElementDimension(player) or 0

    local weapons = {}
    for slot = 0, 12 do
        local weapon = getPedWeapon(player, slot)
        if weapon and weapon ~= 0 then
            local ammo = getPedTotalAmmo(player, slot)
            weapons[weapon] = {
                slot = slot,
                ammo = ammo
            }
        end
    end
    
    local success = true
    
    setUserData(id, SaveKeys.SKIN, skin)
    setUserData(id, SaveKeys.HEALTH, (health or 71))
    setUserData(id, SaveKeys.ARMOR, (armor or 71))

    if getElementPosition(player) then 
        setUserData(id, SaveKeys.POS_G, {x, y, z})
    end

    setUserData(id, SaveKeys.INTERIOR, interior)
    setUserData(id, SaveKeys.DIMENSION, dimension)

    if next(weapons) then
        setUserData(id, SaveKeys.WEAPONS, weapons)
    else
        setUserData(id, SaveKeys.WEAPONS, nil)
    end
    
    return success
end

function loadPlayerData(player)
    if not isElement(player) then return false end
    
    local id = getElementData(player, "Vg:ID")
    if not id then return false end
    
    local skin = getUserData(id, SaveKeys.SKIN)
    local health = getUserData(id, SaveKeys.HEALTH)
    local armor = getUserData(id, SaveKeys.ARMOR)
    local interior = getUserData(id, SaveKeys.INTERIOR)
    local dimension = getUserData(id, SaveKeys.DIMENSION)
    local weaponsData = getUserData(id, SaveKeys.WEAPONS)
    

    local posg = getUserData(id, SaveKeys.POS_G)


    if skin then
        setElementModel(player, tonumber(skin))
    else
        setElementModel(player, 0) -- CJ default
    end
    
    local spawnX, spawnY, spawnZ = 1481.57, -1739.08, 13.54
    local spawnInterior = 0
    local spawnDimension = 0
    
    if posg then
        local ok, parsed = pcall(fromJSON, posg)
        if ok and type(parsed) == "table" and parsed[1] and parsed[2] and parsed[3] then
            spawnX = tonumber(parsed[1])
            spawnY = tonumber(parsed[2])
            spawnZ = tonumber(parsed[3])
            spawnInterior = tonumber(interior) or 0
            spawnDimension = tonumber(dimension) or 0
        else
            outputDebugString("[SAVE] POS_G inválido para id " .. tostring(id) .. ": " .. tostring(posg), 2)
        end
    end
    setCameraTarget(player, player)

    spawnPlayer(player, spawnX, spawnY, spawnZ)
    setElementPosition(player, spawnX, spawnY, spawnZ)
    setElementInterior(player, spawnInterior)
    setElementDimension(player, spawnDimension)
    setPedStat(player, 22, 1000)
    fadeCamera( player, true, 0.5 )
    local healthValue = tonumber(health) or 100
    if healthValue < 1 then healthValue = 100 end
    if healthValue > 100 then healthValue = 100 end
    
    local armorValue = tonumber(armor) or 0
    if armorValue < 0 then armorValue = 0 end
    if armorValue > 100 then armorValue = 100 end
    
    setElementHealth(player, healthValue)
    setPedArmor(player, armorValue)
        
    if weaponsData then
        local weapons = fromJSON(weaponsData)
        if weapons and type(weapons) == "table" then
            for weaponId, data in pairs(weapons) do
                if type(data) == "table" and data.slot ~= nil and data.ammo ~= nil then
                    giveWeapon(player, weaponId, data.ammo, true)
                end
            end
        end
    end
    
    return true
end

addEventHandler("vgrp:Login", root, function()
    loadPlayerData(source)
end)

addEvent("vgrp:Login2", true)
addEventHandler("vgrp:Login2", root, function()
    loadPlayerData(source)
end)

addEventHandler("onPlayerQuit", root, function()
    local id = getElementData(source, "Vg:ID")
    if savePlayerData then savePlayerData(source) end
    if id then savePlayerCache(id, true) end
    PlayerIdentifiers[source] = nil
end)

addEventHandler("onResourceStop", resourceRoot, function()
    for _, player in ipairs(getElementsByType("player")) do
        savePlayerData(player)
    end
end)

local saveTimer = setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        savePlayerData(player)
    end
end, 10000, 0)

function getSaveKeys()
    return SaveKeys
end