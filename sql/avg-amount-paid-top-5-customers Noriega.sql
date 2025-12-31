SELECT 
    AVG(mean.total_amount_paid) AS avg_amount_paid
FROM (
    -- Subquery 3: Top 5 highest-paying customers
    SELECT 
        SUM(pmt.amount) AS total_amount_paid
    FROM payment AS pmt
    INNER JOIN customer AS custA ON pmt.customer_id = custA.customer_id
    INNER JOIN address AS addrA ON custA.address_id = addrA.address_id
    INNER JOIN city AS citA ON addrA.city_id = citA.city_id
    INNER JOIN country AS couA ON citA.country_id = couA.country_id

    WHERE citA.city IN (
        -- Subquery 2: Top 10 cities within the top 10 countries
        SELECT citB.city
        FROM customer AS custB
        INNER JOIN address AS addrB ON custB.address_id = addrB.address_id
        INNER JOIN city AS citB ON addrB.city_id = citB.city_id
        INNER JOIN country AS couB ON citB.country_id = couB.country_id

        WHERE couB.country IN (
            -- Subquery 1: Top 10 countries by customer count
            SELECT couC.country
            FROM customer AS custC
            INNER JOIN address AS addrC ON custC.address_id = addrC.address_id
            INNER JOIN city AS citC ON addrC.city_id = citC.city_id
            INNER JOIN country AS couC ON citC.country_id = couC.country_id
            GROUP BY couC.country
            ORDER BY COUNT(custC.customer_id) DESC
            LIMIT 10
        )

        GROUP BY citB.city
        ORDER BY COUNT(custB.customer_id) DESC
        LIMIT 10
    )

    GROUP BY custA.customer_id
    ORDER BY total_amount_paid DESC
    LIMIT 5
) AS mean;
