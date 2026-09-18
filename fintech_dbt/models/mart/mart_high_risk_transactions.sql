-- mart_high_risk_transactions.sql
-- High risk transaction flags for fraud analysis

WITH enriched AS (
    SELECT * FROM {{ ref('int_transactions_enriched') }}
),

risk_scored AS (
    SELECT
        transaction_id,
        transaction_ts,
        transaction_amt,
        is_fraud,
        product_cd,
        card_network,
        card_type,
        purchaser_email_domain,
        device_type,
        browser,
        ip_proxy_type,
        amount_tier,
        has_identity,
        -- Risk scoring
        CASE WHEN transaction_amt > 500          THEN 1 ELSE 0 END
        + CASE WHEN has_identity = FALSE         THEN 1 ELSE 0 END
        + CASE WHEN ip_proxy_type IS NOT NULL    THEN 1 ELSE 0 END
        + CASE WHEN purchaser_email_domain
               IS NULL                           THEN 1 ELSE 0 END
        + CASE WHEN amount_tier = 'very_high'    THEN 1 ELSE 0 END
                                                AS risk_score,
        CASE
            WHEN (
                CASE WHEN transaction_amt > 500          THEN 1 ELSE 0 END
                + CASE WHEN has_identity = FALSE         THEN 1 ELSE 0 END
                + CASE WHEN ip_proxy_type IS NOT NULL    THEN 1 ELSE 0 END
                + CASE WHEN purchaser_email_domain
                       IS NULL                           THEN 1 ELSE 0 END
                + CASE WHEN amount_tier = 'very_high'    THEN 1 ELSE 0 END
            ) >= 3 THEN 'high'
            WHEN (
                CASE WHEN transaction_amt > 500          THEN 1 ELSE 0 END
                + CASE WHEN has_identity = FALSE         THEN 1 ELSE 0 END
                + CASE WHEN ip_proxy_type IS NOT NULL    THEN 1 ELSE 0 END
                + CASE WHEN purchaser_email_domain
                       IS NULL                           THEN 1 ELSE 0 END
                + CASE WHEN amount_tier = 'very_high'    THEN 1 ELSE 0 END
            ) >= 2 THEN 'medium'
            ELSE 'low'
        END                                     AS risk_level,
        _loaded_at
    FROM enriched
),

high_risk AS (
    SELECT *
    FROM risk_scored
    WHERE risk_score >= 2
)

SELECT * FROM high_risk
ORDER BY risk_score DESC, transaction_amt DESC