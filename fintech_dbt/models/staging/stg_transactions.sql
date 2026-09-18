-- stg_transactions.sql
-- Clean and standardize raw transaction data

WITH source AS (
    SELECT * FROM workspace.fintech.raw_transactions
),

cleaned AS (
    SELECT
        TransactionID                                    AS transaction_id,
        isFraud                                         AS is_fraud,
        TransactionDT                                   AS transaction_dt,
        -- Convert offset seconds to timestamp (ref date: 2017-12-01)
        TIMESTAMP_SECONDS(
    		UNIX_TIMESTAMP(CAST('2017-12-01' AS TIMESTAMP)) + TransactionDT
	)                                               AS transaction_ts,
        ROUND(TransactionAmt, 2)                        AS transaction_amt,
        ProductCD                                       AS product_cd,
        card4                                           AS card_network,
        card6                                           AS card_type,
        P_emaildomain                                   AS purchaser_email_domain,
        R_emaildomain                                   AS recipient_email_domain,
        addr1                                           AS billing_zip,
        addr2                                           AS billing_country,
        dist1                                           AS distance_1,
        dist2                                           AS distance_2,
        -- M fields: match indicators
        M1, M2, M3, M4, M5, M6, M7, M8, M9,
        CURRENT_TIMESTAMP()                             AS _loaded_at
    FROM source
    WHERE TransactionID IS NOT NULL
      AND TransactionAmt > 0
)

SELECT * FROM cleaned 
