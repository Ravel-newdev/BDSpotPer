# BDSpotPer

Um sistema de gerenciamento de playlists musicais inspirado no Spotify, desenvolvido como projeto acadêmico de Banco de Dados. Combina um banco de dados relacional em **SQL Server** com uma aplicação de terminal em **Python**.

---

## 📋 Sobre o Projeto

O **BDSpotPer** modela um acervo musical completo, permitindo cadastrar e gerenciar playlists, faixas, álbuns, compositores, intérpretes e gravadoras. O sistema oferece operações CRUD completas via terminal e consultas analíticas sobre o acervo.

---

## 🗂️ Estrutura do Repositório

```
BDSpotPer/
├── Create_Database.sql    # Criação do banco e filegroups
├── Create_Tables.sql      # Definição de todas as tabelas
├── Relationships.sql      # Chaves estrangeiras e relacionamentos
├── Indices.sql            # Criação de índices para performance
├── Povoamento.sql         # Dados iniciais (seed)
├── Triggers.sql           # Triggers do banco
├── ViewMat.sql            # Views materializadas
├── F-BCOMPR.sql           # Funções e stored procedures
├── IVF.sql                # Índices adicionais / IVF
├── app.py                 # Aplicação Python (interface de terminal)
└── ERD/                   # Diagramas de Entidade-Relacionamento
```

---

## 🗄️ Modelo de Dados

O banco é composto pelas seguintes entidades principais:

| Tabela | Descrição |
|---|---|
| `playlist` | Playlists criadas pelo usuário |
| `faixa` | Músicas/faixas individuais |
| `album` | Álbuns musicais |
| `compositor` | Compositores das faixas |
| `interprete` | Intérpretes/artistas |
| `gravadora` | Gravadoras dos álbuns |
| `periodo_musical` | Períodos musicais (ex: Barroco, Clássico) |
| `tipo_composicao` | Tipos de composição (ex: Concerto, Sonata) |
| `playlist_faixa` | Relação N:N entre playlists e faixas |
| `faixa_compositor` | Relação N:N entre faixas e compositores |
| `faixa_interprete` | Relação N:N entre faixas e intérpretes |

---

##  Pré-requisitos

- **SQL Server Express** (ou superior) com instância `SQLEXPRESS01`
- **Python 3.x**
- **ODBC Driver 17 for SQL Server**
- Biblioteca Python `pyodbc`

```bash
pip install pyodbc
```

---

## Como Executar

### 1. Configurar o Banco de Dados

Execute os scripts SQL na seguinte ordem no SQL Server Management Studio (SSMS):

```sql
-- 1. Criar o banco
Create_Database.sql

-- 2. Criar as tabelas
Create_Tables.sql

-- 3. Definir relacionamentos
Relationships.sql

-- 4. Criar índices
Indices.sql

-- 5. Popular com dados iniciais
Povoamento.sql

-- 6. Criar triggers
Triggers.sql

-- 7. Criar views materializadas
ViewMat.sql
```

### 2. Configurar a Conexão

No arquivo `app.py`, ajuste a string de conexão conforme sua máquina:

```python
conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost\SQLEXPRESS01;"  # ← altere aqui se necessário
    "DATABASE=BDSpotPer;"
    "Trusted_Connection=yes;"
)
```

### 3. Rodar a Aplicação

```bash
python app.py
```

---

## Funcionalidades da Aplicação

Ao iniciar, o terminal exibe um menu com as seguintes opções:

```
===========================
       SPOTIFY BD (MENU)
===========================

1-Criar | 2-Ver | 3-Editar | 4-Excluir | 5-Relatórios | 6-Sair
```

### 1 — Criar Playlist
Cria uma nova playlist com nome definido pelo usuário e permite adicionar faixas de diferentes álbuns.

### 2 — Ver Playlists
Lista todas as playlists com ID, nome e quantidade de músicas.

### 3 — Editar Playlist
Permite renomear a playlist, adicionar novas faixas ou remover faixas existentes.

### 4 — Excluir Playlist
Remove uma playlist e todas as suas associações de faixas após confirmação.

### 5 — Relatórios / Consultas
Consultas analíticas sobre o acervo:

| Opção | Consulta |
|---|---|
| **A** | Álbuns com preço acima da média |
| **B** | Gravadora com mais playlists contendo obras de Dvořák |
| **C** | Compositor com mais faixas em playlists |
| **D** | Playlists compostas exclusivamente por concertos do período Barroco |

---

## 🛠️ Tecnologias Utilizadas

- **SQL Server / T-SQL** — banco de dados relacional
- **Python 3** — lógica da aplicação
- **pyodbc** — conexão Python ↔ SQL Server

---

## 👥 Contribuidores

Veja a lista de contribuidores em [github.com/Ravel-newdev/BDSpotPer/graphs/contributors](https://github.com/Ravel-newdev/BDSpotPer/graphs/contributors).
