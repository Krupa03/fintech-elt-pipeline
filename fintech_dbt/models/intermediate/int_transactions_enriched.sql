-- int_transactions_enriched.sql
-- Join transactions with identity data

WITH transactions AS (
    SELECT * FROM {{ ref('stg_transactions') }}
),

identity AS (
    SELECT * FROM {{ ref('stg_identity') }}
),

enriched AS (
    SELECT
        t.transaction_id,
        t.transaction_ts,
        t.transaction_amt,
        t.is_fraud,
        t.product_cd,
        t.card_network,
        t.card_type,
        t.purchaser_email_domain,
        t.recipient_email_domain,
        t.billing_zip,
        t.billing_country,
        t.distance_1,
        t.distance_2,
        -- Identity fields
        i.device_type,
        i.device_info,
        i.browser,
        i.screen_resolution,
        i.os_version,
        i.found_result,
        i.match_status,
        i.ip_proxy_type,
        -- Derived fields
        CASE
            WHEN t.transaction_amt < 50   THEN 'low'
            WHEN t.transaction_amt < 200  THEN 'medium'
            WHEN t.transaction_amt < 500  THEN 'high'
            ELSE 'very_high'
        END                             AS amount_tier,
        CASE
            WHEN i.transaction_id IS NULL THEN FALSE
            ELSE TRUE
        END                             AS has_identity,
        t._loaded_at
    FROM transactions t
    LEFT JOIN identity i
        ON t.transaction_id = i.transaction_id
)

SELECT * FROM enriched