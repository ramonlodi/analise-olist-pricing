# Dicionário de dados

## Definições de métricas
- **Receita:** soma de `preco_item`, sem frete.
- **Unidades:** contagem de itens vendidos (linhas da silver).
- **Pedidos:** pedidos distintos. Não é aditivo entre categorias.
- **Preço médio:** receita ÷ unidades.
- **Ticket médio:** receita ÷ pedidos.

## silver.order_items_clean
Grão: um item de pedido entregue (110.197 linhas).

| Coluna | Tipo | Descrição |
|---|---|---|
| id_pedido | STRING | Identificador do pedido |
| id_item_pedido | INT | Posição do item dentro do pedido |
| id_produto | STRING | Identificador do produto |
| data_pedido | DATE | Data da compra (UTC) |
| ano_mes | DATE | Primeiro dia do mês da compra |
| ano | INT | Ano da compra |
| mes | INT | Mês da compra |
| categoria_produto | STRING | Categoria em português, sem "_"; nulo vira "Sem categoria" |
| estado_entrega | STRING | UF do cliente |
| preco_item | FLOAT | Preço do item, sem frete |
| valor_frete | FLOAT | Frete do item |
| flag_frete_maior_preco | BOOL | Verdadeiro se frete > preço |

## gold.metricas_categoria_mes_estado
Grão: categoria × mês × estado.

| Coluna | Descrição |
|---|---|
| ano_mes, ano, mes | Período |
| categoria, estado | Cortes de análise |
| unidades | Itens vendidos |
| pedidos | Pedidos distintos (não somar entre categorias) |
| receita | Soma do preço dos itens |
| frete_total | Soma do frete |
| preco_medio | receita ÷ unidades |
| ticket_medio | receita ÷ pedidos |

## Linhagem
raw.order_items + raw.orders + raw.customers + raw.products
→ silver.order_items_clean (só pedidos entregues)
→ gold.metricas_categoria_mes_estado
→ Looker Studio e Tableau