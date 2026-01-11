create table playlist(
id_playlist int primary key,
data_criacao date not null,
nome varchar(100) not null,
tempo_total int not null
) on FG_INDICES;

create table faixa (
	id_faixa int primary key,
	num_faixa int not null,
	descricao varchar(200) not null,
	tempo_execucao int not null,
	tipo_gravacao char(1),
	cod_composicao int not null,
	cod_album int not null,
)on FG_INDICES;

create table album (
	cod_album int primary key,
	nome varchar(100) not null,
	descricao varchar(200) not null,
	preco_compra decimal(10,2) not null,
	data_compra date not null,
	tipo_compra varchar(30) not null,
	data_gravacao date not null,
	meio_fisico varchar(10) not null,
	cod_gravadora int not null
)
on FG_DADOS;

create table tipo_composicao (
    cod_composicao int primary key,
    descricao varchar(100) not null
)
on FG_DADOS;

create table interprete (
    cod_interprete int primary key,
    nome varchar(100) not null,
    tipo varchar(50) not null
)
on FG_DADOS;

create table compositor (
    cod_compositor int primary key,
    nome varchar(100) not null,
    cidade_nascimento varchar(100) not null,
    pais_nascimento varchar(100) not null,
    data_nascimento date not null,
    data_morte date,
    cod_periodo int not null
)
on FG_DADOS;

create table periodo_musical (
    cod_periodo int primary key,
    descricao varchar(50) not null,
    ano_inicio int not null,
    ano_fim int not null
)
on FG_DADOS;

create table gravadora (
    cod_gravadora int primary key,
    nome varchar(100) not null,
    endereco varchar(200) not null,
    telefone varchar(50),
    home_page varchar(200)
)
on FG_DADOS;

create table playlist_faixa (
    id_playlist int not null,
    id_faixa int not null,
    data_ultima_execucao date,
    numero_execucoes int not null,

    primary key (id_playlist, id_faixa)
)
on FG_INDICES;

create table faixa_compositor (
    id_faixa int not null,
    id_compositor int not null,

    primary key (id_faixa, id_compositor)
)
on FG_DADOS;

create table faixa_interprete (
    id_faixa int not null,
    id_interprete int not null,

    primary key (id_faixa, id_interprete)
)
on FG_DADOS;