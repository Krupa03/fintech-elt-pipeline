-- mart_fraud_summary.sql
-- Daily fraud summary for dashboarding

WITH enriched AS (
    SELECT * FROM {{ ref('int_transactions_enriched') }}
),

daily_summary AS (
    SELECT
        DATE(transaction_ts)            AS transaction_date,
        product_cd,
        card_network,
        card_type,
        amount_tier,
        COUNT(*)                        AS total_transactions,
        SUM(is_fraud)                   AS total_fraud,
        ROUND(
            SUM(is_fraud) * 100.0 /
            COUNT(*), 4
        )                               AS fraud_rate_pct,
        ROUND(SUM(transaction_amt), 2)  AS total_amount,
        ROUND(AVG(transaction_amt), 2)  AS avg_amount,
        ROUND(MAX(transaction_amt), 2)  AS max_amount,
        SUM(CASE WHEN has_identity
            THEN 1 ELSE 0 END)          AS transactions_with_identity
    FROM enriched
    GROUP BY
        DATE(transaction_ts),
        product_cd,
        card_network,
        card_type,
        amount_tier
)

SELECT * FROM daily_summary