# analise-pricing
Análise de preço, volume e mix (PVM) e performance por categoria e estado no e-commerce brasileiro. Modelagem em camadas e consultas SQL no BigQuery (GCP), com dashboards em Looker Studio e Tableau Public.

## Estrutura do repositório

```
.
├── README.md
├── links.md
├── datasets/
│   └── README_DATASETS.md        # descrição dos dados (CSVs brutos não versionados)
├── sql/
│   ├── 01_exploracao_raw.sql
│   ├── 02_auditoria_raw.sql
│   ├── 03_tabela_silver.sql
│   ├── 04_tabela_gold.sql
│   └── 05_pvm_categoria.sql
└── docs/
    ├── raw_load_notes.md         # carga da camada raw
    ├── data_quality_rules.md     # regras de qualidade e tratamentos
    ├── data_dictionary.md        # métricas, colunas e linhagem
    ├── validacao_dashboard.md    # dashboard x BigQuery
    ├── dashboard_visao_geral.pdf
    ├── csv/pvm_categoria.csv     # resultado agregado do PVM
    └── prints/
```