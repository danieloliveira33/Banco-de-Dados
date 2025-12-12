CREATE DATABASE acidentes_aeronaves;
USE acidentes_aeronaves;

SET SQL_SAFE_UPDATES = 0;


-- Definição de constraints
ALTER TABLE tabela_ocorrencia ADD PRIMARY KEY (codigo_ocorrencia);

ALTER TABLE tabela_ocorrencia
ADD UNIQUE (codigo_ocorrencia1);

ALTER TABLE tabela_ocorrencia
MODIFY COLUMN codigo_ocorrencia1 INT NOT NULL;

ALTER TABLE tabela_ocorrencia
ADD UNIQUE (codigo_ocorrencia2);

ALTER TABLE tabela_ocorrencia
MODIFY COLUMN codigo_ocorrencia2 INT NOT NULL;

ALTER TABLE tabela_ocorrencia
ADD UNIQUE (codigo_ocorrencia3);

ALTER TABLE tabela_ocorrencia
MODIFY COLUMN codigo_ocorrencia3 INT NOT NULL;

ALTER TABLE tabela_ocorrencia
ADD UNIQUE (codigo_ocorrencia4);

ALTER TABLE tabela_ocorrencia
MODIFY COLUMN codigo_ocorrencia4 INT NOT NULL;

describe tabela_ocorrencia;

ALTER TABLE tabela_tipo_ocorrencia
MODIFY COLUMN codigo_ocorrencia1 INT NOT NULL;
DESCRIBE tabela_tipo_ocorrencia;

ALTER TABLE tabela_aeronave
MODIFY COLUMN codigo_ocorrencia2 INT NOT NULL;
DESCRIBE tabela_aeronave;

ALTER TABLE tabela_fator_contribuinte
MODIFY COLUMN codigo_ocorrencia3 INT NOT NULL;
DESCRIBE tabela_fator_contribuinte;

ALTER TABLE tabela_recomendacao_seguranca
MODIFY COLUMN codigo_ocorrencia4 INT NOT NULL;
DESCRIBE tabela_recomendacao_seguranca;

-- Criação de chaves estrangeiras nas tabelas externas
SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE tabela_tipo_ocorrencia
ADD FOREIGN KEY (codigo_ocorrencia1) REFERENCES tabela_ocorrencia(codigo_ocorrencia1);

ALTER TABLE tabela_aeronave
ADD FOREIGN KEY (codigo_ocorrencia2) REFERENCES tabela_ocorrencia(codigo_ocorrencia2);

ALTER TABLE tabela_fator_contribuinte
ADD FOREIGN KEY (codigo_ocorrencia3) REFERENCES tabela_ocorrencia(codigo_ocorrencia3);

ALTER TABLE tabela_recomendacao_seguranca
ADD FOREIGN KEY (codigo_ocorrencia4) REFERENCES tabela_ocorrencia(codigo_ocorrencia4);

select * from tabela_recomendacao_seguranca;
-- MUDANDO DE TEXT -> DATE
ALTER TABLE tabela_ocorrencia 
ADD COLUMN ocorrencia_dia_temporario DATE;

UPDATE tabela_ocorrencia
SET ocorrencia_dia_temporario = STR_TO_DATE (ocorrencia_dia, '%Y-%m-%d')
WHERE ocorrencia_dia REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

UPDATE tabela_ocorrencia
SET ocorrencia_dia_temporario = STR_TO_DATE(ocorrencia_dia, '%d/%m/%Y')
WHERE ocorrencia_dia REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
  AND ocorrencia_dia_temporario IS NULL;

describe tabela_ocorrencia;


-- PASSO 4
-- Listar todas as ocorrências
select * from tabela_ocorrencia;

-- Listar aeronaves de uma ocorrência específica

SELECT * FROM tabela_aeronave
WHERE codigo_ocorrencia2 = 87104;

-- Listar recomendações para uma ocorrência específica.

SELECT tabela_recomendacao_seguranca.*
FROM tabela_recomendacao_seguranca
INNER JOIN tabela_ocorrencia ON tabela_recomendacao_seguranca.codigo_ocorrencia4 = tabela_ocorrencia.codigo_ocorrencia4
WHERE tabela_ocorrencia.codigo_ocorrencia = 81937;

-- Inserir uma aeronave e uma ocorrência (É possível?) sim, é possível e inclusive deu trabalho hahaha,
-- basta inserir primeiro a ocorrencia e depois a aeronave, sim, eu tentei o cotntrário primeiro e
-- obviamente deu errado :(   mas depois funcionou  :D
-- aeronave
describe tabela_aeronave;

INSERT INTO tabela_aeronave (
    codigo_ocorrencia2,
    aeronave_matricula,
    aeronave_operador_categoria,
    aeronave_tipo_veiculo,
    aeronave_fabricante,
    aeronave_modelo,
    aeronave_tipo_icao,
    aeronave_motor_tipo,
    aeronave_motor_quantidade,
    aeronave_pmd,
    aeronave_pmd_categoria,
    aeronave_assentos,
    aeronave_ano_fabricacao,
    aeronave_pais_fabricante,
    aeronave_pais_registro,
    aeronave_registro_categoria,
    aeronave_registro_segmento,
    aeronave_voo_origem,
    aeronave_voo_destino,
    aeronave_fase_operacao,
    aeronave_tipo_operacao,
    aeronave_nivel_dano,
    aeronave_fatalidades_total
) VALUES (
    999102,
    'PT-ABC',
    'REGULAR',
    'AVIÃO',
    'EMBRAER',
    'EMB-712',
    'E712',
    'PISTÃO',
    '1',
    1100,
    1,
    '4',
    '1998',
    'BRASIL',
    'BRASIL',
    'PRIVADO',
    'TÁXI AÉREO',
    'SBBR',
    'SBRJ',
    'DECOLAGEM',
    'PARTICULAR',
    'SUBSTANCIAL',
    0
);

-- ocorrencia

describe tabela_ocorrencia;

INSERT INTO tabela_ocorrencia (
    codigo_ocorrencia,
    codigo_ocorrencia1,
    codigo_ocorrencia2,
    codigo_ocorrencia3,
    codigo_ocorrencia4,
    ocorrencia_classificacao,
    ocorrencia_latitude,
    ocorrencia_longitude,
    ocorrencia_cidade,
    ocorrencia_uf,
    ocorrencia_pais,
    ocorrencia_aerodromo,
    ocorrencia_dia,
    ocorrencia_hora,
    investigacao_aeronave_liberada,
    investigacao_status,
    divulgacao_relatorio_numero,
    divulgacao_relatorio_publicado,
    divulgacao_dia_publicacao,
    total_recomendacoes,
    total_aeronaves_envolvidas,
    ocorrencia_saida_pista
) VALUES (
    999001,
    999101,
    999102,
    999103,
    999104,
    'ACIDENTE',
    -15.793889,
    -47.882778,
    'BRASÍLIA',
    'DF',
    'BRASIL',
    'SBBR',
    '2021-08-12',
    '14:32:00',
    'SIM',
    'CONCLUÍDA',
    'REL-2021-999',
    'SIM',
    '2021-12-01',
    2,
    1,
    'NAO'
);

-- PASSO 5
-- Ocorrências mais graves e total de aeronaves envolvidas (usei SELF JOIN)

SELECT A.ocorrencia_classificacao, B.total_aeronaves_envolvidas
FROM tabela_ocorrencia AS A, tabela_ocorrencia AS B
WHERE A.ocorrencia_classificacao = "INCIDENTE GRAVE";

-- agora sem self join
SELECT 
    codigo_ocorrencia,
    ocorrencia_cidade,
    ocorrencia_uf,
    total_aeronaves_envolvidas,
    ocorrencia_dia
FROM tabela_ocorrencia
WHERE ocorrencia_classificacao = "INCIDENTE GRAVE"
ORDER BY total_aeronaves_envolvidas DESC;

select * from tabela_tipo_ocorrencia;
-- Ocorrências mais graves e matriculas de aeronaves envolvidas

SELECT tabela_aeronave.aeronave_matricula, tabela_ocorrencia.ocorrencia_classificacao
FROM tabela_aeronave
INNER JOIN tabela_ocorrencia ON tabela_ocorrencia.codigo_ocorrencia2 = tabela_aeronave.codigo_ocorrencia2
WHERE tabela_ocorrencia.ocorrencia_classificacao = "INCIDENTE GRAVE";

-- Total de ocorrências por estado

SELECT COUNT(*) AS Ocurrences
FROM tabela_ocorrencia
WHERE ocorrencia_uf = "BA";

-- Total de ocorrências na cidade de Guanambi

SELECT COUNT(*) AS Ocurrences
FROM tabela_ocorrencia
WHERE ocorrencia_cidade = "GUANAMBI";

-- Total de ocorrências na cidade de Belo Horizonte

SELECT COUNT(*) AS Ocurrences
FROM tabela_ocorrencia
WHERE ocorrencia_cidade = "BELO HORIZONTE";

-- Partindo de qual origem que mais tem acidentes?

SELECT aeronave_voo_origem, COUNT(aeronave_voo_origem) as FREQUENCIA
FROM tabela_aeronave
GROUP BY aeronave_voo_origem
ORDER BY FREQUENCIA DESC
LIMIT 10;

-- ANÁLISES INTERESSANTES
-- FABRICANTES COM MAIS OCORRENCIAS
SELECT 
    aeronave_fabricante,
    COUNT(*) as total_ocorrencias,
    SUM(aeronave_fatalidades_total) as total_fatalidades
FROM tabela_aeronave
WHERE aeronave_fabricante IS NOT NULL
GROUP BY aeronave_fabricante
ORDER BY total_ocorrencias DESC
LIMIT 10;

-- fase do voo ocorrem mais acidentes
SELECT 
    aeronave_fase_operacao,
    COUNT(*) as total_ocorrencias,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tabela_aeronave), 2) as percentual
FROM tabela_aeronave
WHERE aeronave_fase_operacao IS NOT NULL
GROUP BY aeronave_fase_operacao
ORDER BY total_ocorrencias DESC;

