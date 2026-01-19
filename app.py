import pyodbc
#print("Instalado com sucesso!")

conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=NOTEFAMILIA\\SQLEXPRESS2023;"
    "DATABASE=BDSpotPer;"
    "Trusted_Connection=yes;"
)

cursor = conn.cursor()
print("Conectado ao BDSpotPer com sucesso!")

def criar_playlist():
    nome = input("Nome da playlist: ")

    cursor.execute("SELECT ISNULL(MAX(id_playlist),0)+1 FROM playlist")
    id_playlist = cursor.fetchone()[0]

    cursor.execute("""
        INSERT INTO playlist (id_playlist, nome, data_criacao, tempo_total)
        VALUES (?, ?, GETDATE(), 0)
    """, (id_playlist, nome))
    conn.commit()

    print("\nÁlbuns disponíveis:")
    cursor.execute("SELECT cod_album, nome FROM album")
    albuns = cursor.fetchall()

    for a in albuns:
        print(f"{a.cod_album} - {a.nome}")

    cod_album = int(input("\nEscolha o álbum: "))

    cursor.execute("""
        SELECT id_faixa, descricao, tempo_execucao 
        FROM faixa WHERE cod_album = ?
    """, cod_album)

    faixas = cursor.fetchall()

    for f in faixas:
        print(f"{f.id_faixa} - {f.descricao}")

    ids = input("Digite os IDs das faixas (separados por vírgula): ").split(",")

    for fid in ids:
        cursor.execute("""
            INSERT INTO playlist_faixa
            VALUES (?, ?, GETDATE(), 0)
        """, (id_playlist, int(fid)))

    conn.commit()
    print("\nPlaylist criada com sucesso!\n")


def manter_playlist():
    cursor.execute("SELECT id_playlist, nome FROM playlist")
    playlists = cursor.fetchall()

    print("\nPlaylists existentes:")
    for p in playlists:
        print(f"{p.id_playlist} - {p.nome}")

    pid = int(input("\nEscolha a playlist: "))

    print("\n1 - Remover música")
    print("2 - Adicionar música")
    op = input("Opção: ")

    if op == "1":
        cursor.execute("""
            SELECT f.id_faixa, f.descricao
            FROM playlist_faixa pf
            JOIN faixa f ON pf.id_faixa = f.id_faixa
            WHERE pf.id_playlist = ?
        """, pid)

        faixas = cursor.fetchall()
        for f in faixas:
            print(f"{f.id_faixa} - {f.descricao}")

        fid = int(input("Escolha a faixa para remover: "))

        cursor.execute("""
            DELETE FROM playlist_faixa
            WHERE id_playlist = ? AND id_faixa = ?
        """, (pid, fid))

        conn.commit()
        print("Faixa removida!\n")

    elif op == "2":
        cursor.execute("SELECT cod_album, nome FROM album")
        albuns = cursor.fetchall()

        for a in albuns:
            print(f"{a.cod_album} - {a.nome}")

        cod_album = int(input("Escolha o álbum: "))

        cursor.execute("""
            SELECT id_faixa, descricao
            FROM faixa WHERE cod_album = ?
        """, cod_album)

        faixas = cursor.fetchall()
        for f in faixas:
            print(f"{f.id_faixa} - {f.descricao}")

        fid = int(input("Escolha a faixa para adicionar: "))

        cursor.execute("""
            INSERT INTO playlist_faixa
            VALUES (?, ?, GETDATE(), 0)
        """, (pid, fid))

        conn.commit()
        print("Faixa adicionada!\n")

def ver_playlists():
    cursor.execute("""
        SELECT p.id_playlist, p.nome, COUNT(pf.id_faixa) AS total_faixas
        FROM playlist p
        LEFT JOIN playlist_faixa pf ON p.id_playlist = pf.id_playlist
        GROUP BY p.id_playlist, p.nome
    """)
    
    playlists = cursor.fetchall()

    print("\nPlaylists existentes:\n")
    for p in playlists:
        print(f"ID: {p.id_playlist} | Nome: {p.nome} | Faixas: {p.total_faixas}")

#consultas finais

def consulta_a():
    cursor.execute("""
        SELECT nome, preco_compra
        FROM album
        WHERE preco_compra > (SELECT AVG(preco_compra) FROM album)
    """)
    for r in cursor.fetchall():
        print(r.nome, "-", r.preco_compra)

def consulta_b():
    cursor.execute("""
        SELECT TOP 1 g.nome, COUNT(DISTINCT pf.id_playlist) AS total
        FROM gravadora g
        JOIN album a ON a.cod_gravadora = g.cod_gravadora
        JOIN faixa f ON f.cod_album = a.cod_album
        JOIN faixa_compositor fc ON fc.id_faixa = f.id_faixa
        JOIN compositor c ON c.cod_compositor = fc.id_compositor
        JOIN playlist_faixa pf ON pf.id_faixa = f.id_faixa
        WHERE c.nome = 'Dvorack'
        GROUP BY g.nome
        ORDER BY total DESC
    """)

    resultado = cursor.fetchone()

    if resultado:
        print(f"\nGravadora: {resultado.nome}")
        print(f"Total de playlists: {resultado.total}")
    else:
        print("\nNenhum resultado encontrado.")


def consulta_c():
    cursor.execute("""
        SELECT TOP 1 c.nome, COUNT(pf.id_faixa) AS total
        FROM playlist_faixa pf
        JOIN faixa f ON f.id_faixa = pf.id_faixa
        JOIN faixa_compositor fc ON fc.id_faixa = f.id_faixa
        JOIN compositor c ON c.cod_compositor = fc.id_compositor
        GROUP BY c.nome
        ORDER BY total DESC
    """)

    resultado = cursor.fetchone()

    if resultado:
        print(f"\nCompositor: {resultado.nome}")
        print(f"Total de faixas nas playlists: {resultado.total}")
    else:
        print("\nNenhum resultado encontrado.")


def consulta_d():
    cursor.execute("""
        SELECT p.nome
        FROM playlist p
        WHERE NOT EXISTS (
            SELECT 1
            FROM playlist_faixa pf
            JOIN faixa f ON f.id_faixa = pf.id_faixa
            JOIN tipo_composicao tc ON tc.cod_composicao = f.cod_composicao
            JOIN album a ON a.cod_album = f.cod_album
            JOIN compositor c ON c.cod_compositor IN (
                SELECT fc.id_compositor
                FROM faixa_compositor fc
                WHERE fc.id_faixa = f.id_faixa
            )
            JOIN periodo_musical pm ON pm.cod_periodo = c.cod_periodo
            WHERE pf.id_playlist = p.id_playlist
              AND (tc.descricao <> 'Concerto' OR pm.descricao <> 'Barroco')
        )
    """)

    resultados = cursor.fetchall()

    if resultados:
        print("\nPlaylists com apenas Concertos Barrocos:")
        for r in resultados:
            print("-", r.nome)
    else:
        print("\nNenhuma playlist atende aos critérios.")


while True:
    print("1 - Criar playlist")
    print("2 - Manter playlist")
    print("3 - Ver playlists")
    print("4 - Consulta A")
    print("5 - Consulta B")
    print("6 - Consulta C")
    print("7 - Consulta D") 
    print("8 - Sair")

    op = input("Escolha: ")

    if op == "1":
        criar_playlist()
    elif op == "2":
        manter_playlist()
    elif op == "3":
        ver_playlists()
    elif op == "4":
        consulta_a()
    elif op == "5":
        consulta_b()
    elif op == "6":
        consulta_c()
    elif op == "7":
        consulta_d()
    elif op == "8":
        break