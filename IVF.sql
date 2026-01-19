
CREATE NONCLUSTERED INDEX idx_faixa_cod_album
ON faixa(cod_album)
WITH (FILLFACTOR = 100)
ON FG_INDICES;
GO 

CREATE NONCLUSTERED INDEX idx_faixa_tipo_composicao
ON faixa(cod_composicao)
WITH (FILLFACTOR = 100)
ON FG_INDICES;
GO  

-- 2. Seus Testes (INSERTs e DELETEs)
INSERT INTO faixa VALUES (1, 1, 'Teste', 300, 'ADD', 1, 1);
DELETE FROM album WHERE cod_album = 1;
INSERT INTO album VALUES (99, 'Teste', 'Teste', 99999, GETDATE(), 'Compra', GETDATE(), 'CD', 1);
INSERT INTO album VALUES (9999, 'Teste', 'Teste', 999999, GETDATE(), 'Compra', GETDATE(), 'CD', 3);

-- Movi este SELECT para o final, pois a função ainda não existe aqui
-- SELECT * FROM fn_albuns_por_compositor('Mozart'); 
GO  


CREATE VIEW dbo.vw_playlist_qtd_albuns
WITH SCHEMABINDING
AS
SELECT 
    p.id_playlist,
    p.nome AS nome_playlist,
    COUNT_BIG(*) AS qtd_albuns
FROM dbo.playlist p
JOIN dbo.playlist_faixa pf ON p.id_playlist = pf.id_playlist
JOIN dbo.faixa f ON pf.id_faixa = f.id_faixa
GROUP BY p.id_playlist, p.nome, f.cod_album;
GO  

-- Comentei o DROP, senão você apaga o trabalho que acabou de fazer
-- DROP VIEW vw_playlist_qtd_albuns; 


CREATE FUNCTION dbo.fn_albuns_por_compositor (@nome VARCHAR(100))
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT a.cod_album, a.nome
    FROM album a
    JOIN faixa f ON a.cod_album = f.cod_album
    JOIN faixa_compositor fc ON f.id_faixa = fc.id_faixa
    JOIN compositor c ON fc.id_compositor = c.cod_compositor
    WHERE c.nome LIKE '%' + @nome + '%'
);
GO 

-- teste
SELECT * FROM dbo.fn_albuns_por_compositor('Bach');
SELECT * FROM dbo.fn_albuns_por_compositor('Mozart');