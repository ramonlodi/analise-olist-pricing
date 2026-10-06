-- Cria tabela gold
CREATE OR REPLACE TABLE `analise-olist-pricing.gold.metricas_categoria_mes_estado` AS
SELECT
  ano_mes,
  ano,
  mes,
  categoria_produto AS categoria,
  estado_entrega AS estado,
  COUNT(*) AS unidades,
  COUNT(DISTINCT id_pedido) AS pedidos,
  ROUND(SUM(preco_item), 2) AS receita,
  ROUND(SUM(valor_frete), 2) AS frete_total,
  ROUND(SUM(preco_item) / COUNT(*), 2) AS preco_medio,
  ROUND(SUM(preco_item) / COUNT(DISTINCT id_pedido), 2) AS ticket_medio
FROM `analise-olist-pricing.silver.order_items_clean`
GROUP BY ano_mes, ano, mes, categoria_produto, estado_entrega;

-- Gold vs Silver (110.197 unidades e 13.221.498,11 de receita)
SELECT SUM(unidades) AS unidades, ROUND(SUM(receita), 2) AS receita
FROM `analise-olist-pricing.gold.metricas_categoria_mes_estado`;

-- Diferença direta
SELECT
  (SELECT SUM(unidades) FROM `analise-olist-pricing.gold.metricas_categoria_mes_estado`)
  - (SELECT COUNT(*) FROM `analise-olist-pricing.silver.order_items_clean`) AS dif_unidades,
  ROUND(
    (SELECT SUM(receita) FROM `analise-olist-pricing.gold.metricas_categoria_mes_estado`)
    - (SELECT SUM(preco_item) FROM `analise-olist-pricing.silver.order_items_clean`), 2
  ) AS dif_receita;

-- Duplicatas
SELECT ano_mes, categoria, estado, COUNT(*) AS n FROM `analise-olist-pricing.gold.metricas_categoria_mes_estado`
GROUP BY ano_mes, categoria, estado
HAVING COUNT(*) > 1;