CREATE DATABASE BDSpotPer
ON 
PRIMARY (
    NAME = BDSpotPer_Primary,
    FILENAME = 'C:\SQLData\BDSpotPer_Primary.mdf',
    SIZE = 10MB,
    FILEGROWTH = 5MB
),

FILEGROUP FG_DADOS (
    NAME = BDSpotPer_Dados1,
    FILENAME = 'C:\SQLData\BDSpotPer_Dados1.ndf',
    SIZE = 10MB,
    FILEGROWTH = 5MB
),
(
    NAME = BDSpotPer_Dados2,
    FILENAME = 'C:\SQLData\BDSpotPer_Dados2.ndf',
    SIZE = 10MB,
    FILEGROWTH = 5MB
),

FILEGROUP FG_INDICES (
    NAME = BDSpotPer_Indices,
    FILENAME = 'C:\SQLData\BDSpotPer_Indices.ndf',
    SIZE = 10MB,
    FILEGROWTH = 5MB
)

LOG ON (
    NAME = BDSpotPer_Log,
    FILENAME = 'C:\SQLLogs\BDSpotPer_Log.ldf',
    SIZE = 5MB,
    FILEGROWTH = 5MB
);
