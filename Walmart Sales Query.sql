--SELECT *
--  FROM [Walmart Sales].[dbo].[WalmartSales];



-- ---------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------- Feature Engineering ----------------------------------------------------------


-- Time_of_day

 SELECT time,
			(CASE
				WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
				WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
				ELSE 'Evening'
			END
			) AS time_of_date
 FROM [Walmart Sales].dbo.WalmartSales;


 ALTER TABLE [Walmart Sales].dbo.WalmartSales
ADD time_of_day VARCHAR(20);


UPDATE [Walmart Sales].dbo.WalmartSales
SET time_of_day = (
			CASE
				WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
				WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
				ELSE 'Evening'
			END
);
  


  -- Day_name

  SELECT DATENAME(dw, date) AS day_name	
  FROM [Walmart Sales].dbo.WalmartSales;

  ALTER TABLE [Walmart Sales].dbo.WalmartSales
  ADD day_name VARCHAR(10);

  UPDATE [Walmart Sales].dbo.WalmartSales
  SET day_name = (
				DATENAME(dw, date)		
  );



  -- Month_name

SELECT date,
		DATENAME(month, date) AS month_name
FROM [Walmart Sales].dbo.WalmartSales;
	

ALTER TABLE [Walmart Sales].dbo.WalmartSales
ADD month_name VARCHAR(10);


UPDATE [Walmart Sales].dbo.WalmartSales
SET month_name = (
				DATENAME(month, date)
);



-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------- Generic ------------------------------------------------------------------------

-- How many unique cities does the data have?
SELECT DISTINCT city
FROM [Walmart Sales].dbo.WalmartSales;


-- In which city is each branch?
SELECT DISTINCT city, branch
FROM [Walmart Sales].dbo.WalmartSales;


-- -----------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------- Product -----------------------------------------------------------------------

-- How many unique product line does the data have?
SELECT COUNT(DISTINCT product_line)
FROM [Walmart Sales].dbo.WalmartSales;


-- What is the most common payment method?
SELECT payment, COUNT(payment) AS cnt
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY payment
ORDER BY cnt DESC;


-- What is the most selling product line?
SELECT product_line, COUNT(product_line) AS cnt
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY product_line
ORDER BY cnt DESC;


-- What is the total revenue by month?
SELECT month_name AS month,
		SUM(total) AS total_revenue
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY month_name
ORDER BY total_revenue;


-- What month had the largest COGS(cost of goods sold)
SELECT month_name AS month,
		SUM(cogs) AS cogs
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY month_name
ORDER BY cogs DESC;


-- What product line had the largest revenue?
SELECT product_line,
		SUM(total) AS total_revenue
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY product_line
ORDER BY total_revenue DESC;


-- What is the city with the largest revenue?
SELECT branch,
		city,
		SUM(total) AS total_revenue
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY branch, city
ORDER BY total_revenue DESC;


-- What product line had the largest tax rate?
SELECT product_line,
		AVG(VAT) AS avg_tax
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY product_line
ORDER BY avg_tax DESC;



-- Which branch sold more products than average product sold?
SELECT branch,
		SUM(quantity) AS qty
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY branch
HAVING SUM(quantity) >
						(SELECT AVG(quantity)
						FROM [Walmart Sales].dbo.WalmartSales)
ORDER BY qty DESC;


-- What is the most common product line by gender?
SELECT gender,
		product_line,
		COUNT(gender) AS total_cnt
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;


-- What is the average rating of each product line?
SELECT 
	ROUND(AVG(rating), 2) AS avg_rating,
	product_line
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- -----------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------- Sales -------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT time_of_day,
		COUNT(*) AS total_sales
FROM [Walmart Sales].dbo.WalmartSales
WHERE day_name = 'Sunday'
GROUP BY time_of_day
ORDER BY total_sales DESC;


-- Which of the customer types brings the most revenue?
SELECT customer_type,
		SUM(total) AS total_revenue
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY customer_type
ORDER BY total_revenue DESC;


-- Which city has the largest tax percent/VAT(value added tax)?
SELECT city,
		AVG(VAT) AS VAT
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY city
ORDER BY VAT DESC;


-- Which customer type pays the most in VAT?
SELECT customer_type,
		AVG(VAT) VAT
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY customer_type
ORDER BY VAT DESC;



-- ------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------- Customers ---------------------------------------------------------------------

-- How many unique customer types does the data have? 
SELECT customer_type,
	COUNT(DISTINCT customer_type) AS customer_cnt
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY customer_type;


-- How many unique payment methods does the data have?
SELECT payment,
	COUNT(DISTINCT payment) AS payment_cnt
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY payment;


-- What is the most common customer type?  
SELECT customer_type,
		COUNT(customer_type) AS customer_cnt
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY customer_type
ORDER BY customer_cnt DESC;


-- Which customer type buys the most?
SELECT customer_type,
		COUNT(*) AS customer_cnt
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY customer_type;


-- What is the gender of the most customer? 
SELECT gender,
		COUNT(*) AS gender_cnt
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY gender
ORDER BY gender_cnt DESC;


-- What is the gender distribution per branch?
SELECT gender,
		COUNT(*) AS gender_cnt
FROM [Walmart Sales].dbo.WalmartSales
WHERE branch = 'C'
GROUP BY gender
ORDER BY gender_cnt DESC;


-- Which time of the day do customers gives most ratings?
SELECT time_of_day,
		AVG(rating) AS avg_rating
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Which time of the day do customers gives most ratings per branch?
SELECT time_of_day,
		AVG(rating) AS avg_rating
FROM [Walmart Sales].dbo.WalmartSales
WHERE branch = 'C'
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Which day of the week has the the best avg rating?
SELECT day_name,
		AVG(rating) AS avg_rating
FROM [Walmart Sales].dbo.WalmartSales
GROUP BY day_name
ORDER BY avg_rating DESC;


-- Which day of the week has the best average ratings per branch?
SELECT day_name,
		AVG(rating) AS avg_rating
FROM [Walmart Sales].dbo.WalmartSales
WHERE branch = 'A'
GROUP BY day_name
ORDER BY avg_rating DESC;
