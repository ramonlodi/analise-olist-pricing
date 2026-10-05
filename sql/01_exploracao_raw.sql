-- Linhas por tabela
SELECT 'orders' AS tabela, COUNT(*) AS linhas FROM `analise-olist-pricing.raw.orders`
UNION ALL SELECT 'order_items', COUNT(*) FROM `analise-olist-pricing.raw.order_items`
UNION ALL SELECT 'products', COUNT(*) FROM `analise-olist-pricing.raw.products`
UNION ALL SELECT 'sellers', COUNT(*) FROM `analise-olist-pricing.raw.sellers`
UNION ALL SELECT 'order_payments', COUNT(*) FROM `analise-olist-pricing.raw.order_payments`
UNION ALL SELECT 'customers', COUNT(*) FROM `analise-olist-pricing.raw.customers`;

-- Período coberto pelo dataset
SELECT 
MIN(order_purchase_timestamp) AS primeira_compra, 
MAX(order_purchase_timestamp) AS ultima_compra 
FROM `analise-olist-pricing.raw.orders`;

-- Distribuição de status dos pedidos
SELECT order_status, COUNT(*) AS pedidos FROM `analise-olist-pricing.raw.orders`
GROUP BY order_status
ORDER BY pedidos DESC;