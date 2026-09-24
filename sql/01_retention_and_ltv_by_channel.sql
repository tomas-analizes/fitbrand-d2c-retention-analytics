SELECT 

    acquisition_channel, 

    COUNT(DISTINCT client_id) AS total_clients, 

    COUNT(DISTINCT CASE WHEN purchase_number > 1 THEN client_id END) AS retained_clients, 

    ROUND( 

        CAST(COUNT(DISTINCT CASE WHEN purchase_number > 1 THEN client_id END) AS FLOAT) / 

        COUNT(DISTINCT client_id) * 100, 2 

    ) AS retention_rate_pct, 

    ROUND(CAST(SUM(purchase_amount_usd) AS FLOAT) / COUNT(DISTINCT client_id), 2) AS avg_ltv_usd 

FROM transactions 

GROUP BY acquisition_channel 

ORDER BY avg_ltv_usd DESC;