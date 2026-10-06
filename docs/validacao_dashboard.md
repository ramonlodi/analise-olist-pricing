# Validação do dashboard

Os valores exibidos no Data Studio foram conferidos contra consultas diretas
na tabela `gold.metricas_categoria_mes_estado` no BigQuery.

| Filtro | Receita | Unidades | Preço médio por item |
|---|---|---|---|
| Sem filtro | R$ 13.221.498,11 | 110.197 | R$ 119,98 |
| Estado SP + mês 2017-11 | R$ 350.790,18 | 3.351 | R$ 104,68 |

Os valores do painel e do BigQuery são iguais.

## Definições
- Receita: soma de `preco_item`, sem frete.
- Preço médio por item: `SUM(receita) / SUM(unidades)`, e não a média da coluna `preco_medio`.
- Ticket médio total não é exibido: pedidos distintos não são aditivos entre categorias.

## Amostras
- `docs/dashboard_visao_geral.pdf`
- `docs/prints/dashboard_filtro_sp_2017-11.png`
- `docs/prints/validacao_bigquery_sp_2017-11.png`