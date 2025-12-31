-- SQL Query to identify the top 10 cities that fall within the top 10 countries based on the number of customers using a subquery.

SELECT  
  ci.city, 
  co.country, 
  COUNT(cu.customer_id) AS number_of_customers 
FROM customer AS cu 
INNER JOIN address AS ad ON cu.address_id = ad.address_id 
INNER JOIN city AS ci ON ad.city_id = ci.city_id 
INNER JOIN country AS co ON ci.country_id = co.country_id 
WHERE co.country IN (
  -- Subquery to identify the top 10 countries by customer count
  SELECT  
    co.country 
  FROM customer AS cu 
  INNER JOIN address AS ad ON cu.address_id = ad.address_id 
  INNER JOIN city AS ci ON ad.city_id = ci.city_id 
  INNER JOIN country AS co ON ci.country_id = co.country_id  
  GROUP BY co.country 
  ORDER BY COUNT(cu.customer_id) DESC 
  LIMIT 10
)
GROUP BY ci.city, co.country 
ORDER BY number_of_customers DESC 
LIMIT 10;