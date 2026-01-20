--Povoamento do BD

INSERT INTO periodo_musical (cod_periodo, descricao, ano_inicio, ano_fim) VALUES
(1, 'Barroco', 1600, 1750),
(2, 'Classico', 1750, 1820),
(3, 'Romantico', 1810, 1910),
(4, 'Moderno', 1910, 2024);

INSERT INTO tipo_composicao (cod_composicao, descricao) VALUES
(1, 'Concerto'), 
(2, 'Sinfonia'), 
(3, 'Sonata'), 
(4, 'Opera');


INSERT INTO gravadora (cod_gravadora, nome, endereco, telefone, home_page) VALUES
(1, 'Sony Classical', 'New York, USA', '555-0100', 'www.sony.com'),
(2, 'Deutsche Grammophon', 'Berlin, Germany', '555-0200', 'www.dg.com'), 
(3, 'Universal Music', 'London, UK', '555-0300', 'www.universal.com');


INSERT INTO compositor (cod_compositor, nome, cidade_nascimento, pais_nascimento, data_nascimento, data_morte, cod_periodo) VALUES
(1, 'Antonio Vivaldi', 'Veneza', 'Italia', '1678-03-04', '1741-07-28', 1), 
(2, 'Johann Sebastian Bach', 'Eisenach', 'Alemanha', '1685-03-31', '1750-07-28', 1), 
(3, 'Antonin Dvorack', 'Nelahozeves', 'Republica Tcheca', '1841-09-08', '1904-05-01', 3), 
(4, 'Ludwig van Beethoven', 'Bonn', 'Alemanha', '1770-12-17', '1827-03-26', 2); 


INSERT INTO interprete (cod_interprete, nome, tipo) VALUES
(1, 'Berliner Philharmoniker', 'Orquestra'),
(2, 'Yo-Yo Ma', 'Violoncelista');


INSERT INTO album (cod_album, nome, descricao, preco_compra, data_compra, tipo_compra, data_gravacao, meio_fisico, cod_gravadora) VALUES
(1, 'Vivaldi Master', 'As Quatro Estacoes', 40.00, '2023-01-01', 'CD', '2010-01-01', 'CD', 1), 
(2, 'Bach Gold', 'Concertos de Brandenburgo', 50.00, '2023-02-01', 'CD', '2015-01-01', 'CD', 2), 
(3, 'Dvorak Symphony', 'Sinfonia Novo Mundo', 45.00, '2023-03-01', 'CD', '2005-01-01', 'CD', 2), 
(4, 'Beethoven Hits', 'Sonatas para Piano', 60.00, '2023-04-01', 'Download', '2018-01-01', 'Download', 3), 
(5, 'Luxo Classics', 'Album Super Caro', 150.00, '2024-01-01', 'Vinil', '2020-01-01', 'Vinil', 1); 


INSERT INTO faixa (id_faixa, num_faixa, descricao, tempo_execucao, tipo_gravacao, cod_composicao, cod_album) VALUES
(1, 1, 'Primavera - Allegro', 200, 'DDD', 1, 1),
(2, 2, 'Verao - Presto', 180, 'DDD', 1, 1),
(3, 1, 'Brandenburg No. 3', 600, 'DDD', 1, 2),
(4, 2, 'Air on G String', 300, 'DDD', 1, 2),
(5, 1, 'New World - Largo', 700, 'ADD', 2, 3),
(6, 2, 'New World - Allegro', 550, 'ADD', 2, 3),
(7, 1, 'Moonlight Sonata', 400, NULL, 3, 4), 
(8, 1, 'Faixa de Ouro', 300, NULL, 3, 5);


INSERT INTO faixa_compositor (id_faixa, id_compositor) VALUES
(1, 1), (2, 1), 
(3, 2), (4, 2), 
(5, 3), (6, 3), 
(7, 4), (8, 4); 


INSERT INTO faixa_interprete (id_faixa, id_interprete) VALUES
(1, 1), (2, 1), (5, 1), (6, 1), 
(3, 2), (4, 2), (7, 2); 


INSERT INTO playlist (id_playlist, data_criacao, nome, tempo_total) VALUES (1, GETDATE(), 'Mix Geral', 0);
INSERT INTO playlist (id_playlist, data_criacao, nome, tempo_total) VALUES (2, GETDATE(), 'Dvorack Hits', 0);
INSERT INTO playlist (id_playlist, data_criacao, nome, tempo_total) VALUES (3, GETDATE(), 'Barroco Concertos', 0);
INSERT INTO playlist (id_playlist, data_criacao, nome, tempo_total) VALUES (4, GETDATE(), 'Quase Barroco', 0);


INSERT INTO playlist_faixa (id_playlist, id_faixa, data_ultima_execucao, numero_execucoes) VALUES 
(1, 1, GETDATE(), 10), 
(1, 5, GETDATE(), 5),  
(2, 5, GETDATE(), 20), 
(2, 6, GETDATE(), 15), 
(3, 1, GETDATE(), 5), 
(3, 3, GETDATE(), 8), 
(4, 1, GETDATE(), 2), 
(4, 7, GETDATE(), 1); 
GO


