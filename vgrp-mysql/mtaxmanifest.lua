resource_name = "VGroup SQL System"
resource_version = "1.0.0"
resource_author = "VgZinhoOo Store"

resource_info = {
    description = "Caso tenha dúvidas consulte: https://discord.gg/NjeRXA475g | https://vgzinhostore.com",
    type = "script",
}

server_files = {
    "connections.lua",
    "exports.lua",
}

shared_files = {
    "VgZinhoOoEdit.lua",
}

exports = {
    "dbExecute",
    "dbSelect",
    "dbInsertId",
    "isDatabaseReady",
}