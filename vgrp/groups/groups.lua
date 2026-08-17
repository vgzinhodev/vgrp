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

Groups = {
    -- ================================================
    -- STAFF / ADMINISTRAÇÃO
    -- ================================================
    ["Staff"] = {
        ["Nome"] = "Staff",
        ["permissions"] = {"staff.permissao", "nc.permissao", "god.permissao", "tpto.permissao", "car.permissao", "tptome.permissao", "car.permissao", "carcolor.permissao", "dv.permissao", "fix.permissao", "god.permissao", "gp.permissao", "nc.permissao", "sp.permissao", "time.permissao", "tpto.permissao", "tptome.permissao"}
    },
    ["CEO"] = {
        ["Nome"] = "CEO",
        ["permissions"] = {"CEO.permissao", "staff.permissao", "admin.permissao", "nc.permissao"}
    },
    ["Admin"] = {
        ["Nome"] = "Admin",
        ["permissions"] = {"admin.permissao", "nc.permissao", "tpto.permissao", "tptome.permissao"}
    },
    ["SuperModerator"] = {
        ["Nome"] = "SuperModerator",
        ["permissions"] = {"supermod.permissao", "nc.permissao", "tpto.permissao", "tptome.permissao"}
    },
    ["Moderator"] = {
        ["Nome"] = "Moderator",
        ["permissions"] = {"mod.permissao", "nc.permissao", "tpto.permissao", "tptome.permissao"}
    },
    ["TagManager"] = {
        ["Nome"] = "TagManager",
        ["permissions"] = {"tagmanager.permissao"}
    },

    -- ================================================
    -- VIPS / DOADORES
    -- ================================================
    ["Prata"] = {
        ["Nome"] = "Prata",
        ["permissions"] = {"vip.permissao", "prata.permissao"}
    },
    ["Gold"] = {
        ["Nome"] = "Gold",
        ["permissions"] = {"vip.permissao", "gold.permissao"}
    },
    ["Influencer1"] = {
        ["Nome"] = "Influencer1",
        ["permissions"] = {"vip.permissao", "influencer.permissao"}
    },
    ["Influencer2"] = {
        ["Nome"] = "Influencer2",
        ["permissions"] = {"vip.permissao", "influencer.permissao"}
    },
    ["Influencer3"] = {
        ["Nome"] = "Influencer3",
        ["permissions"] = {"vip.permissao", "influencer.permissao"}
    },
    ["Influencer4"] = {
        ["Nome"] = "Influencer4",
        ["permissions"] = {"vip.permissao", "influencer.permissao"}
    },
    ["Influencer5"] = {
        ["Nome"] = "Influencer5",
        ["permissions"] = {"vip.permissao", "influencer.permissao"}
    },

    -- ================================================
    -- ORGANIZAÇÕES POLICIAIS / SERVIÇOS PÚBLICOS
    -- ================================================
    ["Policia"] = {
        ["Nome"] = "Policia",
        ["permissions"] = {"policia.permissao", "algemar.permissao"}
    },
    ["PCESP"] = {
        ["Nome"] = "PCESP",
        ["permissions"] = {"policia.permissao", "pcesp.permissao", "algemar.permissao"}
    },
    ["FT"] = {
        ["Nome"] = "FT",
        ["permissions"] = {"policia.permissao", "ft.permissao", "algemar.permissao"}
    },
    ["BAEP"] = {
        ["Nome"] = "BAEP",
        ["permissions"] = {"policia.permissao", "baep.permissao", "algemar.permissao"}
    },
    ["Gcm"] = {
        ["Nome"] = "Gcm",
        ["permissions"] = {"policia.permissao", "gcm.permissao", "algemar.permissao"}
    },
    ["Rota"] = {
        ["Nome"] = "Rota",
        ["permissions"] = {"policia.permissao", "rota.permissao", "algemar.permissao"}
    },
    ["PMESP"] = {
        ["Nome"] = "PMESP",
        ["permissions"] = {"policia.permissao", "pmesp.permissao", "algemar.permissao"}
    },
    ["CAVPM"] = {
        ["Nome"] = "CAVPM",
        ["permissions"] = {"policia.permissao", "cavpm.permissao"}
    },
    ["Samu"] = {
        ["Nome"] = "Samu",
        ["permissions"] = {"samu.permissao", "curar.permissao"}
    },
    ["PublicSamu"] = {
        ["Nome"] = "PublicSamu",
        ["permissions"] = {"samu.permissao"}
    },
    ["DirSamu"] = {
        ["Nome"] = "DirSamu",
        ["permissions"] = {"samu.permissao", "dirsamu.permissao"}
    },
    ["BOMBEIRO"] = {
        ["Nome"] = "BOMBEIRO",
        ["permissions"] = {"bombeiro.permissao", "socorrer.permissao"}
    },
    ["Mecanico"] = {
        ["Nome"] = "Mecanico",
        ["permissions"] = {"mecanico.permissao", "reparar.permissao"}
    },
    ["PublicMecanico"] = {
        ["Nome"] = "PublicMecanico",
        ["permissions"] = {"mecanico.permissao"}
    },

    -- ================================================
    -- ILEGAL / FACÇÕES
    -- ================================================
    ["Ilegal"] = {
        ["Nome"] = "Ilegal",
        ["permissions"] = {"ilegal.permissao", "algemar.permissao", "roubar.permissao"}
    },
    ["PCC"] = {
        ["Nome"] = "PCC",
        ["permissions"] = {"ilegal.permissao", "pcc.permissao", "roubar.permissao"}
    },
    ["Coca"] = {
        ["Nome"] = "Coca",
        ["permissions"] = {"ilegal.permissao", "coca.permissao"}
    },
    ["Verde"] = {
        ["Nome"] = "Verde",
        ["permissions"] = {"ilegal.permissao", "verde.permissao"}
    },
    ["Lockpick"] = {
        ["Nome"] = "Lockpick",
        ["permissions"] = {"ilegal.permissao", "lockpick.permissao"}
    },
    ["Municao"] = {
        ["Nome"] = "Municao",
        ["permissions"] = {"ilegal.permissao", "municao.permissao"}
    },
    ["Colete"] = {
        ["Nome"] = "Colete",
        ["permissions"] = {"ilegal.permissao", "colete.permissao"}
    },
    ["Arma"] = {
        ["Nome"] = "Arma",
        ["permissions"] = {"ilegal.permissao", "arma.permissao"}
    },
    ["Lavagem"] = {
        ["Nome"] = "Lavagem",
        ["permissions"] = {"ilegal.permissao", "lavagem.permissao"}
    },
    ["Desmanche"] = {
        ["Nome"] = "Desmanche",
        ["permissions"] = {"ilegal.permissao", "desmanche.permissao"}
    },
}