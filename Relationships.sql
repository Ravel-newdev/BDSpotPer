
-- Cria a chave estrangeira Faixa -> Album
ALTER TABLE faixa ADD CONSTRAINT fk_faixa_album
 FOREIGN KEY (cod_album)
 REFERENCES album(cod_album)
 ON DELETE CASCADE;
GO

--Cria a chave estrangeira Playlist_Faixa -> Playlist
ALTER TABLE playlist_faixa ADD CONSTRAINT fk_pf_playlist
 FOREIGN KEY (id_playlist)
 REFERENCES playlist(id_playlist);
GO

--Cria a chave estrangeira Playlist_Faixa -> Faixa
ALTER TABLE playlist_faixa ADD CONSTRAINT fk_pf_faixa
 FOREIGN KEY (id_faixa)
 REFERENCES faixa(id_faixa);
GO

-- O bloco do CHECK (Constraint) foi removido daqui porque ele dava erro.
-- A regra do "Barroco só aceita DDD" já está sendo feita pelo Trigger no outro arquivo.

--Aumenta o tamanho da coluna para aceitar 'ADD' e 'DDD'
ALTER TABLE faixa ALTER COLUMN tipo_gravacao VARCHAR(3);
GO