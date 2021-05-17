SELECT * FROM review_id_table LIMIT 10;

SELECT COUNT(*) FROM review_id_table;

SELECT COUNT(*) FROM products;

SELECT COUNT(*) FROM customers;

SELECT COUNT(*) FROM vine_table;

SELECT * FROM vine_table LIMIT 10;

-- Number of reviews by vin and non-vine
SELECT vine, COUNT(review_id) FROM vine_table
GROUP BY vine;

-- Number of 5-star reviews by vine and non-vine
SELECT vine_5_star.vine, COUNT(vine_5_star.review_id) AS Num_5_star
FROM (SELECT review_id, vine FROM vine_table WHERE star_rating = 5) AS vine_5_star
GROUP BY vine_5_star.vine;

-- Average rating by vine and non-vine
SELECT vine, round((AVG(star_rating))::numeric,2) AS avg_rating
FROM vine_table
GROUP BY vine;

-- Average rating
SELECT round((AVG(star_rating))::numeric,2) AS avg_rating
FROM vine_table;

-- Number of helpful votes by vine and non-vine
SELECT 
	vine, SUM(helpful_votes), SUM(total_votes), 
	round((SUM(helpful_votes)::decimal/SUM(total_votes)::decimal)::numeric,2) AS upvote_rate
FROM vine_table
GROUP BY vine;

-- Top reviewers
SELECT tmp2.customer_id, tmp2.vine, tmp2.num_reviews, tmp2.sum_helpful_votes, tmp2.sum_total_votes,
		round((tmp2.sum_helpful_votes::decimal / tmp2.sum_total_votes::decimal)::numeric,2) AS upvote_rate
FROM (SELECT 
	  tmp.customer_id, tmp.vine, 
	  COUNT(tmp.customer_id) AS num_reviews, 
	  SUM(tmp.helpful_votes) AS sum_helpful_votes, 
	  SUM(tmp.total_votes) AS sum_total_votes 
	  FROM (
		  SELECT vine_table.review_id, vine_table.vine, helpful_votes, total_votes, review_id_table.customer_id 
		  FROM vine_table 
		  JOIN review_id_table ON vine_table.review_id = review_id_table.review_id 
		  WHERE customer_id IN (SELECT customer_id FROM customers WHERE customer_count > 10) 
	  ) AS tmp 
	  GROUP BY tmp.customer_id, tmp.vine) AS tmp2
ORDER BY upvote_rate DESC;