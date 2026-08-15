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
Documentação para este script: https://docs.vgzinhostore.com :)
]]

------ VGroup Core System Export
local vgrp = exports["vgrp"]

----------------------------------------------------------------------------------------------------------------
-- AddCommandHandler Server-Side Compatibility 
----------------------------------------------------------------------------------------------------------------
_addCommandHandler = addCommandHandler
_removeCommandHandler = removeCommandHandler

local eventsAdded = {}

function addCommandHandler(cmd, func, ...)
    if localPlayer then 
        return _addCommandHandler(cmd, func, ...)
    else 
        if not eventsAdded[cmd] then 
            local handlerFunc = function(...)
                func(...)
            end

            addEvent(cmd, true)
            addEventHandler(cmd, getRootElement(), handlerFunc)

            triggerEvent("vgrp:registerPendingCommand", root, cmd, ...)

            setTimer(function(cmd, ...)
                triggerClientEvent(root, "vgrp:addClientCommand", root, cmd, ...)
            end, 1000, 1, cmd, ...)

            eventsAdded[cmd] = {handler = handlerFunc}
        end
        return true
    end
end

function removeCommandHandler(cmd, handler)
    if localPlayer then 
        return _removeCommandHandler(cmd, handler)
    else 
        local entry = eventsAdded[cmd]
        if not entry then return false end

        removeEventHandler(cmd, getRootElement(), entry.handler)
        eventsAdded[cmd] = nil

        triggerEvent("vgrp:unregisterPendingCommand", root, cmd)
        triggerClientEvent(root, "vgrp:removeClientCommand", root, cmd)

        return true
    end
end

----------------------------------------------------------------------------------------------------------------
-- Bind Key Server-Side Compatibility 
----------------------------------------------------------------------------------------------------------------
_bindKey = bindKey
_unbindKey = unbindKey

local bindsAdded = {}

function bindKey(_, bind, state, func, ...)
    if localPlayer then 
        return _bindKey(_, bind, state, func, ...)
    else 
        if not bindsAdded[bind] then 
            local resName = getResourceName(getThisResource())
            local eventName = bind
            if vgrp:isBindEventAvaliable(bind.."-"..resName) then 
                eventName = bind.."-"..resName
            elseif vgrp:isBindEventAvaliable(bind.."-"..resName.."-2") then 
                eventName = bind.."-"..resName.."-2"
            end

            local handlerFunc = function(one, two, three, ...)
                func(one, two, three, ...)
            end

            addEvent(eventName, true)
            addEventHandler(eventName, getRootElement(), handlerFunc)

            triggerEvent("vgrp:registerPendingBind", root, eventName, bind, state, ...)

            setTimer(function(eventName, bind, state, ...)
                triggerClientEvent(root, "vgrp:addClientBind", root, eventName, bind, state, ...)
            end, 1000, 1, eventName, bind, state, ...)

            bindsAdded[bind] = {eventName = eventName, state = state, handler = handlerFunc}
        end
        return true
    end
end

function unbindKey(_, bind, state, func, ...)
    if localPlayer then 
        return _unbindKey(_, bind, state, func, ...)
    else 
        local entry = bindsAdded[bind]
        if not entry then return false end

        removeEventHandler(entry.eventName, getRootElement(), entry.handler)
        bindsAdded[bind] = nil

        triggerEvent("vgrp:unregisterPendingBind", root, entry.eventName)
        triggerClientEvent(root, "vgrp:removeClientBind", root, entry.eventName, bind, entry.state)

        return true
    end
end

----------------------------------------------------------------------------------------------------------------
-- String Compatibility
----------------------------------------------------------------------------------------------------------------
string.gfind = string.gmatch

----------------------------------------------------------------------------------------------------------------
-- ACL Legacy Compatibilty 
----------------------------------------------------------------------------------------------------------------
function aclGetGroup(groupName)
    return groupName
end

function isObjectInACLGroup(object, group)
    local groupName = tostring(group)
    local targetId  = nil

    if type(object) == "string" then

        local idFromString = object:match("^user%.(.+)$")
        if idFromString then
            targetId = idFromString
            return vgrp:hasGroup(targetId, groupName)
        end

        local resourceName = object:match("^resource%.(.+)$")
        if resourceName then
            return false
        end

        return vgrp:hasGroup(object, groupName)
    end

    if type(object) == "userdata" then
        local id = getElementData(object, "Vg:ID")
        if id then
            targetId = tostring(id)
            return vgrp:hasGroup(targetId, groupName)
        end
    end

    return vgrp:hasGroup(tostring(object), groupName)
end

function getAccountName(account)
    if type(account) == "userdata" then
        local id = getElementData(account, "Vg:ID")
        if id then
            id = math.floor(tonumber(id))
            return tostring(id)
        end
    end
    return tostring(account)
end

function getPlayerAccount(player)
    return player
end

function isGuestAccount(player)
    return false 
end

----------------------------------------------------------------------------------------------------------------
-- Serial Compatibility 
----------------------------------------------------------------------------------------------------------------

function getPlayerSerial(player)
    return vgrp:getPlayerIdentifier(player)
end

----------------------------------------------------------------------------------------------------------------
-- Map Compatibility
----------------------------------------------------------------------------------------------------------------
function isPlayerMapVisible()
    return false 
end

function getZoneName()
    return "N/A"
end

function getAreaName()
    return "N/A"
end

----------------------------------------------------------------------------------------------------------------
-- GUI Compatibility
----------------------------------------------------------------------------------------------------------------
if localPlayer then

function guiGetScreensize()
    return getScreenSize()
end

local editboxes = {}
local nextEditboxId = 0
local editFocused = nil

local function charPassesValidation(char, validation)
    if (not validation) or validation == "" then return true end
    local class = validation:match("%[(.-)%]")
    if not class then return true end
    local ok = pcall(string.match, char, "[" .. class .. "]")
    if not ok then return true end
    return (char:match("[" .. class .. "]")) ~= nil
end

function createEditbox(x, y, width, height, textVisible, maxCharacter, masked, font, postGUI)
    nextEditboxId = nextEditboxId + 1

    editboxes[nextEditboxId] = {
        x = x or 0,
        y = y or 0,
        width = width or 100,
        height = height or 25,
        textVisible = textVisible or "",
        text = "",
        maxCharacter = maxCharacter or 99999,
        masked = masked or false,
        font = font or "default-bold",
        postGUI = postGUI or false,
        validation = nil,
        visible = (width or 0) > 0 and (height or 0) > 0,
        colorText = {255, 255, 255, 255},
        colorCaret = {255, 255, 255, 255},
        caret = 0,
        caretSpeed = 1,
        caretState = false,
        deleteSpeed = 55,
        deleteTick = getTickCount(),
        textSize = {dxGetTextSize(textVisible or "", width or 100, 1, 1, font or "default-bold")},
    }

    return nextEditboxId
end

function renderEditbox(id, alpha)
    local edit = editboxes[id]
    if (not edit) then return end

    if (editFocused == id) then
        edit.caret = edit.caret + (1 / 60)
        if (edit.caret >= edit.caretSpeed) then
            edit.caret = 0
            edit.caretState = not edit.caretState
        end

        if (edit.caretState) and (#edit.text < 40) then
            dxDrawRectangle(
                edit.x + edit.textSize[1],
                edit.y + (edit.height - edit.textSize[2]) / 2,
                1,
                edit.textSize[2],
                tocolor(edit.colorCaret[1], edit.colorCaret[2], edit.colorCaret[3], edit.colorCaret[4] * alpha),
                edit.postGUI
            )
        end

        dxDrawText(
            (edit.masked and string.rep('*', #edit.text)) or edit.text,
            edit.x, edit.y, edit.width, edit.height,
            tocolor(edit.colorText[1], edit.colorText[2], edit.colorText[3], edit.colorText[4] * alpha),
            1, edit.font, "left", "center", false, true, edit.postGUI
        )

        if (getKeyState('backspace')) then
            edit.deleteSpeed = edit.deleteSpeed - 1
            if ((getTickCount() - edit.deleteTick) > edit.deleteSpeed + 50) then
                if (edit.deleteSpeed <= 0) then
                    edit.text = string.sub(edit.text, 1, #edit.text - 1)
                    edit.textSize = {dxGetTextSize(edit.text, edit.width, 1, 1, edit.font)}
                    edit.deleteTick = getTickCount()
                end
            end
        else
            edit.deleteSpeed = 55
        end
    else
        dxDrawText(
            (#edit.text > 0) and ((edit.masked and string.rep('*', #edit.text)) or edit.text) or edit.textVisible,
            edit.x, edit.y, edit.width, edit.height,
            tocolor(edit.colorText[1], edit.colorText[2], edit.colorText[3], edit.colorText[4] * alpha),
            1, edit.font, "left", "center", false, false, edit.postGUI
        )
    end
end

function getEditboxText(id)
    local edit = editboxes[id]
    return edit and edit.text or ""
end

function setEditboxText(id, text)
    local edit = editboxes[id]
    if (not edit) then return end
    edit.text = text or ""
    edit.textSize = {dxGetTextSize(edit.text, edit.width, 1, 1, edit.font)}
end

function destroyEditbox(id)
    if (editFocused == id) then
        editFocused = nil
    end
    editboxes[id] = nil
end

function isValidEditbox(id)
    return editboxes[id] ~= nil
end

function focusEditbox(id)
    if (not editboxes[id]) then return false end
    editFocused = id
    return true
end

function blurEditbox(id)
    if (editFocused == id) then
        editFocused = nil
    end
    return true
end

function isEditboxFocused(id)
    return editFocused == id
end

function clickEditbox(id, button, state, absX, absY)
    local edit = editboxes[id]
    if (not edit) or button ~= 'left' or state ~= 'down' then return end

    if isMouseInPosition(edit.x, edit.y, edit.width, edit.height) then
        editFocused = id
    elseif (editFocused == id) then
        editFocused = nil
    end
end

local guiEditElements = setmetatable({}, { __mode = "k" })
local guiEditFocused = nil

local function isGuiEditElement(el)
    return type(el) == "table" and guiEditElements[el] ~= nil
end

_guiCreateEdit = guiCreateEdit
function guiCreateEdit(x, y, width, height, text, relative, ...)
    local id = createEditbox(x, y, width, height, text, 99999, false, "default-bold", false)

    local element = {
        maxLength = 99999,
        validation = nil,
    }
    guiEditElements[element] = id

    return element
end

_guiGetText = guiGetText
function guiGetText(el, ...)
    if isGuiEditElement(el) then
        return getEditboxText(guiEditElements[el])
    end
    if _guiGetText then return _guiGetText(el, ...) end
    return ""
end

_guiSetText = guiSetText
function guiSetText(el, text, ...)
    if isGuiEditElement(el) then
        return setEditboxText(guiEditElements[el], text or "")
    end
    if _guiSetText then return _guiSetText(el, text, ...) end
end

_guiEditSetMaxLength = guiEditSetMaxLength
function guiEditSetMaxLength(el, length, ...)
    if isGuiEditElement(el) then
        el.maxLength = tonumber(length) or el.maxLength
        return true
    end
    if _guiEditSetMaxLength then return _guiEditSetMaxLength(el, length, ...) end
end

_guiSetProperty = guiSetProperty
function guiSetProperty(el, prop, value, ...)
    if isGuiEditElement(el) then
        if prop == "ValidationString" then
            el.validation = value
        end
        return true
    end
    if _guiSetProperty then return _guiSetProperty(el, prop, value, ...) end
end

_guiEditSetCaretIndex = guiEditSetCaretIndex
function guiEditSetCaretIndex(el, index, ...)
    if isGuiEditElement(el) then
        return true
    end
    if _guiEditSetCaretIndex then return _guiEditSetCaretIndex(el, index, ...) end
end

_guiBringToFront = guiBringToFront
function guiBringToFront(el, ...)
    if isGuiEditElement(el) then
        guiEditFocused = el
        focusEditbox(guiEditElements[el])
        return true
    end
    if _guiBringToFront then return _guiBringToFront(el, ...) end
end

function guiSetInputMode(mode, ...)
    if mode == "no_binds_when_editing" or mode == "no_binds" then
        pcall(toggleAllControls, false, true, false)
    elseif mode == "allow_binds" then
        pcall(toggleAllControls, true, true, true)
    end
    return true
end

local function clearGuiEditFocus()
    if guiEditFocused then
        blurEditbox(guiEditElements[guiEditFocused])
        guiEditFocused = nil
    end
    pcall(toggleAllControls, true, true, true)
end

_isElement = isElement
function isElement(el, ...)
    if isGuiEditElement(el) then
        return isValidEditbox(guiEditElements[el])
    end
    return _isElement(el, ...)
end

_destroyElement = destroyElement
function destroyElement(el, ...)
    if isGuiEditElement(el) then
        if guiEditFocused == el then
            clearGuiEditFocus()
        end
        destroyEditbox(guiEditElements[el])
        guiEditElements[el] = nil
        return true
    end
    return _destroyElement(el, ...)
end

_showCursor = showCursor
function showCursor(show, ...)
    if not show then
        clearGuiEditFocus()
    end
    return _showCursor(show, ...)
end

addEventHandler("onClientCharacter", root, function(char)
    if not guiEditFocused then return end
    local id = guiEditElements[guiEditFocused]
    if not id then return end

    if #getEditboxText(id) >= (guiEditFocused.maxLength or 99999) then return end
    if not charPassesValidation(char, guiEditFocused.validation) then return end

    setEditboxText(id, getEditboxText(id) .. char)
    focusEditbox(id) -- garante que o caret volta a piscar
end)

addEventHandler("onClientKey", root, function(key, pressed)
    if not pressed then return end
    if key ~= "backspace" then return end
    if not guiEditFocused then return end
    local id = guiEditElements[guiEditFocused]
    if not id then return end

    setEditboxText(id, string.sub(getEditboxText(id), 1, #getEditboxText(id) - 1))
end)

addEventHandler("onClientClick", root, function(button, state, absX, absY)
    for element, id in pairs(guiEditElements) do
        local edit = editboxes[id]
        if edit and edit.visible then
            clickEditbox(id, button, state, absX, absY)
        end
    end
end)

addEventHandler("onClientRender", root, function()
    for element, id in pairs(guiEditElements) do
        local edit = editboxes[id]
        if edit and edit.visible then
            renderEditbox(id, 1)
        end
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    clearGuiEditFocus()
    for element, id in pairs(guiEditElements) do
        destroyEditbox(id)
    end
    guiEditElements = setmetatable({}, { __mode = "k" })
end)

end

-- Acesse: https://vgzinhostore.com/