------------------------------------------------------------------------------------
-- PROJECT: Amazon Pricing Strategy Analysis
-- OBJECTIVE: Extract insights on discounts, ratings, and financial impact.
------------------------------------------------------------------------------------

-- Q1: Categories with the highest average discount percentage.
SELECT 
    category, 
    ROUND(AVG(discount_percentage) * 100, 2) AS avg_discount
FROM amazon_reviews
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q2: Quality vs. Price (High Discount vs. Overall Average)
SELECT
    ROUND(AVG(CASE 
        WHEN discount_percentage > 0.5 AND rating <> '|' 
        THEN CAST(rating AS NUMERIC) 
    END), 2) AS high_discount_avg_rating,

    ROUND(AVG(CASE 
        WHEN rating <> '|' 
        THEN CAST(rating AS NUMERIC) 
    END), 2) AS overall_avg_rating
FROM amazon_reviews;

-- Q3: Top Tier Products
-- Products with 10k+ reviews and best ratings.
SELECT 
    SUBSTR(product_name, 1, 50) AS product, 
    rating,
    rating_count
FROM amazon_reviews
WHERE rating_count > 10000 AND rating <> '|'
ORDER BY CAST(rating AS NUMERIC) DESC, rating_count DESC
LIMIT 10;

-- Q4: Financial Impact (Real Cash Savings)
SELECT 
    category,
    COUNT(*) AS total_products,
    ROUND(AVG(actual_price - discounted_price), 2) AS avg_savings_value
FROM amazon_reviews
GROUP BY category
HAVING COUNT(*) > 10
ORDER BY avg_savings_value DESC
LIMIT 5;

-- Q5: The Extremes (Loss Leaders vs. Essentials)
(SELECT 
    'HIGHEST DISCOUNT' AS status,
    SUBSTR(product_name, 1, 50) AS product, 
    ROUND(discount_percentage * 100, 2) AS discount_pct,
    rating,
    rating_count AS total_reviews
FROM amazon_reviews
ORDER BY discount_percentage DESC
LIMIT 1)
UNION ALL
(SELECT 
    'LOWEST DISCOUNT' AS status,
    SUBSTR(product_name, 1, 50) AS product, 
    ROUND(discount_percentage * 100, 2) AS discount_pct,
    rating,
    rating_count AS total_reviews
FROM amazon_reviews
WHERE discount_percentage > 0
ORDER BY discount_percentage ASC
LIMIT 1);