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