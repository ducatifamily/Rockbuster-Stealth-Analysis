-- CTE 1: Identify the top 10 countries by customer count
WITH top_countries AS (
    SELECT cou.country
    FROM customer AS cust_tcou
    INNER JOIN address AS addr_tcou ON cust_tcou.address_id = addr_tcou.address_id
    INNER JOIN city AS cit_tcou ON addr_tcou.city_id = cit_tcou.city_id
    INNER JOIN country AS cou ON cit_tcou.country_id = cou.country_id
    GROUP BY cou.country
    ORDER BY COUNT(cust_tcou.customer_id) DESC
    LIMIT 10
),

-- CTE 2: Identify the top cities within those countries
top_cities AS (
    SELECT cit_tcit.city
    FROM customer AS cust_tcit
    INNER JOIN address AS addr_tcit ON cust_tcit.address_id = addr_tcit.address_id
    INNER JOIN city AS cit_tcit ON addr_tcit.city_id = cit_tcit.city_id
    INNER JOIN country AS cou_tcit ON cit_tcit.country_id = cou_tcit.country_id
    INNER JOIN top_countries AS tcou_tcit ON cou_tcit.country = tcou_tcit.country
    GROUP BY cit_tcit.city
    ORDER BY COUNT(cust_tcit.customer_id) DESC
    LIMIT 10
),

-- CTE 3: Calculate total amount paid per customer
customer_totals AS (
    SELECT
        cust_tot.customer_id,
        SUM(pmt_tot.amount) AS total_amount_paid
    FROM payment AS pmt_tot
    INNER JOIN customer AS cust_tot ON pmt_tot.customer_id = cust_tot.customer_id
    INNER JOIN address AS addr_tot ON cust_tot.address_id = addr_tot.address_id
    INNER JOIN city AS cit_tot ON addr_tot.city_id = cit_tot.city_id
    INNER JOIN top_cities AS tcit_tot ON cit_tot.city = tcit_tot.city
    GROUP BY cust_tot.customer_id
),

-- CTE 4: Rank customers by total spend
top_customers AS (
    SELECT total_amount_paid
    FROM customer_totals
    ORDER BY total_amount_paid DESC
    LIMIT 5
)
SELECT AVG(total_amount_paid) AS amount_paid_mean
FROM top_customers;

