# Carga dos dados brutos (camada raw)

## Ambiente
- Plataforma: Google Cloud Platform, BigQuery (modo Sandbox)
- Projeto: `analise-olist-pricing`
- Localização dos datasets: US
- Datasets criados: `raw`, `silver`, `gold`

## Método de carga
Upload manual dos CSVs pelo console do BigQuery, com detecção automática de esquema.
Nenhuma transformação foi feita nesta camada: raw guarda os dados como vieram da fonte.

## Tabelas carregadas

| Arquivo de origem | Tabela em `raw` | Linhas |
|---|---|---|
| olist_orders_dataset.csv | orders | 99.441 |
| olist_order_items_dataset.csv | order_items | 112.650 |
| olist_products_dataset.csv | products | 32.951 |
| olist_customers_dataset.csv | customers | 99.441 |
| olist_sellers_dataset.csv | sellers | 3.095 |
| olist_order_payments_dataset.csv | order_payments | 103.886 |

As contagens conferem com o dataset original e servem de base para a reconciliação.

## Tabelas não utilizadas
- `product_category_name_translation`: as categorias foram mantidas em português,
  idioma original do dataset e do público da análise.
- `olist_geolocation_dataset`: fora do escopo (análise por estado, não por coordenada).
- `olist_order_reviews_dataset`: fora do escopo (o foco é preço, volume e mix).
- `sellers` e `order_payments`: carregadas no raw, mas fora do escopo (a análise não
  corta por vendedor nem por forma de pagamento).

## Esquema
- Datas de `orders` (ex.: `order_purchase_timestamp`) vieram como `TIMESTAMP`.
- `price` e `freight_value` em `order_items` vieram como `FLOAT`.
- Particionamento e clusterização: não aplicados na raw (tabelas pequenas, sem ganho).

## Exploração inicial

**Status dos pedidos**

| Status | Pedidos |
|---|---|
| delivered | 96.478 |
| shipped | 1.107 |
| canceled | 625 |
| unavailable | 609 |
| invoiced | 314 |
| processing | 301 |
| created | 5 |
| approved | 2 |

**Período coberto:** 04/09/2016 a 17/10/2018.

## Decisões iniciais
- Análise apenas de pedidos `delivered` (96.478 pedidos; 2.963 excluídos), pois são
  os que geraram receita realizada.
- Comparação PVM em jan–ago de 2017 vs. jan–ago de 2018, para evitar a sazonalidade
  e a baixa cobertura do fim de 2016 e do fim de 2018.