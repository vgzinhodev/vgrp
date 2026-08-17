resource_name = "VGroup Core System"
resource_version = "1.0.0"
resource_author = "VgZinhoOo Store"

resource_info = {
    description = "Caso tenha dúvidas consulte: https://discord.gg/NjeRXA475g | https://vgzinhostore.com",
    type = "script",
}

shared_files = {
    "VgZinhoOoEdit.lua",
    "groups/groups.lua",
}

server_files = {
    "groups/permissions.lua",

    "player/identifiers.lua",
    "player/join.lua",


    "player/datas.lua",
    "player/save.lua",

    "legacy/addCommandHandlerServer.lua",
    "legacy/bindKeyServer.lua",

}

client_files = {
    "groups/permissionsc.lua",

    "legacy/addCommandHandler.lua",
    "legacy/bindKey.lua",

    "player/joinc.lua",
}


exports = {
    "hasPermission",
    "hasGroup",
    "hasTablePermission",
    "addPlayerGroup",
    "removePlayerGroup",
    "getPlayerGroups",
    "isBindEventAvaliable",
    "getPlayerIdentifier"
}