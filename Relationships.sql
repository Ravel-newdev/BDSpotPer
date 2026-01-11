alter table faixa add CONSTRAINT fk_faixa_album
 FOREIGN KEY (cod_album)
 REFERENCES album(cod_album)
 ON DELETE CASCADE;

 alter table playlist_faixa add CONSTRAINT fk_pf_playlist
 FOREIGN KEY (id_playlist)
 REFERENCES playlist(id_playlist);

 alter table playlist_faixa add CONSTRAINT fk_pf_faixa
 FOREIGN KEY (id_faixa)
 REFERENCES faixa(id_faixa);

 ALTER TABLE album
ADD CONSTRAINT ck_album_barroco_ddd
CHECK (
    periodo <> 'Barroco'
    OR tipo_gravacao = 'DDD'
);

alter table faixa alter column tipo_gravacao varchar(3);