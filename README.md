# 🚀 VGRP Framework para MTAX

[![Discord](https://img.shields.io/badge/Discord-5865F2?style=for-the-badge\&logo=discord\&logoColor=white)](https://discord.gg/NjeRXA475g)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge\&logo=github\&logoColor=white)](https://github.com/vgzinhodev/mta-to-mtax)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

> **VGRP** é um framework desenvolvido para **MTAX**, criado para facilitar a migração de servidores e scripts do MTA:SA para uma estrutura moderna, organizada, segura e escalável.

---

## 📖 Sobre

O **VGRP** fornece uma camada de compatibilidade e gerenciamento para servidores MTAX, substituindo diversos sistemas tradicionalmente utilizados no MTA:SA.

### ✨ Principais funcionalidades

* ✅ Sistema de **grupos e permissões**
* ✅ Sistema de **contas e identificação de jogadores**
* ✅ **Whitelist** integrada
* ✅ Salvamento automático de dados do jogador
* ✅ Suporte a **MySQL e SQLite**
* ✅ Camada de **compatibilidade com funções legadas do MTA:SA**
* ✅ Sistema de **exports** para integração entre recursos
* ✅ Conversor de scripts **MTA:SA → MTAX**
* ✅ Sistema de gerenciamento de grupos diretamente pelo servidor

---

## 🛠️ Recursos

| Recurso        | Descrição                                                                                |
| -------------- | ---------------------------------------------------------------------------------------- |
| **vgrp**       | Núcleo do framework: grupos, permissões, contas, whitelist, salvamento e compatibilidade |
| **vgrp-mysql** | Sistema de banco de dados com suporte a MySQL e SQLite                                   |
| **Conversor**  | Ferramenta para converter scripts do MTA:SA para MTAX                                    |

---

# 📦 Instalação

## 1. Clone o repositório

```bash
git clone https://github.com/vgzinhodev/mta-to-mtax.git
```

## 2. Instale os recursos

Copie as pastas:

```text
vgrp
vgrp-mysql
```

para a pasta:

```text
resources/
```

do seu servidor MTAX.

A estrutura deverá ficar semelhante a:

```text
resources/
├── vgrp/
└── vgrp-mysql/
```

---

## 3. Configure o banco de dados

Abra:

```text
vgrp-mysql/VgZinhoOoEdit.lua
```

e configure as informações do banco:

```lua
Cfg = {
    ["Geral"] = {
        ["Tipo"] = "mysql", -- "mysql" ou "sqlite"

        ["Host"] = "localhost",
        ["Port"] = "3306",
        ["User"] = "root",
        ["Password"] = "",
        ["Database"] = "vgrp",
    },
}
```

### Tipos de banco disponíveis

| Tipo     | Descrição                   |
| -------- | --------------------------- |
| `mysql`  | Banco de dados MySQL        |
| `sqlite` | Banco de dados SQLite local |

---

## 4. Inicie os recursos

No console do servidor:

```text
start vgrp-mysql
start vgrp
```

> ⚠️ O `vgrp-mysql` deve ser iniciado antes do `vgrp`.

---

# 🧩 Exports

## vgrp

| Função                              | Descrição                                                      |
| ----------------------------------- | -------------------------------------------------------------- |
| `hasPermission(player, perm)`       | Verifica se o jogador possui uma permissão                     |
| `hasGroup(player, group)`           | Verifica se o jogador pertence a um grupo                      |
| `hasTablePermission(player, table)` | Verifica se o jogador possui pelo menos uma permissão da lista |
| `addPlayerGroup(player, group)`     | Adiciona um grupo ao jogador                                   |
| `removePlayerGroup(player, group)`  | Remove um grupo do jogador                                     |
| `getPlayerGroups(player)`           | Retorna os grupos do jogador                                   |
| `getPlayerIdentifier(player)`       | Retorna o identificador do jogador                             |
| `isBindEventAvaliable(event)`       | Verifica se um evento de bind está disponível                  |

---

## vgrp-mysql

| Função                  | Descrição                                          |
| ----------------------- | -------------------------------------------------- |
| `dbExecute(query, ...)` | Executa queries `INSERT`, `UPDATE` e `DELETE`      |
| `dbSelect(query, ...)`  | Executa uma query `SELECT` e retorna os resultados |
| `isDatabaseReady()`     | Verifica se o banco de dados está pronto           |

---

# 🔄 Conversor MTA:SA → MTAX

O projeto também possui um **conversor automático** para auxiliar na migração de scripts do MTA:SA para o MTAX.

### Como utilizar

1. Acesse o conversor em `mta-to-mtax`
2. Cole seu código MTA:SA
3. Clique em **Converter**
4. Copie o código convertido
5. Adapte o resultado conforme necessário e utilize no seu recurso MTAX

### 🔧 Principais conversões

| MTA:SA                              | VGRP / MTAX                        |
| ----------------------------------- | ---------------------------------- |
| `getPlayerAccount(player)`          | `getElementData(player, "Vg:ID")`  |
| `getAccountName(account)`           | `tostring(id)`                     |
| `isGuestAccount(player)`            | `false`                            |
| `getPlayerSerial(player)`           | `vgrp:getPlayerIdentifier(player)` |
| `aclGetGroup(groupName)`            | `groupName`                        |
| `isObjectInACLGroup(object, group)` | `vgrp:hasGroup(object, group)`     |
| `addCommandHandler`                 | Adaptado para o sistema VGRP       |
| `bindKey`                           | Adaptado para o sistema VGRP       |

> ℹ️ O conversor tem como objetivo acelerar a migração. Dependendo do script, podem ser necessárias adaptações manuais após a conversão.

---

# 🧪 Exemplos

## Comando com permissão

```lua
addCommandHandler("kick", function(player, cmd, target)
    if not vgrp:hasPermission(player, "staff.permissao") then
        infoBoxS(player, "Sem permissão!", "error")
        return
    end

    -- Lógica do kick
end)
```

---

## Adicionar grupo a um jogador

```lua
vgrp:addPlayerGroup(1, "Admin")
```

No exemplo acima, o jogador com ID `1` recebe o grupo `Admin`.

---

## Verificar grupo

```lua
if vgrp:hasGroup(player, "Policia") then
    -- Lógica policial
end
```

---

# 🎮 Comandos disponíveis

| Comando                     | Descrição                       |
| --------------------------- | ------------------------------- |
| `/setgroup <ID> <Grupo>`    | Adiciona um grupo ao jogador    |
| `/remgroup <ID> <Grupo>`    | Remove um grupo do jogador      |
| `/vgroups [ID]`             | Lista os grupos de um jogador   |
| `/addwhitelist <player>`    | Adiciona um jogador à whitelist |
| `/removewhitelist <player>` | Remove um jogador da whitelist  |
| `/checkwhitelist [player]`  | Verifica o status da whitelist  |

---

# ⚙️ Configurações avançadas

## `vgrp/VgZinhoOoEdit.lua`

Configurações relacionadas ao sistema de compatibilidade:

```lua
Cfg = {
    ["Legacy"] = {
        ["RefreshTime"] = 1,      -- Tempo em minutos para refresh
        ["RefreshAttempts"] = 5,  -- Número de tentativas iniciais
    }
}
```

---

## Configurações do jogador

Arquivo:

```text
vgrp/player/join.lua
```

Exemplo:

```lua
local Config = {
    whitelistOnRegister = 0, -- 0 = desativado | 1 = ativado
    saveOnLogin = true,
    requireWhitelist = true,
}
```

### Opções

| Configuração          | Descrição                                                     |
| --------------------- | ------------------------------------------------------------- |
| `whitelistOnRegister` | Define se novos jogadores entram automaticamente na whitelist |
| `saveOnLogin`         | Define se os dados são salvos durante o login                 |
| `requireWhitelist`    | Exige whitelist para o jogador entrar no servidor             |

---

# 🤝 Contribuindo

Contribuições são bem-vindas!

### 1. Faça um fork

Faça um fork do repositório no GitHub.

### 2. Crie uma branch

```bash
git checkout -b feature/AmazingFeature
```

### 3. Faça suas alterações

Realize as alterações necessárias no projeto.

### 4. Commit

```bash
git commit -m "Add AmazingFeature"
```

### 5. Push

```bash
git push origin feature/AmazingFeature
```

### 6. Pull Request

Abra um **Pull Request** no repositório principal.

---

# 📞 Suporte

Caso precise de ajuda, entre em contato através dos canais oficiais:

* 💬 **Discord:** https://discord.gg/NjeRXA475g
* 📚 **Documentação:** https://docs.vgzinhostore.com
* 🌐 **Site:** https://vgzinhostore.com
* 💻 **GitHub:** https://github.com/vgzinhodev/mta-to-mtax

---

# 📄 Licença

Este projeto é distribuído sob a licença **MIT**.

Consulte o arquivo [`LICENSE`](LICENSE) para obter mais informações.

---

# 🙏 Agradecimentos

* ❤️ **Equipe MTAX** pela criação da plataforma
* 🤝 **Comunidade VgZinhoOo Store** pelo suporte
* 👨‍💻 Todos os desenvolvedores que contribuem com o projeto

---

<div align="center">
### Desenvolvido com ❤️ por **VgZinhoOo Store**
</div>
