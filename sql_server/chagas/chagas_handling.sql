create database chagas_data;
use dengue;

#Criação da tabela de notificações simples da doença de Chagas
create table notifications_chagas (
DT_NOTIFIC DATE,
    SEM_NOT VARCHAR(255),
    NU_ANO INT,
    SG_UF VARCHAR(255),
    DT_SIN_PRI DATE,
    CS_SEXO VARCHAR(10),
    CS_RACA VARCHAR(255),
    CLASSI_FIN VARCHAR(255),
    idade_anos INT
);

LOAD DATA LOCAL INFILE 'C:/Users/gabir/Documents/mysql/chagas/df_chagas.csv'
INTO TABLE notifications_chagas
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#Criação de database para a pirâmide etária

SELECT 
    CASE
        WHEN idade_anos BETWEEN 0 AND 4 THEN '0-4'
        WHEN idade_anos BETWEEN 5 AND 9 THEN '5-9'
        WHEN idade_anos BETWEEN 10 AND 14 THEN '10-14'
        WHEN idade_anos BETWEEN 15 AND 19 THEN '15-19'
        WHEN idade_anos BETWEEN 20 AND 24 THEN '20-24'
        WHEN idade_anos BETWEEN 25 AND 29 THEN '25-29'
        WHEN idade_anos BETWEEN 30 AND 34 THEN '30-34'
        WHEN idade_anos BETWEEN 35 AND 39 THEN '35-39'
        WHEN idade_anos BETWEEN 40 AND 44 THEN '40-44'
        WHEN idade_anos BETWEEN 45 AND 49 THEN '45-49'
        WHEN idade_anos BETWEEN 50 AND 54 THEN '50-54'
        WHEN idade_anos BETWEEN 55 AND 59 THEN '55-59'
        WHEN idade_anos BETWEEN 60 AND 64 THEN '60-64'
        WHEN idade_anos BETWEEN 65 AND 69 THEN '65-69'
        WHEN idade_anos BETWEEN 70 AND 74 THEN '70-74'
        WHEN idade_anos BETWEEN 75 AND 79 THEN '75-79'
        WHEN idade_anos BETWEEN 80 AND 84 THEN '80-84'
        WHEN idade_anos BETWEEN 85 AND 89 THEN '85-89'
        ELSE '90 ou mais'
    END AS faixa_etaria,
    SG_UF AS UF,
    NU_ANO AS year,
    CS_SEXO AS sex,
    CASE 
        WHEN CS_SEXO = 'Masculino' THEN COUNT(*) * -1
        WHEN CS_SEXO = 'Feminino' THEN COUNT(*)
    END AS counting
FROM 
    notifications_chagas
WHERE 
    CS_SEXO IN ('Masculino', 'Feminino')
GROUP BY 
    faixa_etaria, UF, year, sex
ORDER BY 
    FIELD(faixa_etaria, 
        '0-4', '5-9', '10-14', '15-19', '20-24', '25-29', '30-34', '35-39', '40-44', 
        '45-49', '50-54', '55-59', '60-64', '65-69', '70-74', '75-79', '80-84', 
        '85-89', '90 ou mais'),
    UF, year, sex;
#cliquei em salvar e salvei como chagas_piramide_etaria

create table chagas_piramide_etaria (
faixa_etaria VARCHAR(255),
UF VARCHAR(255),
year INT,
sex VARCHAR(255),
counting INT
);

LOAD DATA LOCAL INFILE 'C:/Users/gabir/Documents/mysql/chagas/chagas_piramide_etaria.csv'
INTO TABLE chagas_piramide_etaria
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#Criação de um banco que mostre a soma dos casos por faixa etária por UF por ano por sexo
SELECT 
    CASE
        WHEN idade_anos BETWEEN 0 AND 4 THEN '0-4'
        WHEN idade_anos BETWEEN 5 AND 9 THEN '5-9'
        WHEN idade_anos BETWEEN 10 AND 14 THEN '10-14'
        WHEN idade_anos BETWEEN 15 AND 19 THEN '15-19'
        WHEN idade_anos BETWEEN 20 AND 24 THEN '20-24'
        WHEN idade_anos BETWEEN 25 AND 29 THEN '25-29'
        WHEN idade_anos BETWEEN 30 AND 34 THEN '30-34'
        WHEN idade_anos BETWEEN 35 AND 39 THEN '35-39'
        WHEN idade_anos BETWEEN 40 AND 44 THEN '40-44'
        WHEN idade_anos BETWEEN 45 AND 49 THEN '45-49'
        WHEN idade_anos BETWEEN 50 AND 54 THEN '50-54'
        WHEN idade_anos BETWEEN 55 AND 59 THEN '55-59'
        WHEN idade_anos BETWEEN 60 AND 64 THEN '60-64'
        WHEN idade_anos BETWEEN 65 AND 69 THEN '65-69'
        WHEN idade_anos BETWEEN 70 AND 74 THEN '70-74'
        WHEN idade_anos BETWEEN 75 AND 79 THEN '75-79'
        WHEN idade_anos BETWEEN 80 AND 84 THEN '80-84'
        WHEN idade_anos BETWEEN 85 AND 89 THEN '85-89'
        ELSE '90 ou mais'
    END AS faixa_etaria,
    SG_UF AS UF,
    NU_ANO AS year,
    CS_SEXO AS sex,
    COUNT(*) AS counting
FROM 
    notifications_chagas
WHERE 
    CS_SEXO IN ('Masculino', 'Feminino')
GROUP BY 
    faixa_etaria, UF, year, sex

UNION ALL

SELECT 
    'Todos' AS faixa_etaria,
    SG_UF AS UF,
    NU_ANO AS year,
    CS_SEXO AS sex,
    COUNT(*) AS counting
FROM 
    notifications_chagas
WHERE 
    CS_SEXO IN ('Masculino', 'Feminino')
GROUP BY 
    SG_UF, NU_ANO, CS_SEXO

ORDER BY 
    FIELD(faixa_etaria, 
        '0-4', '5-9', '10-14', '15-19', '20-24', '25-29', '30-34', '35-39', '40-44', 
        '45-49', '50-54', '55-59', '60-64', '65-69', '70-74', '75-79', '80-84', 
        '85-89', '90 ou mais', 'Todos'),
    UF, year, sex;
    
#Salvei como chagas_ano

create table chagas_ano (
faixa_etaria VARCHAR(255),
UF VARCHAR(255),
year INT,
sex VARCHAR(255),
counting INT
);

LOAD DATA LOCAL INFILE 'C:/Users/gabir/Documents/mysql/chagas/chagas_ano.csv'
INTO TABLE chagas_ano
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
