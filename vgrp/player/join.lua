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
    whitelistOnRegister = 0,
    saveOnLogin = true,
    requireWhitelist = true,
}

local PlayerIdentifiers = {}

function parseIdentifiers(player)
    local data = { serial = nil, ip = nil, discord = nil }
    
    local raw = getPlayerIdentifiers(player)
    
    for _, id in ipairs(raw) do
        local prefix, value = id:match("^(%a+:)(.*)$")
        if prefix == "mtax:" then
            data.serial = value
        elseif prefix == "ip:" then
            data.ip = value
        elseif prefix == "discord:" then
            data.discord = value
        end
    end
    
    return data
end

function infoBoxC(player, msg, type)
    return exports["s_infobox"]:addIncInfobox(msg, type)
end

function infoBoxS(player, msg, type)
    return exports["s_infobox"]:addInsInfobox(player, msg, type)
end

local function completeLogin(player, accountRow, isNewAccount)
    if not isElement(player) or not accountRow then
        return false
    end

    if Config.requireWhitelist then
        local whitelist = tonumber(accountRow.whitelist) or 0
        if whitelist ~= 1 then
            local id = accountRow.id or "Desconhecido"
            kickPlayer(player,"❌ Você não possui whitelist! \n📋 ID: " .. math.floor(id))
            return false
        end
    end

    setElementData(player, "Vg:ID", tonumber(math.floor(accountRow.id)))
    triggerEvent("vgrp:prepareDatas", player)

    local identifiers = PlayerIdentifiers[player]

    if identifiers and identifiers.ip and identifiers.ip ~= accountRow.ip then
        exports["vgrp-mysql"]:dbExecute(
            "UPDATE accounts SET ip = ? WHERE id = ?",
            identifiers.ip, accountRow.id
        )
    end

    if identifiers and identifiers.discord and not accountRow.discord then
        exports["vgrp-mysql"]:dbExecute(
            "UPDATE accounts SET discord = ? WHERE id = ?",
            identifiers.discord, accountRow.id
        )
    end

    exports["vgrp-mysql"]:dbExecute(
        "UPDATE accounts SET uses = uses + 1 WHERE id = ?",
        accountRow.id
    )

    triggerEvent("vgrp:Login", player)
    triggerClientEvent(player, "vgrp:Login", player)

    triggerEvent("onPlayerLogin", player)
    triggerClientEvent(player, "onPlayerLogin", player)

    triggerClientEvent(player, "vgrp:onAccountReady", player, {
        isNewAccount = isNewAccount,
        whitelisted = accountRow.whitelist == 1,
        name = accountRow.name,
        surname = accountRow.surname,
    })

    return true
end

local function registerAccount(player, identifiers)
    local success = exports["vgrp-mysql"]:dbExecute(
        "INSERT INTO accounts (serial, ip, discord, whitelist) VALUES (?, ?, ?, ?)",
        identifiers.serial, identifiers.ip or "", identifiers.discord, Config.whitelistOnRegister
    )
    
    if not success then
        infoBoxS(player, "Erro ao criar sua conta, tente novamente", "error")
        kickPlayer(player,"❌ Erro ao criar sua conta, tente novamente")
        return
    end
        
    setTimer(function()
        if not isElement(player) then
            return
        end
                
        local result = exports["vgrp-mysql"]:dbSelect(
            "SELECT * FROM accounts WHERE serial = ? LIMIT 1",
            identifiers.serial
        )
        
        if result and result[1] then
            completeLogin(player, result[1], true)
        else
            infoBoxS(player, "Erro ao criar sua conta, tente novamente", "error")
            kickPlayer(player,"❌ Erro ao criar sua conta, tente novamente")
        end
    end, 3000, 1)
end

local function handleAccount(player)
    local identifiers = PlayerIdentifiers[player]
    
    if not identifiers or not identifiers.serial then
        kickPlayer(player,"❌ Não foi possível identificar sua conexão")
        return
    end

    local result = exports["vgrp-mysql"]:dbSelect(
        "SELECT * FROM accounts WHERE serial = ? LIMIT 1",
        identifiers.serial
    )

    if result and result[1] then
        completeLogin(player, result[1], false)
        return
    end

    registerAccount(player, identifiers)
end

addCommandHandler("addwhitelist", function(player, command, targetPlayer)
    if not exports["vgrp-mysql"]:isDatabaseReady() then
        infoBoxS(player, "Banco de dados não está pronto!", "error")
        return
    end
    
    if not targetPlayer then
        infoBoxS(player, "Use: /addwhitelist [player]", "error")
        return
    end
    
    local target = getPlayerFromName(targetPlayer)
    if not target then
        infoBoxS(player, "Jogador não encontrado!", "error")
        return
    end
    
    local identifiers = PlayerIdentifiers[target]
    if not identifiers or not identifiers.serial then
        infoBoxS(player, "Não foi possível identificar o serial do jogador!", "error")
        return
    end
    
    local result = exports["vgrp-mysql"]:dbSelect(
        "SELECT id FROM accounts WHERE serial = ? LIMIT 1",
        identifiers.serial
    )
    
    if not result or not result[1] then
        infoBoxS(player, "Jogador não possui conta registrada!", "error")
        return
    end
    
    exports["vgrp-mysql"]:dbExecute(
        "UPDATE accounts SET whitelist = 1 WHERE serial = ?",
        identifiers.serial
    )
    
    infoBoxS(player, getPlayerName(target) .. " foi adicionado à whitelist!", "success")
    infoBoxS(target, "Você foi adicionado à whitelist por " .. getPlayerName(player), "success")
end)

addCommandHandler("removewhitelist", function(player, command, targetPlayer)
    if not exports["vgrp-mysql"]:isDatabaseReady() then
        infoBoxS(player, "Banco de dados não está pronto!", "error")
        return
    end
    
    if not targetPlayer then
        infoBoxS(player, "Use: /removewhitelist [player]", "error")
        return
    end
    
    local target = getPlayerFromName(targetPlayer)
    if not target then
        infoBoxS(player, "Jogador não encontrado!", "error")
        return
    end
    
    local identifiers = PlayerIdentifiers[target]
    if not identifiers or not identifiers.serial then
        infoBoxS(player, "Não foi possível identificar o serial do jogador!", "error")
        return
    end
    
    local result = exports["vgrp-mysql"]:dbSelect(
        "SELECT id FROM accounts WHERE serial = ? LIMIT 1",
        identifiers.serial
    )
    
    if not result or not result[1] then
        infoBoxS(player, "Jogador não possui conta registrada!", "error")
        return
    end
    
    exports["vgrp-mysql"]:dbExecute(
        "UPDATE accounts SET whitelist = 0 WHERE serial = ?",
        identifiers.serial
    )
    
    infoBoxS(player, getPlayerName(target) .. " foi removido da whitelist!", "success")
    infoBoxS(target, "Você foi removido da whitelist por " .. getPlayerName(player), "error")
    
    if Config.requireWhitelist then
        infoBoxS(target, "Você foi removido da whitelist!", "error")
        kickPlayer(target,"❌ Você foi removido da whitelist!")
    end
end)

addCommandHandler("checkwhitelist", function(player, command, targetPlayer)
    if not targetPlayer then
        local identifiers = PlayerIdentifiers[player]
        if not identifiers or not identifiers.serial then
            infoBoxS(player, "Não foi possível identificar seu serial!", "error")
            return
        end
        
        local result = exports["vgrp-mysql"]:dbSelect(
            "SELECT whitelist FROM accounts WHERE serial = ? LIMIT 1",
            identifiers.serial
        )
        
        if result and result[1] then
            local status = result[1].whitelist == 1 and "Possui whitelist" or "Não possui whitelist"
            infoBoxS(player, status, "info")
        else
            infoBoxS(player, "Você não possui conta registrada!", "error")
        end
        return
    end
    
    local target = getPlayerFromName(targetPlayer)
    if not target then
        infoBoxS(player, "Jogador não encontrado!", "error")
        return
    end
    
    local identifiers = PlayerIdentifiers[target]
    if not identifiers or not identifiers.serial then
        infoBoxS(player, "Não foi possível identificar o serial do jogador!", "error")
        return
    end
    
    local result = exports["vgrp-mysql"]:dbSelect(
        "SELECT whitelist FROM accounts WHERE serial = ? LIMIT 1",
        identifiers.serial
    )
    
    if result and result[1] then
        local status = result[1].whitelist == 1 and "Possui whitelist" or "Não possui whitelist"
        infoBoxS(player, getPlayerName(target) .. ": " .. status, "info")
    else
        infoBoxS(player, "Jogador não possui conta registrada!", "error")
    end
end)

addEventHandler("onPlayerConnect", root, function(apelido, ip, senha, identifiers)
    if not exports["vgrp-mysql"]:isDatabaseReady() then
        cancelEvent(true, "❌ Servidor iniciando, tente novamente")
        return
    end

    if Config.requireWhitelist then
        local data = {}
        for _, id in ipairs(identifiers) do
            local prefix, value = id:match("^(%a+:)(.*)$")
            if prefix == "mtax:" then
                data.serial = value
            elseif prefix == "ip:" then
                data.ip = value
            elseif prefix == "discord:" then
                data.discord = value
            end
        end

        local serial = data.serial
        if serial and serial ~= "" then
            local result = exports["vgrp-mysql"]:dbSelect(
                "SELECT id, whitelist FROM accounts WHERE serial = ? LIMIT 1",
                serial
            )

            if result and result[1] then
                local whitelist = tonumber(result[1].whitelist) or 0
                if whitelist ~= 1 then
                    cancelEvent(true, "❌ Você não possui whitelist! \n📋 ID: " .. math.floor(result[1].id))
                    return
                end
            end
        end
    end
end)

addEventHandler("onPlayerQuit", root, function()
    if savePlayerData then
        savePlayerData(source)
    end
    PlayerIdentifiers[source] = nil
end)

addEvent("vgrp:PlayerJoin", true)
addEventHandler("vgrp:PlayerJoin", root, function()
    local player = source
    PlayerIdentifiers[player] = parseIdentifiers(player)
    handleAccount(player)
end)