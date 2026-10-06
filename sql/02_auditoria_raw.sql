-- Itens sem produto
SELECT COUNT(*) AS itens_sem_produto FROM `analise-olist-pricing.raw.order_items` AS oi
LEFT JOIN `analise-olist-pricing.raw.products` AS p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Itens sem pedido
SELECT COUNT(*) AS itens_sem_pedido FROM `analise-olist-pricing.raw.order_items` AS oi
LEFT JOIN `analise-olist-pricing.raw.orders` AS o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Pedidos sem cliente
SELECT COUNT(*) AS pedidos_sem_cliente FROM `analise-olist-pricing.raw.orders` AS o
LEFT JOIN `analise-olist-pricing.raw.customers` AS c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Itens entregues sem categoria
SELECT COUNT(*) AS itens_entregues_sem_categoria FROM `analise-olist-pricing.raw.order_items` AS oi
JOIN `analise-olist-pricing.raw.orders` AS o ON oi.order_id = o.order_id
JOIN `analise-olist-pricing.raw.products` AS p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered' AND p.product_category_name IS NULL;

-- Verificação de preços
SELECT
  COUNT(*) AS total_itens,
  COUNTIF(price IS NULL) AS preco_nulo,
  COUNTIF(price <= 0) AS preco_zero_ou_negativo,
  COUNTIF(freight_value > price) AS frete_maior_preco
FROM `analise-olist-pricing.raw.order_items`;

-- Duplicidades em order_items
SELECT order_id, order_item_id, COUNT(*) AS n FROM `analise-olist-pricing.raw.order_items`
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

-- Valores base para confirmação
SELECT COUNT(*) AS itens_entregues, ROUND(SUM(oi.price), 2) AS receita_entregue FROM `analise-olist-pricing.raw.order_items` AS oi
JOIN `analise-olist-pricing.raw.orders` AS o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';