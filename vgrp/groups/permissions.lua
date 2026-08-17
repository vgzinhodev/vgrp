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

local GroupPermissions = {}

addEventHandler("onResourceStart", resourceRoot, function()
    if Groups then
        for groupName, groupData in pairs(Groups) do
            GroupPermissions[groupName] = {}
            if groupData.permissions then
                for _, perm in ipairs(groupData.permissions) do
                    GroupPermissions[groupName][perm] = true
                end
            end
        end
        outputDebugString("[VGRP-PERMISSIONS] Tabela de grupos e permissões carregada com sucesso.", 3)
    end
end)

--------------------------------------------------------------------------------
-- FUNÇÕES DE GERENCIAMENTO DE GRUPOS DO JOGADOR
--------------------------------------------------------------------------------

--- Retorna a lista (table) de grupos que o jogador/ID possui
-- @param elementOrId player (element) ou id da conta (number)
function getPlayerGroups(elementOrId)
    local id = type(elementOrId) == "userdata" and getElementData(elementOrId, "Vg:ID") or tonumber(elementOrId)
    if not id then return {} end

    local rawGroups = getUserData(id, "groups")
    if not rawGroups then return {} end

    if type(rawGroups) == "string" then
        local decoded = fromJSON(rawGroups)
        return decoded or {}
    end

    return rawGroups
end

--- Adiciona um grupo ao jogador
-- @param elementOrId player (element) ou id da conta (number)
-- @param groupName nome do grupo
function addPlayerGroup(elementOrId, groupName)
    local id = type(elementOrId) == "userdata" and getElementData(elementOrId, "Vg:ID") or tonumber(elementOrId)
    if not id or not groupName or not Groups[groupName] then return false end

    local currentGroups = getPlayerGroups(id)

    for _, g in ipairs(currentGroups) do
        if g == groupName then return true end
    end

    table.insert(currentGroups, groupName)

    setUserData(id, "groups", currentGroups)
    return true
end

--- Remove um grupo do jogador
-- @param elementOrId player (element) ou id da conta (number)
-- @param groupName nome do grupo
function removePlayerGroup(elementOrId, groupName)
    local id = type(elementOrId) == "userdata" and getElementData(elementOrId, "Vg:ID") or tonumber(elementOrId)
    if not id or not groupName then return false end

    local currentGroups = getPlayerGroups(id)
    local newGroups = {}
    local removed = false

    for _, g in ipairs(currentGroups) do
        if g ~= groupName then
            table.insert(newGroups, g)
        else
            removed = true
        end
    end

    if removed then
        setUserData(id, "groups", newGroups)
    end

    return removed
end

--- Verifica se o jogador possui um grupo específico
-- @param elementOrId player (element) ou id da conta (number)
-- @param groupName nome do grupo
function hasGroup(elementOrId, groupName)
    local groups = getPlayerGroups(elementOrId)
    for _, g in ipairs(groups) do
        if g == groupName then
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- FUNÇÕES DE CHECAGEM DE PERMISSÕES
--------------------------------------------------------------------------------

--- Verifica se o jogador/ID possui uma determinada permissão
-- @param elementOrId player (element) ou id da conta (number)
-- @param permission permissão (ex: "staff.permissao")
function hasPermission(elementOrId, permission)
    if not permission then return false end

    local groups = getPlayerGroups(elementOrId)
    if #groups == 0 then return false end

    for _, groupName in ipairs(groups) do
        if GroupPermissions[groupName] and GroupPermissions[groupName][permission] then
            return true
        end
    end

    return false
end

--- Verifica se o jogador possui pelo menos UMA das permissões passadas em uma lista
-- @param elementOrId player (element) ou id da conta (number)
-- @param permTable tabela de permissões (ex: {"staff.permissao", "nc.permissao"})
function hasTablePermission(elementOrId, permTable)
    if type(permTable) ~= "table" then return false end

    for _, perm in ipairs(permTable) do
        if hasPermission(elementOrId, perm) then
            return true
        end
    end

    return false
end

--------------------------------------------------------------------------------
-- EVENTOS PARA MANIPULAR GRUPOS
--------------------------------------------------------------------------------

addEvent("setPlayerGroup", true)
addEventHandler("setPlayerGroup", root, function(targetID, groupName)
    local source = client
    
    local id = getElementData(source, "Vg:ID")
    if id and not hasPermission(source, "staff.permissao") then
        infoBoxS(source, "Você não tem permissão para usar este comando.", "error")
        return
    end
    
    targetID = tonumber(targetID)
    if not targetID or not groupName then
        infoBoxS(source, "Uso correto: /setgroup <ID> <Grupo>", "info")
        return
    end
    
    if addPlayerGroup(targetID, groupName) then
        infoBoxS(source, "Grupo '" .. groupName .. "' adicionado ao ID " .. targetID, "sucess")
    else
        infoBoxS(source, "Falha ao adicionar grupo (Grupo inexistente ou ID inválido).", "error")
    end
end)

addEvent("removePlayerGroup", true)
addEventHandler("removePlayerGroup", root, function(targetID, groupName)
    local source = client
    
    local id = getElementData(source, "Vg:ID")
    if id and not hasPermission(source, "staff.permissao") then
        infoBoxS(source, "Você não tem permissão para usar este comando.", "error")
        return
    end
    
    targetID = tonumber(targetID)
    if not targetID or not groupName then
        infoBoxS(source, "Uso correto: /remgroup <ID> <Grupo>", "info")
        return
    end
    
    if removePlayerGroup(targetID, groupName) then
        infoBoxS(source, "Grupo '" .. groupName .. "' removido do ID " .. targetID, "sucess")
    else
        infoBoxS(source, "O ID " .. targetID .. " não possui este grupo.", "error")
    end
end)

addEvent("listPlayerGroups", true)
addEventHandler("listPlayerGroups", root, function(targetID)
    local source = client
    
    local id = targetID and tonumber(targetID) or getElementData(source, "Vg:ID")
    
    if not id then
        infoBoxS(source, "Uso correto: /vgroups [ID]", "info")
        return
    end
    
    local groups = getPlayerGroups(id)
    
    if #groups > 0 then
        local groupsString = table.concat(groups, ", ")
        infoBoxS(source, "Grupos do ID " .. id .. ": " .. groupsString, "sucess")
    else
        infoBoxS(source, "O ID " .. id .. " não possui nenhum grupo vinculado.", "info")
    end
end)

addEventHandler("vgrp:Login", root, function()
    local id = getElementData(source, "Vg:ID")

    if id == 1 then
        if Groups and Groups["CEO"] then
            if not hasGroup(id, "CEO") then
                addPlayerGroup(id, "CEO")
                outputDebugString("[VGRP-PERMISSIONS] Grupo 'CEO' atribuído automaticamente ao ID 1.", 3)
            end
        else
            outputDebugString("[VGRP-PERMISSIONS] Erro: O grupo 'CEO' não está definido em groups.lua!", 1)
        end
    end
end)

-- Função auxiliar para enviar notify do servidor
function infoBoxS(player, msg, type)
    return exports["s_infobox"]:addInsInfobox(player, msg, type)
end