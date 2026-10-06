# Descrição dos datasets

**Fonte:** Brazilian E-Commerce Public Dataset by Olist (Kaggle)

**Link:** https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

**Licença:** [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) 

**Período:** setembro/2016 a outubro/2018

**Observação:** os arquivos brutos não estão no repositório. Baixe no link acima.

## Tabelas utilizadas

### orders (99.441 linhas)
- **Granularidade:** um registro por pedido.
- **Chave:** `order_id`. Liga com `customers` por `customer_id`.
- **Colunas principais:** `order_status` (situação do pedido), `order_purchase_timestamp`
  (data e hora da compra), além das datas de aprovação, envio e entrega.
- **Uso:** filtro de status (`delivered`) e eixo de tempo.

### order_items (112.650 linhas)
- **Granularidade:** um registro por item dentro de um pedido.
- **Chave:** `order_id` + `order_item_id`. Liga com `products` por `product_id`
  e com `sellers` por `seller_id`.
- **Colunas principais:** `price` (preço do item), `freight_value` (frete do item).
- **Uso:** base das métricas de receita, unidades e preço médio.

### products (32.951 linhas)
- **Granularidade:** um registro por produto.
- **Chave:** `product_id`.
- **Colunas principais:** `product_category_name` (categoria, em português),
  além de peso e dimensões.
- **Uso:** categoria dos itens. Há produtos sem categoria, tratados na auditoria.

### customers (99.441 linhas)
- **Granularidade:** um registro por pedido (`customer_id` muda a cada pedido).
- **Chave:** `customer_id`. `customer_unique_id` identifica a pessoa.
- **Colunas principais:** `customer_state`, `customer_city`.
- **Uso:** estado do cliente, para os cortes regionais.

## Tabelas carregadas, mas não utilizadas

### sellers (3.095 linhas)
- **Granularidade:** um registro por vendedor.
- **Chave:** `seller_id`.
- **Colunas principais:** `seller_state`, `seller_city`.
- **Uso:** carregada no raw, mas fora do escopo (a análise não corta por vendedor).

### order_payments (103.886 linhas)
- **Granularidade:** um registro por forma de pagamento de um pedido.
- **Chave:** `order_id` + `payment_sequential`.
- **Colunas principais:** `payment_type`, `payment_installments`, `payment_value`.
- **Uso:** carregada no raw, mas fora do escopo (a análise não corta por forma de pagamento).

## Arquivos não carregados

| Arquivo | Motivo |
|---|---|
| product_category_name_translation | Categorias mantidas em português |
| olist_geolocation_dataset | Análise feita por estado, sem coordenadas |
| olist_order_reviews_dataset | Fora do escopo (preço, volume e mix) |

## Como carregar no BigQuery
Veja `docs/raw_load_notes.md`.