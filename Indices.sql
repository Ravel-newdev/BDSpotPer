
DROP INDEX IF EXISTS idx_faixa_cod_album ON faixa;
GO

CREATE NONCLUSTERED INDEX idx_faixa_cod_album
ON faixa(cod_album)
WITH (FILLFACTOR = 100)
ON FG_INDICES;
GO

DROP INDEX IF EXISTS idx_faixa_tipo_composicao ON faixa;
GO

CREATE NONCLUSTERED INDEX idx_faixa_tipo_composicao
ON faixa(cod_composicao)
WITH (FILLFACTOR = 100)
ON FG_INDICES;
GO