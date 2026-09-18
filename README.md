\# Fintech ELT Pipeline



!\[Python](https://img.shields.io/badge/Python-3.14-blue)

!\[Databricks](https://img.shields.io/badge/Databricks-Free%20Edition-red)

!\[dbt](https://img.shields.io/badge/dbt-1.12.3-orange)

!\[Delta Lake](https://img.shields.io/badge/Delta%20Lake-Unity%20Catalog-blue)



End-to-end ELT pipeline built with Databricks, Delta Lake, and dbt on the IEEE-CIS Fraud Detection dataset (590K+ transactions).



\## Architecture



Raw CSV → Unity Catalog Volume → Databricks Notebook (PySpark) → Delta Tables (Raw) → dbt (Transform) → Mart Tables





\## Tech Stack



| Layer | Tool |

|---|---|

| Compute | Databricks (Serverless) |

| Storage | Delta Lake (Unity Catalog) |

| Transformation | dbt Core 1.12 |

| Language | Python, PySpark, SQL |

| Dataset | IEEE-CIS Fraud Detection (590K transactions) |



\## dbt Models



models/

├── staging/

│ ├── stg\_transactions.sql # Clean raw transaction data

│ └── stg\_identity.sql # Clean identity data

├── intermediate/

│ └── int\_transactions\_enriched.sql # Join transactions + identity

└── mart/

├── mart\_fraud\_summary.sql # Daily fraud rates by category

└── mart\_high\_risk\_transactions.sql # Risk-scored transactions





\## Pipeline



1\. \*\*Ingest\*\* — PySpark notebook reads CSVs from Unity Catalog Volume → writes Delta tables

2\. \*\*Transform\*\* — dbt runs 5 models across staging → intermediate → mart layers

3\. \*\*Test\*\* — 6 dbt data tests (unique, not\_null, accepted\_values)



\## Key Findings



\- 590,540 transactions across 2017–2019

\- Fraud rate varies significantly by product category and card network

\- High-risk transactions identified by multi-factor risk scoring (amount, identity, proxy detection)



\## dbt Test Results



PASS=6 WARN=0 ERROR=0 SKIP=0 TOTAL=6





\## Dataset



\[IEEE-CIS Fraud Detection](https://www.kaggle.com/c/ieee-fraud-detection) — 590K transactions, Vesta Corporation

