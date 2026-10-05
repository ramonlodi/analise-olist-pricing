# Regras de qualidade de dados

| # | Regra | Critério | Linhas afetadas | Tratamento | Justificativa |
|---|---|---|---|---|---|
| 1 | Apenas pedidos entregues | `order_status = 'delivered'` | 2.963 pedidos excluídos | Excluir | Só pedidos entregues geraram receita realizada |
| 2 | Item sem categoria | `product_category_name IS NULL` | [preencher] | [excluir / sinalizar / "sem categoria"] | [motivo] |
| 3 | Frete maior que o preço | `freight_value > price` | [preencher] | [sinalizar] | [motivo] |
| 4 | Preço outlier na categoria | acima de média + 3 desvios | [preencher] | [sinalizar] | [motivo] |
| 5 | Preço zero ou negativo | `price <= 0` | [preencher] | [excluir] | [motivo] |
| 6 | Chaves duplicadas | `order_id` + `order_item_id` repetidos | [preencher] | [excluir] | [motivo] |