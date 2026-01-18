CREATE TRIGGER trg_album_barroco_ddd
ON faixa
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted f
        JOIN album a ON a.cod_album = f.cod_album
        JOIN periodo p ON p.cod_periodo = a.cod_periodo
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

CREATE TRIGGER trg_album_delete
ON album
INSTEAD OF DELETE
AS
BEGIN
    DELETE pf
    FROM playlist_faixa pf
    JOIN faixa f ON f.id_faixa = pf.id_faixa
    JOIN deleted d ON d.cod_album = f.cod_album;

    DELETE fi
    FROM faixa_interprete fi
    JOIN faixa f ON f.id_faixa = fi.id_faixa
    JOIN deleted d ON d.cod_album = f.cod_album;

    DELETE f
    FROM faixa f
    JOIN deleted d ON d.cod_album = f.cod_album;

    DELETE FROM album
    WHERE cod_album IN (SELECT cod_album FROM deleted);
END;

CREATE OR ALTER TRIGGER trg_preco_album
ON album
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @media DECIMAL(10,2);

    -- Média apenas de álbuns que têm SOMENTE faixas DDD
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

    -- Se ainda não houver base suficiente, bloqueia valores absurdos
    IF @media IS NULL
        SET @media = 100;  -- valor de referência inicial

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
