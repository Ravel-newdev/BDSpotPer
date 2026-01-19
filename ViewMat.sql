
-- Apaga a view antiga para não dar erro de "já existe"
DROP VIEW IF EXISTS dbo.vw_playlist_qtd_albuns;
GO

-- Cria a View (Versão Simplificada)
CREATE VIEW dbo.vw_playlist_qtd_albuns
WITH SCHEMABINDING
AS
SELECT 
    p.nome,
    f.cod_album,
    COUNT_BIG(*) AS qtd_albuns
FROM dbo.playlist p
JOIN dbo.playlist_faixa pf ON p.id_playlist = pf.id_playlist
JOIN dbo.faixa f ON pf.id_faixa = f.id_faixa
GROUP BY p.nome, f.cod_album;
GO

-- Cria o Índice (Materializa a View)
CREATE UNIQUE CLUSTERED INDEX idx_materializado
ON dbo.vw_playlist_qtd_albuns(nome, cod_album)
ON FG_INDICES;
GO