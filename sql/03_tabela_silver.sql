-- Cria tabela silver order_items_cleaned
CREATE OR REPLACE TABLE `analise-olist-pricing.silver.order_items_clean` AS
SELECT
  oi.order_id AS id_pedido,
  oi.order_item_id AS id_item_pedido,
  oi.product_id AS id_produto,
  DATE(o.order_purchase_timestamp) AS data_pedido,
  DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH) AS ano_mes,
  EXTRACT(YEAR FROM o.order_purchase_timestamp) AS ano,
  EXTRACT(MONTH FROM o.order_purchase_timestamp) AS mes,
  COALESCE(INITCAP(REPLACE(p.product_category_name, '_', ' ')), 'Sem categoria') AS categoria_produto,
  c.customer_state AS estado_entrega,
  oi.price AS preco_item,
  oi.freight_value AS valor_frete,
  (oi.freight_value > oi.price) AS flag_frete_maior_preco
FROM `analise-olist-pricing.raw.order_items` AS oi
JOIN `analise-olist-pricing.raw.orders` AS o ON oi.order_id = o.order_id
JOIN `analise-olist-pricing.raw.customers` AS c ON o.customer_id = c.customer_id
LEFT JOIN `analise-olist-pricing.raw.products` AS p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered';