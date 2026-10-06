-- Validação dos números citados em docs/insights_pvm.md

-- 1. Resumo geral
SELECT
  SUM(unidades_2017) AS unidades_2017,
  SUM(unidades_2018) AS unidades_2018,
  ROUND(SUM(unidades_2018) / SUM(unidades_2017) - 1, 4) AS cresc_unidades,
  ROUND(SUM(receita_2017), 2) AS receita_2017,
  ROUND(SUM(receita_2018), 2) AS receita_2018,
  ROUND(SUM(receita_2018) / SUM(receita_2017) - 1, 4) AS cresc_receita,
  ROUND(SUM(receita_2017) / SUM(unidades_2017), 2) AS preco_medio_2017,
  ROUND(SUM(receita_2018) / SUM(unidades_2018), 2) AS preco_medio_2018,
  ROUND((SUM(receita_2018) / SUM(unidades_2018)) / (SUM(receita_2017) / SUM(unidades_2017)) - 1, 4) AS var_preco_medio
FROM `analise-olist-pricing.gold.pvm_categoria`;

-- 2. Variação de preço like-for-like (mesma cesta de 2018, a preços de 2017 vs 2018)
SELECT
  ROUND(SUM(preco_medio_2018 * unidades_2018) / SUM(preco_medio_2017 * unidades_2018) - 1, 4) AS var_preco_todas_continuas,
  ROUND(
    SUM(IF(base_confiavel, preco_medio_2018 * unidades_2018, 0))
    / SUM(IF(base_confiavel, preco_medio_2017 * unidades_2018, 0)) - 1, 4
  ) AS var_preco_base_confiavel
FROM `analise-olist-pricing.gold.pvm_categoria`
WHERE tipo = 'Contínua';

-- 3. Efeito preço: categorias com efeito negativo x positivo
SELECT
  COUNTIF(efeito_preco < 0) AS categorias_preco_negativo,
  ROUND(SUM(IF(efeito_preco < 0, efeito_preco, 0)), 2) AS soma_negativa,
  COUNTIF(efeito_preco > 0) AS categorias_preco_positivo,
  ROUND(SUM(IF(efeito_preco > 0, efeito_preco, 0)), 2) AS soma_positiva,
  ROUND(SUM(efeito_preco), 2) AS efeito_preco_liquido
FROM `analise-olist-pricing.gold.pvm_categoria`;

-- 4. Categorias com maior efeito preço negativo
SELECT
  categoria,
  unidades_2017,
  unidades_2018,
  ROUND(preco_medio_2017, 2) AS preco_medio_2017,
  ROUND(preco_medio_2018, 2) AS preco_medio_2018,
  ROUND(preco_medio_2018 / preco_medio_2017 - 1, 4) AS var_preco,
  ROUND(efeito_preco, 2) AS efeito_preco,
  ROUND(efeito_mix, 2) AS efeito_mix
FROM `analise-olist-pricing.gold.pvm_categoria`
ORDER BY efeito_preco
LIMIT 5;

-- 5. Concentração da variação de receita (top 3, top 5 e top 10)
WITH ranking AS (
  SELECT
    categoria,
    var_receita,
    ROW_NUMBER() OVER (ORDER BY var_receita DESC) AS posicao
  FROM `analise-olist-pricing.gold.pvm_categoria`
)

SELECT
  ROUND(SUM(IF(posicao <= 3, var_receita, 0)) / SUM(var_receita), 4) AS share_top3,
  ROUND(SUM(IF(posicao <= 5, var_receita, 0)) / SUM(var_receita), 4) AS share_top5,
  ROUND(SUM(IF(posicao <= 10, var_receita, 0)) / SUM(var_receita), 4) AS share_top10
FROM ranking;

-- 6. Mix: maiores contribuições positivas e negativas
SELECT categoria, ROUND(efeito_mix, 2) AS efeito_mix
FROM `analise-olist-pricing.gold.pvm_categoria`
WHERE efeito_mix > 100000 OR efeito_mix < -100000
ORDER BY efeito_mix DESC;

-- 7. Mix: contínuas x novas/descontinuadas
SELECT
  ROUND(SUM(IF(tipo = 'Contínua', efeito_mix, 0)), 2) AS mix_continuas,
  ROUND(SUM(IF(tipo != 'Contínua', efeito_mix, 0)), 2) AS mix_novas_descontinuadas
FROM `analise-olist-pricing.gold.pvm_categoria`;

-- 8. Casos citados nos insights
SELECT
  categoria,
  unidades_2017,
  unidades_2018,
  ROUND(unidades_2018 / unidades_2017 - 1, 4) AS cresc_unidades,
  ROUND(preco_medio_2017, 2) AS preco_medio_2017,
  ROUND(preco_medio_2018, 2) AS preco_medio_2018,
  ROUND(preco_medio_2018 / preco_medio_2017 - 1, 4) AS var_preco,
  ROUND(receita_2017, 2) AS receita_2017,
  ROUND(receita_2018, 2) AS receita_2018,
  ROUND(var_receita, 2) AS var_receita,
  ROUND(efeito_preco, 2) AS efeito_preco,
  ROUND(efeito_mix, 2) AS efeito_mix,
  ROUND(receita_2017 / SUM(receita_2017) OVER (), 4) AS share_receita_2017,
  ROUND(receita_2018 / SUM(receita_2018) OVER (), 4) AS share_receita_2018
FROM `analise-olist-pricing.gold.pvm_categoria`
WHERE categoria IN (
  'Relogios Presentes', 'Informatica Acessorios', 'Automotivo', 'Beleza Saude',
  'Cool Stuff', 'Brinquedos', 'Utilidades Domesticas', 'Bebes', 'Moveis Decoracao'
)
ORDER BY var_receita DESC;

-- 9. Preço x volume na base confiável (31 categorias)
WITH base AS (
  SELECT
    categoria,
    unidades_2018 / unidades_2017 - 1 AS cresc_unidades,
    preco_medio_2018 / preco_medio_2017 - 1 AS var_preco
  FROM `analise-olist-pricing.gold.pvm_categoria`
  WHERE base_confiavel AND tipo = 'Contínua'
),

total AS (
  SELECT SUM(unidades_2018) / SUM(unidades_2017) - 1 AS cresc_total
  FROM `analise-olist-pricing.gold.pvm_categoria`
)

SELECT DISTINCT
  var_preco < 0 AS preco_caiu,
  COUNT(*) OVER (PARTITION BY var_preco < 0) AS categorias,
  SUM(IF(cresc_unidades > cresc_total, 1, 0)) OVER (PARTITION BY var_preco < 0) AS acima_da_media,
  ROUND(PERCENTILE_CONT(cresc_unidades, 0.5) OVER (PARTITION BY var_preco < 0), 4) AS mediana_cresc_unidades
FROM base
CROSS JOIN total;