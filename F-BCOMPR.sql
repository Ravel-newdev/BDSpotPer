
-- Apaga a função antiga para não dar erro de "já existe"
DROP FUNCTION IF EXISTS dbo.fn_albuns_por_compositor;
GO

--Cria a função
CREATE FUNCTION dbo.fn_albuns_por_compositor (@nome VARCHAR(100))
RETURNS TABLE
AS
RETURN
(
    -- Seleciona apenas o nome do álbum, sem repetir
    SELECT DISTINCT a.nome
    FROM album a
    JOIN faixa f ON a.cod_album = f.cod_album
    JOIN faixa_compositor fc ON f.id_faixa = fc.id_faixa
    JOIN compositor c ON fc.id_compositor = c.cod_compositor
    WHERE c.nome LIKE '%' + @nome + '%'
);
GO