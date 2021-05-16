SELECT * FROM review_id_table LIMIT 10;

SELECT COUNT(*) FROM review_id_table;

SELECT COUNT(*) FROM products;

SELECT COUNT(*) FROM customers;

SELECT COUNT(*) FROM vine_table;

SELECT * FROM customers
ORDER BY customer_count DESC
LIMIT 10;

SELECT * FROM customers
WHERE customer_count > 10
ORDER BY customer_count DESC;

SELECT * FROM vine_table LIMIT 10;

SELECT SUM(helpful_votes) FROM vine_table;

SELECT SUM(total_votes) FROM vine_table;

SELECT tmp.sum_helpful_votes, tmp.sum_total_votes,
		round((tmp.sum_helpful_votes::decimal / tmp.sum_total_votes::decimal)::numeric,2) AS petcentage
FROM (SELECT 
	  SUM(helpful_votes) AS sum_helpful_votes,
	  SUM(total_votes) AS sum_total_votes
	  FROM vine_table
	 ) AS tmp;

SELECT round((AVG(tmp.star_rating))::numeric,2)
FROM (
	SELECT vine_table.review_id, star_rating, review_id_table.product_id
	FROM vine_table
	JOIN review_id_table ON vine_table.review_id = review_id_table.review_id
) AS tmp
GROUP BY tmp.product_id;

SELECT round((AVG(tmp.star_rating))::numeric,2)
FROM (
	SELECT vine_table.review_id, star_rating, review_id_table.product_id
	FROM vine_table
	JOIN review_id_table ON vine_table.review_id = review_id_table.review_id
) AS tmp;

SELECT vine_table.review_id, helpful_votes, total_votes, review_id_table.customer_id
FROM vine_table
JOIN review_id_table ON vine_table.review_id = review_id_table.review_id;

SELECT tmp.customer_id, 
		COUNT(tmp.customer_id) AS customer_count,
		SUM(tmp.helpful_votes) AS sum_helpful_votes,
		SUM(tmp.total_votes) AS sum_total_votes
FROM (SELECT vine_table.review_id, helpful_votes, total_votes, review_id_table.customer_id
	  FROM vine_table
	  JOIN review_id_table ON vine_table.review_id = review_id_table.review_id
) AS tmp
GROUP BY tmp.customer_id
ORDER BY customer_count DESC;

SELECT tmp2.customer_id, tmp2.customer_count, tmp2.sum_helpful_votes, tmp2.sum_total_votes,
		round((tmp2.sum_helpful_votes::decimal / tmp2.sum_total_votes::decimal)::numeric,2) AS petcentage
FROM (SELECT tmp.customer_id, 
		COUNT(tmp.customer_id) AS customer_count,
		SUM(tmp.helpful_votes) AS sum_helpful_votes,
		SUM(tmp.total_votes) AS sum_total_votes
	  FROM (SELECT vine_table.review_id, helpful_votes, total_votes, review_id_table.customer_id
	  FROM vine_table
	  JOIN review_id_table ON vine_table.review_id = review_id_table.review_id
	  WHERE customer_id IN (SELECT customer_id FROM customers WHERE customer_count > 20)
) AS tmp
GROUP BY tmp.customer_id
) AS tmp2
ORDER BY petcentage DESC;

SELECT * FROM vine_table
WHERE total_votes > 1 AND helpful_votes > total_votes * 0.6;

SELECT COUNT(*) FROM vine_table
WHERE total_votes > 1 AND helpful_votes > total_votes * 0.6;