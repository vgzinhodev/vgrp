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

function resolvePlayer(elementOrId)
    if (type(elementOrId) == "userdata" or type(elementOrId) == "element") and isElement(elementOrId) then
        local id = getElementData(elementOrId, "Vg:ID")
        return tonumber(id), elementOrId
    end

    return tonumber(elementOrId), nil
end

-- @param elementOrId player (element) ou id da conta (number)
function getPlayerMoney(elementOrId)
    local id = resolvePlayer(elementOrId)
    if not id then return 0 end

    local raw = getUserData(id, "money")
    return tonumber(raw) or 0
end

-- @param elementOrId player (element) ou id da conta (number)
-- @param amount novo valor de dinheiro
function setPlayerMoney(elementOrId, amount, instant)
    local id, player = resolvePlayer(elementOrId)
    if not id then return false end

    amount = math.floor(tonumber(amount) or 0)
    if amount < 0 then amount = 0 end

    setUserData(id, "money", amount)

    return true
end

function givePlayerMoney(elementOrId, amount)
    amount = tonumber(amount) or 0
    if amount <= 0 then return false end

    local current = getPlayerMoney(elementOrId)
    return setPlayerMoney(elementOrId, current + amount)
end

function takePlayerMoney(elementOrId, amount)
    amount = tonumber(amount) or 0
    if amount <= 0 then return false end

    local current = getPlayerMoney(elementOrId)
    if current < amount then return false end

    return setPlayerMoney(elementOrId, current - amount)
end