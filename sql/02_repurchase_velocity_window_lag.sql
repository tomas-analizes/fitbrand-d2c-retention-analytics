WITH ordered_purchases AS ( 

    SELECT 

        client_id, 

        product, 

        purchase_date, 

        LAG(purchase_date) OVER ( 

            PARTITION BY client_id 

            ORDER BY purchase_number 

        ) AS previous_purchase_date 

    FROM transactions 

) 

SELECT 

    product, 

    ROUND(AVG(JULIANDAY(purchase_date) - JULIANDAY(previous_purchase_date)), 0) AS avg_days_to_repurchase 

FROM ordered_purchases 

WHERE previous_purchase_date IS NOT NULL 

GROUP BY product;