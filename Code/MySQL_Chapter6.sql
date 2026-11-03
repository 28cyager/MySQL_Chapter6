/****************************************************************************
DATE: 2026.10.29
NAMES: Christian & Faith
Chapter 6 assignment
GitHub URL: https://github.com/28cyager/MySQL_Chapter6
*****************************************************************************/

/****************************************************************************
Christian
Query 1: COUNT
Write a query that returns the total number of rentals and the total returned.
*****************************************************************************/
SELECT 
	COUNT(*) AS total_rentals,
	COUNT(return_date) AS total_returned
FROM rental;

/****************************************************************************
Faith
Query 2: COUNT(DISTINCT column)
Write a query that returns the total number of unique customers payments and the total number of payments.
*****************************************************************************/

SELECT 
	COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(payment_id) AS total_num_of_payments
FROM payment;

/****************************************************************************
Christian
Query 3: GROUP BY and HAVING
Write a query that returns total number of payments, min, max, and rounded avg payment, and the total amount pay PER CUSTOMER which have a total amount paid over > $100.00
*****************************************************************************/
SELECT customer_id, count(payment_id)  AS number_of_payment, MIN(amount) AS min_payment, MAX(amount) AS max_payment, ROUND(AVG(amount), 2) AS avg_payment, SUM(amount) AS total_amount_paid
FROM payment
GROUP BY customer_id
HAVING total_amount_paid > 100.00;

/****************************************************************************
Faith
Query 4: Functionally dependent column
Rewrite query 3 to have a functionally dependent column customer name (last_name, ‘,’, first name)
*****************************************************************************/
SELECT payment.customer_id, 
	CONCAT(customer.last_name, ', ', customer.first_name) AS customer_name, 
    COUNT(payment_id) AS number_of_payment, 
    MIN(amount) AS min_payment, 
    MAX(amount) AS max_payment, 
    ROUND(AVG(amount), 2) AS avg_payment,
    SUM(amount) AS total_amount_paid
FROM payment JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
HAVING total_amount_paid > 100.00;

/****************************************************************************
Christian
Query 5: WHERE vs HAVING - Part 1
Rewrite query 4 to only display store id = 1 and total amount > 100
IMPORTANT NOTE: store_id is NOT in the column list so you can NOT put it in the HAVING clause
*****************************************************************************/
SELECT payment.customer_id, 
	CONCAT(customer.last_name, ', ', customer.first_name) AS customer_name, 
    COUNT(payment_id) AS number_of_payment, 
    MIN(amount) AS min_payment, 
    MAX(amount) AS max_payment, 
    ROUND(AVG(amount), 2) AS avg_payment,
    SUM(amount) AS total_amount_paid
FROM payment JOIN customer ON payment.customer_id = customer.customer_id
WHERE store_id = 1
GROUP BY payment.customer_id
HAVING total_amount_paid > 100.00;

/****************************************************************************
Faith
Query 6: WHERE vs HAVING - Part 2
Rewrite query 5 to include store_id in the column list. Now that store_id is in the column list, you can move the filter to the HAVING clause. NOTE: Query 5 is more efficient than Query 6
*****************************************************************************/
SELECT payment.customer_id, 
	CONCAT(customer.last_name, ', ', customer.first_name) AS customer_name,
    store_id,
    COUNT(payment_id) AS number_of_payment, 
    MIN(amount) AS min_payment, 
    MAX(amount) AS max_payment, 
    ROUND(AVG(amount), 2) AS avg_payment,
    SUM(amount) AS total_amount_paid
FROM payment JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
HAVING total_amount_paid > 100.00 AND store_id = 1;

/****************************************************************************
Christian
Query 7: WITH ROLLUP
Rewrite query 6 to no longer summarize at the customer level. 
Instead, it will summarize at the district and city, plus include WITH ROLLUP summary rows.
Also, do not filter any of the data using a HAVING clause.
*****************************************************************************/
SELECT a.district AS district, 
	c.city,
    COUNT(payment_id) AS number_of_payment, 
    MIN(amount) AS min_payment, 
    MAX(amount) AS max_payment, 
    ROUND(AVG(amount), 2) AS avg_payment,
    SUM(amount) AS total_amount_paid
FROM payment p
	JOIN customer cu ON p.customer_id = cu.customer_id
    JOIN address a ON a.address_id = cu.address_id
	JOIN city c ON c.city_id = a.city_id
GROUP BY a.district, c.city WITH ROLLUP;

/****************************************************************************
Faith
Query 8: GROUPING and COALESCE functions

Rewrite Query 7 to replace the null summary values with City Sum and District Sum values
•	Note: MariaDB does not support using ORDER BY when using WITH ROLLLUP
https://mariadb.com/kb/en/select-with-rollup/
WITH ROLLUP cannot be used with ORDER BY. Some sorting is still possible by using ASC or DESC clauses with the GROUP BY column, although the super-aggregate rows will always be added last.

•	Note: MariaDB does not support using IF GROUPING
o	https://mariadb.com/kb/en/select-with-rollup/ 
 
NOTE: COALESCE  means come together to form one mass or whole
Example: COALESCE(district, "District Sum") as district

*****************************************************************************/
SELECT COALESCE(a.district, "District Sum") AS district, 
	COALESCE(c.city, "City Sum") AS city,
    COUNT(payment_id) AS number_of_payment, 
    MIN(amount) AS min_payment, 
    MAX(amount) AS max_payment, 
    ROUND(AVG(amount), 2) AS avg_payment,
    SUM(amount) AS total_amount_paid
FROM payment p
	JOIN customer cu ON p.customer_id = cu.customer_id
    JOIN address a ON a.address_id = cu.address_id
	JOIN city c ON c.city_id = a.city_id
GROUP BY a.district, c.city WITH ROLLUP;
