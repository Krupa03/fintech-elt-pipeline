-- stg_identity.sql
-- Clean and standardize raw identity data

WITH source AS (
    SELECT * FROM workspace.fintech.raw_identity
),

cleaned AS (
    SELECT
        TransactionID           AS transaction_id,
        id_12                   AS found_result,
        id_15                   AS match_status,
        id_16                   AS bis_flag,
        id_23                   AS ip_proxy_type,
        id_27                   AS billing_shipping_match,
        id_28                   AS billing_match,
        id_29                   AS shipping_match,
        id_30                   AS os_version,
        id_31                   AS browser,
        id_33                   AS screen_resolution,
        id_35                   AS track1_down,
        id_36                   AS track2_down,
        id_37                   AS track3_down,
        id_38                   AS paymentpage_down,
        DeviceType              AS device_type,
        DeviceInfo              AS device_info,
        CURRENT_TIMESTAMP()     AS _loaded_at
    FROM source
    WHERE TransactionID IS NOT NULL
)

SELECT * FROM cleaned