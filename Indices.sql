
-- 1. Índice sobre o código do álbum
-- Primeiro, verifica se já existe e apaga (para não dar erro ao rodar de novo)
DROP INDEX IF EXISTS idx_faixa_cod_album ON faixa;
GO

CREATE NONCLUSTERED INDEX idx_faixa_cod_album
ON faixa(cod_album)
WITH (FILLFACTOR = 100)
ON FG_INDICES;
GO

-- 2. Índice sobre o tipo de composição
-- Primeiro, verifica se já existe e apaga
DROP INDEX IF EXISTS idx_faixa_tipo_composicao ON faixa;
GO

CREATE NONCLUSTERED INDEX idx_faixa_tipo_composicao
ON faixa(cod_composicao)
WITH (FILLFACTOR = 100)
ON FG_INDICES;
GO