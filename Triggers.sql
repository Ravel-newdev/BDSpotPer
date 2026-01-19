--Trigger para validar Álbum Barroco (só aceita DDD)
CREATE TRIGGER trg_album_barroco_ddd
ON faixa
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted f
        JOIN album a ON a.cod_album = f.cod_album
        JOIN periodo_musical p ON p.cod_periodo = a.cod_album -- Atenção: no seu original estava 'periodo', mas a tabela certa é 'periodo_musical' conforme seu create tables
        WHERE p.descricao = 'Barroco'
          AND f.tipo_gravacao <> 'DDD'
    )
    BEGIN
        RAISERROR (
            'Álbum barroco só pode ter faixas com tipo de gravação DDD.',
            16, 1
        );
        ROLLBACK TRANSACTION;
    END
END;
GO 

--Trigger para limitar 64 faixas (Havia uma duplicata aqui, deixei apenas um)
CREATE TRIGGER trg_max_64_faixas
ON faixa
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT cod_album
        FROM faixa
        GROUP BY cod_album
        HAVING COUNT(*) > 64
    )
    BEGIN
        RAISERROR (
            'Um álbum não pode ter mais que 64 faixas.',
            16, 1
        );
        ROLLBACK TRANSACTION;
    END
END;
GO 

--Trigger para deletar em cascata (Delete álbum apaga faixas)
CREATE TRIGGER trg_album_delete
ON album
INSTEAD OF DELETE
AS
BEGIN
    -- Apaga da tabela de ligação playlist_faixa
    DELETE pf
    FROM playlist_faixa pf
    JOIN faixa f ON f.id_faixa = pf.id_faixa
    JOIN deleted d ON d.cod_album = f.cod_album;

    -- Apaga da tabela de ligação faixa_interprete
    DELETE fi
    FROM faixa_interprete fi
    JOIN faixa f ON f.id_faixa = fi.id_faixa
    JOIN deleted d ON d.cod_album = f.cod_album;
    
    -- Apaga da tabela de ligação faixa_compositor (faltou essa)
    DELETE fc
    FROM faixa_compositor fc
    JOIN faixa f ON f.id_faixa = fc.id_faixa
    JOIN deleted d ON d.cod_album = f.cod_album;

    -- Apaga as faixas
    DELETE f
    FROM faixa f
    JOIN deleted d ON d.cod_album = f.cod_album;

    -- Finalmente apaga o álbum
    DELETE FROM album
    WHERE cod_album IN (SELECT cod_album FROM deleted);
END;
GO 


CREATE OR ALTER TRIGGER trg_preco_album
ON album
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @media DECIMAL(10,2);

    -- Calcula a média
    SELECT @media = AVG(a.preco_compra)
    FROM album a
    WHERE EXISTS (
        SELECT 1
        FROM faixa f
        WHERE f.cod_album = a.cod_album
    )
    AND NOT EXISTS (
        SELECT 1
        FROM faixa f
        WHERE f.cod_album = a.cod_album
          AND f.tipo_gravacao <> 'DDD'
    );

    IF @media IS NULL
        SET @media = 100;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.preco_compra > 3 * @media
    )
    BEGIN
        RAISERROR (
            'Preço do álbum excede 3x a média dos álbuns DDD.',
            16, 1
        );
        ROLLBACK TRANSACTION;
    END
END;
GO 