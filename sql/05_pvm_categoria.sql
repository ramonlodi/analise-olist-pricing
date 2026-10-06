-- PVM por categoria
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
  SELECT SUM(q0) AS q0_total, SUM(q1) AS q1_total
  FROM base
),

calc AS (
  SELECT
    b.categoria,
    b.q0,
    b.q1,
    b.r0,
    b.r1,
    SAFE_DIVIDE(b.r0, b.q0) AS p0,
    SAFE_DIVIDE(b.r1, b.q1) AS p1,
    b.r1 - b.r0 AS var_receita,
    t.q1_total / t.q0_total - 1 AS crescimento_total
  FROM base AS b
  CROSS JOIN totais AS t
),

efeitos AS (
  SELECT
    categoria,
    q0,
    q1,
    r0,
    r1,
    var_receita,
    IF(q0 > 0 AND q1 > 0, (p1 - p0) * q1, 0) AS efeito_preco,
    IF(q0 > 0, crescimento_total * r0, 0) AS efeito_volume
  FROM calc
)

SELECT
  categoria,
  q0,
  q1,
  ROUND(r0, 2) AS receita_2017,
  ROUND(r1, 2) AS receita_2018,
  ROUND(var_receita, 2) AS var_receita,
  ROUND(efeito_preco, 2) AS efeito_preco,
  ROUND(efeito_volume, 2) AS efeito_volume,
  ROUND(var_receita - efeito_preco - efeito_volume, 2) AS efeito_mix
FROM efeitos
ORDER BY var_receita DESC;