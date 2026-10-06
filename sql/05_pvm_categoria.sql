-- Tabela gold do PVM (jan-ago/2017 x jan-ago/2018, por categoria)
CREATE OR REPLACE TABLE `analise-olist-pricing.gold.pvm_categoria` AS
WITH base AS (
  SELECT
    categoria,
    SUM(IF(ano = 2017, unidades, 0)) AS q0,
    SUM(IF(ano = 2017, receita, 0)) AS r0,
    SUM(IF(ano = 2018, unidades, 0)) AS q1,
    SUM(IF(ano = 2018, receita, 0)) AS r1
  FROM `analise-olist-pricing.gold.metricas_categoria_mes_estado`
  WHERE mes BETWEEN 1 AND 8
    AND ano IN (2017, 2018)
  GROUP BY categoria
),

totais AS (
  SELECT SUM(q1) / SUM(q0) - 1 AS crescimento_total
  FROM base
),

calc AS (
  SELECT
    b.*,
    CASE
      WHEN b.q0 > 0 AND b.q1 > 0 THEN 'Contínua'
      WHEN b.q0 = 0 THEN 'Nova'
      ELSE 'Descontinuada'
    END AS tipo,
    SAFE_DIVIDE(b.r0, b.q0) AS p0,
    SAFE_DIVIDE(b.r1, b.q1) AS p1,
    b.r1 - b.r0 AS var_receita,
    t.crescimento_total
  FROM base AS b
  CROSS JOIN totais AS t
),

efeitos AS (
  SELECT
    *,
    IF(tipo = 'Contínua', (p1 - p0) * q1, 0) AS efeito_preco,
    IF(tipo = 'Contínua', crescimento_total * r0, 0) AS efeito_volume
  FROM calc
)

SELECT
  categoria,
  tipo,
  q0 AS unidades_2017,
  q1 AS unidades_2018,
  r0 AS receita_2017,
  r1 AS receita_2018,
  p0 AS preco_medio_2017,
  p1 AS preco_medio_2018,
  var_receita,
  efeito_preco,
  efeito_volume,
  var_receita - efeito_preco - efeito_volume AS efeito_mix,
  q0 >= 100 AS base_confiavel
FROM efeitos;

-- Reconciliação (var_pvm = var_gold; soma_efeitos = var_pvm)
SELECT
  ROUND(SUM(var_receita), 2) AS var_pvm,
  ROUND(
    (SELECT SUM(receita) FROM `analise-olist-pricing.gold.metricas_categoria_mes_estado` WHERE ano = 2018 AND mes BETWEEN 1 AND 8)
    - (SELECT SUM(receita) FROM `analise-olist-pricing.gold.metricas_categoria_mes_estado` WHERE ano = 2017 AND mes BETWEEN 1 AND 8), 2
  ) AS var_gold,
  ROUND(SUM(efeito_preco + efeito_volume + efeito_mix), 2) AS soma_efeitos,
  ROUND(SUM(efeito_preco), 2) AS preco,
  ROUND(SUM(efeito_volume), 2) AS volume,
  ROUND(SUM(efeito_mix), 2) AS mix
FROM `analise-olist-pricing.gold.pvm_categoria`;

-- Export A
SELECT
  categoria, tipo, unidades_2017, unidades_2018,
  ROUND(receita_2017, 2) AS receita_2017,
  ROUND(receita_2018, 2) AS receita_2018,
  ROUND(preco_medio_2017, 2) AS preco_medio_2017,
  ROUND(preco_medio_2018, 2) AS preco_medio_2018,
  ROUND(var_receita, 2) AS var_receita,
  ROUND(efeito_preco, 2) AS efeito_preco,
  ROUND(efeito_volume, 2) AS efeito_volume,
  ROUND(efeito_mix, 2) AS efeito_mix,
  base_confiavel
FROM `analise-olist-pricing.gold.pvm_categoria`
ORDER BY var_receita DESC;

-- Export B
WITH ranking AS (
  SELECT *, ROW_NUMBER() OVER (ORDER BY var_receita DESC) AS posicao
  FROM `analise-olist-pricing.gold.pvm_categoria`
),

agrupado AS (
  SELECT
    IF(posicao <= 10, categoria, 'Outras categorias') AS grupo,
    IF(posicao <= 10, posicao, 11) AS ordem_grupo,
    SUM(efeito_preco) AS preco,
    SUM(efeito_volume) AS volume,
    SUM(efeito_mix) AS mix
  FROM ranking
  GROUP BY grupo, ordem_grupo
)

SELECT grupo, ordem_grupo, 'Preço' AS componente, 2 AS ordem_componente, ROUND(preco, 2) AS valor FROM agrupado
UNION ALL SELECT grupo, ordem_grupo, 'Volume', 3, ROUND(volume, 2) FROM agrupado
UNION ALL SELECT grupo, ordem_grupo, 'Mix', 4, ROUND(mix, 2) FROM agrupado
UNION ALL SELECT 'Total geral', 0, 'Receita 2017', 1, ROUND(SUM(receita_2017), 2) FROM `analise-olist-pricing.gold.pvm_categoria`
UNION ALL SELECT 'Total geral', 0, 'Preço', 2, ROUND(SUM(efeito_preco), 2) FROM `analise-olist-pricing.gold.pvm_categoria`
UNION ALL SELECT 'Total geral', 0, 'Volume', 3, ROUND(SUM(efeito_volume), 2) FROM `analise-olist-pricing.gold.pvm_categoria`
UNION ALL SELECT 'Total geral', 0, 'Mix', 4, ROUND(SUM(efeito_mix), 2) FROM `analise-olist-pricing.gold.pvm_categoria`
UNION ALL SELECT 'Total geral', 0, 'Receita 2018', 5, ROUND(SUM(receita_2018), 2) FROM `analise-olist-pricing.gold.pvm_categoria`
ORDER BY ordem_grupo, ordem_componente;