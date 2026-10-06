# Regras de qualidade de dados

| # | Regra | Critério | Linhas afetadas | Tratamento | Justificativa |
|---|---|---|---|---|---|
| 1 | Apenas pedidos entregues | `order_status = 'delivered'` | 2.963 pedidos excluídos | Excluir | Só pedidos entregues geraram receita realizada |
| 2 | Item sem categoria | `product_category_name IS NULL` | 1.537 de 110.197 itens entregues | Sinalizar como "sem categoria"| O produto existe, só falta a categoria |
| 3 | Frete maior que o preço | `freight_value > price` | 4.124 de 112.650 itens | Manter e sinalizar| Fato do negócio (produto barato) |
| 4 | Preço zero ou negativo | `price <= 0` | Sem ocorrências | Sem ocorrências | Não há valores zerados ou nulos |
| 5 | Chaves duplicadas | `order_id` + `order_item_id` repetidos | Sem ocorrências | Sem ocorrências | Não há chaves duplicadas |

## Escopo da auditoria
A auditoria cobre as tabelas e colunas usadas na análise: order_items, orders,
customers e products. As tabelas geolocation, reviews, category_translation,
sellers e order_payments ficaram fora do escopo.

## Não avaliado
- **Outlier de preço por categoria:** não foi avaliado neste projeto. Preços altos
  podem ser produtos premium legítimos, e a regra de média + 3 desvios gera falsos
  positivos em distribuições assimétricas. Nenhum preço foi excluído ou ajustado.

## Joins
A auditoria encontrou 0 itens sem pedido, 0 pedidos sem cliente e 0 itens sem produto.
Por isso os joins da silver são INNER JOIN: não descartam nenhuma linha, com exceção do LEFT JOIN em `products`. A única
exclusão intencional é o filtro de pedidos entregues.

## Limitações
- Datas em UTC (um pedido tarde da noite pode cair no dia seguinte).
- Auditoria feita sobre o raw; o recorte analisado é só pedidos entregues.