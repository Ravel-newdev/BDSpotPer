import pyodbc
# Tenta conectar. Se der erro, mostra mensagem e fecha, mas da certo
try:
    conn = pyodbc.connect(
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=localhost\SQLEXPRESS01;" #lembrar de mudar quando trocar de maquina
        "DATABASE=BDSpotPer;"
        "Trusted_Connection=yes;"
    )
    cursor = conn.cursor()
    print("--- Banco Conectado! ---")
except:
    print("ERRO: Não foi possível conectar ao banco de dados.")
    exit()

def existe_playlist(id_playlist): #def ajuda a verificar se o id existe
    # Se não for número, já retorna falso
    try:
        int(id_playlist)
    except:
        return False

    # Vai no banco e conta quantas playlists tem com esse ID
    cursor.execute("SELECT COUNT(*) FROM playlist WHERE id_playlist = ?", id_playlist)
    quantidade = cursor.fetchone()[0]
    
    if quantidade > 0:
        return True
    else:
        return False

#def principais

def criar_playlist():
    print("\n--- CRIAR ---")
    nome = input("Nome da Playlist: ")
    
    # Validação: Nome não pode ser vazio
    if nome == "":
        print("Erro: O nome não pode ser vazio.")
        return

    try:
        # Pega o próximo ID
        cursor.execute("SELECT ISNULL(MAX(id_playlist), 0) + 1 FROM playlist")
        novo_id = cursor.fetchone()[0]

        # Cria a playlist
        cursor.execute("INSERT INTO playlist (id_playlist, nome, data_criacao, tempo_total) VALUES (?, ?, GETDATE(), 0)", (novo_id, nome))
        conn.commit()
        print(f"Playlist '{nome}' criada!")

        # Loop para adicionar músicas (uma por uma)
        contador_musicas = 0
        
        while True:
            print(f"\n--- Adicionar Música (Total: {contador_musicas}) ---")
            print("1 - Adicionar uma faixa")
            print("2 - Terminar e Salvar")
            opcao = input("Escolha: ")

            if opcao == "2":
                # Validação: Não pode salvar vazia
                if contador_musicas == 0:
                    print("Erro: A playlist precisa de pelo menos uma música!")
                else:
                    print("Playlist salva com sucesso!")
                    break # Sai do loop
            
            elif opcao == "1":
                # Mostra Álbuns
                print("--- Álbuns ---")
                cursor.execute("SELECT cod_album, nome FROM album")
                for a in cursor.fetchall():
                    print(f"ID: {a.cod_album} - {a.nome}")
                
                # Tenta pegar o ID do álbum
                try:
                    id_album = input("Digite o ID do Álbum: ")
                    
                    # Mostra Faixas
                    cursor.execute("SELECT id_faixa, descricao FROM faixa WHERE cod_album = ?", id_album)
                    faixas = cursor.fetchall()
                    
                    if not faixas:
                        print("Album vazio ou ID errado.")
                        continue # Volta pro inicio do loop

                    print("--- Músicas ---")
                    for f in faixas:
                        print(f"ID: {f.id_faixa} - {f.descricao}")

                    id_musica = input("Digite o ID da música para adicionar: ")
                    
                    # Tenta Inserir
                    cursor.execute("INSERT INTO playlist_faixa VALUES (?, ?, GETDATE(), 0)", (novo_id, id_musica))
                    conn.commit()
                    contador_musicas = contador_musicas + 1
                    print("Sucesso: Música adicionada!")
                
                except:
                    # Captura erro de ID duplicado ou ID inexistente
                    print("Erro: ID inválido ou música já está na playlist.")

    except Exception as e:
        print("Erro grave ao criar playlist:", e)
        conn.rollback()


def ver_playlists():
    print("\n--- LISTA ---")
    cursor.execute("SELECT p.id_playlist, p.nome, COUNT(pf.id_faixa) FROM playlist p LEFT JOIN playlist_faixa pf ON p.id_playlist = pf.id_playlist GROUP BY p.id_playlist, p.nome")
    lista = cursor.fetchall()
    
    if not lista:
        print("Nenhuma playlist encontrada.")
    
    for item in lista:
        # item[0] é o ID, item[1] é o Nome, item[2] é a Quantidade
        print(f"ID: {item[0]} | Nome: {item[1]} | Músicas: {item[2]}")


def atualizar_playlist():
    ver_playlists()
    pid = input("\nID da Playlist para editar: ")

    # Validação: Verifica se existe
    if existe_playlist(pid) == False:
        print("Erro: Essa playlist não existe.")
        return

    print("1-Mudar Nome | 2-Add Música | 3-Remover Música")
    op = input("Opção: ")

    try:
        if op == "1":
            novo = input("Novo nome: ")
            if novo != "":
                cursor.execute("UPDATE playlist SET nome = ? WHERE id_playlist = ?", (novo, pid))
                conn.commit()
                print("Nome alterado.")
            else:
                print("Nome inválido.")

        elif op == "2":
            # Pede ID do album direto pra simplificar
            id_alb = input("Digite o ID do Album (olhe a lista antes): ")
            
            cursor.execute("SELECT id_faixa, descricao FROM faixa WHERE cod_album = ?", id_alb)
            faixas = cursor.fetchall()
            
            if faixas:
                for f in faixas: print(f"{f.id_faixa} - {f.descricao}")
                
                id_mus = input("Digite o ID da música: ")
                cursor.execute("INSERT INTO playlist_faixa VALUES (?, ?, GETDATE(), 0)", (pid, id_mus))
                conn.commit()
                print("Adicionada!")
            else:
                print("Album não encontrado.")

        elif op == "3":
            # Mostra músicas da playlist
            cursor.execute("SELECT pf.id_faixa, f.descricao FROM playlist_faixa pf JOIN faixa f ON pf.id_faixa = f.id_faixa WHERE pf.id_playlist = ?", pid)
            musicas = cursor.fetchall()
            
            if not musicas:
                print("Playlist vazia.")
                return

            for m in musicas: print(f"ID: {m.id_faixa} - {m.descricao}")
            
            id_mus = input("ID da música para remover: ")
            cursor.execute("DELETE FROM playlist_faixa WHERE id_playlist = ? AND id_faixa = ?", (pid, id_mus))
            
            if cursor.rowcount > 0:
                conn.commit()
                print("Removida.")
            else:
                print("Música não encontrada na playlist.")

    except:
        print("Erro: Operação falhou (Verifique os IDs).")


def excluir_playlist():
    ver_playlists()
    pid = input("\nID para apagar: ")

    if existe_playlist(pid) == False:
        print("Erro: ID não existe.")
        return

    confirma = input("Tem certeza? (S/N): ")
    if confirma == "S" or confirma == "s":
        try:
            cursor.execute("DELETE FROM playlist_faixa WHERE id_playlist = ?", pid)
            cursor.execute("DELETE FROM playlist WHERE id_playlist = ?", pid)
            conn.commit()
            print("Playlist apagada.")
        except:
            print("Erro ao apagar.")
    else:
        print("Cancelado.")


def consultas():
    print("A-Preço | B-Gravadora | C-Compositor | D-Barroco")
    op = input("Escolha: ")
    
    try:
        if op == "A" or op == "a":
            cursor.execute("SELECT nome, preco_compra FROM album WHERE preco_compra > (SELECT AVG(preco_compra) FROM album)")
            for r in cursor.fetchall(): print(f"{r.nome} - {r.preco_compra}")

        elif op == "B" or op == "b":
            
            sql = "SELECT TOP 1 g.nome, COUNT(DISTINCT pf.id_playlist) FROM gravadora g JOIN album a ON a.cod_gravadora = g.cod_gravadora JOIN faixa f ON f.cod_album = a.cod_album JOIN faixa_compositor fc ON fc.id_faixa = f.id_faixa JOIN compositor c ON c.cod_compositor = fc.id_compositor JOIN playlist_faixa pf ON pf.id_faixa = f.id_faixa WHERE c.nome LIKE '%Dvorack%' GROUP BY g.nome ORDER BY 2 DESC"
            cursor.execute(sql)
            r = cursor.fetchone()
            if r:
                print(f"Gravadora: {r[0]} - Playlists: {r[1]}")
            else:
                print("Sem dados para Dvorack.")

        elif op == "C" or op == "c":
            sql = "SELECT TOP 1 c.nome, COUNT(pf.id_faixa) FROM playlist_faixa pf JOIN faixa f ON f.id_faixa = pf.id_faixa JOIN faixa_compositor fc ON fc.id_faixa = f.id_faixa JOIN compositor c ON c.cod_compositor = fc.id_compositor GROUP BY c.nome ORDER BY 2 DESC"
            cursor.execute(sql)
            r = cursor.fetchone()
            if r:
                print(f"Compositor: {r[0]} - Faixas: {r[1]}")
            else:
                print("Sem dados.")

        elif op == "D" or op == "d":
            sql = "SELECT p.nome FROM playlist p WHERE EXISTS (SELECT 1 FROM playlist_faixa WHERE id_playlist = p.id_playlist) AND NOT EXISTS (SELECT 1 FROM playlist_faixa pf JOIN faixa f ON f.id_faixa = pf.id_faixa JOIN tipo_composicao tc ON tc.cod_composicao = f.cod_composicao JOIN faixa_compositor fc ON fc.id_faixa = f.id_faixa JOIN compositor c ON c.cod_compositor = fc.id_compositor LEFT JOIN periodo_musical pm ON pm.cod_periodo = c.cod_periodo WHERE pf.id_playlist = p.id_playlist AND (tc.descricao <> 'Concerto' OR ISNULL(pm.descricao,'') <> 'Barroco'))"
            cursor.execute(sql)
            for r in cursor.fetchall(): print(r[0])
            
    except:
        print("Erro na consulta.")

#menu
while True:

    print("\n===========================")
    print("    SPOTIFY BD (MENU)    ")
    print("===========================")
    print("\n1-Criar | 2-Ver | 3-Editar | 4-Excluir | 5-Relatórios | 6-Sair")
    opcao = input("Opção: ")

    if opcao == "1":
        criar_playlist()
    elif opcao == "2":
        ver_playlists()
    elif opcao == "3":
        atualizar_playlist()
    elif opcao == "4":
        excluir_playlist()
    elif opcao == "5":
        consultas()
    elif opcao == "6":
        conn.close()
        break
    else:
        print("Opção inválida.")