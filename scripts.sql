select count (*)
from app_store_apps;
--7197
SELECT count (*)
FROM play_store_apps;
--10840
select count *
from app_store_apps;

SELECT *
FROM play_store_apps;

SELECT name,
type,
(cast(price as float))
from play_store_apps
order by price desc;
-- Query the name and distinct rating
SELECT 
	DISTINCT(name) ,
	 SUM(review_count) AS total_review_counts,
	 SUM(cast(review_count as float ))
    AVG(cast(rating as float)) AS avg_rating
FROM app_store_apps
GROUP BY name
-- Only include the 3 sports with the most athletes
ORDER BY avg_rating desc
LIMIT 3;
/* Removing the $ sign in the price columns*/
UPDATE play_store_apps
SET price = REPLACE(price, '$', '' )

/*The total amount by genre*/
SELECT  primary_genre, SUM(price) AS sum_price
FROM app_store_apps
GROUP BY primary_genre
ORDER BY sum_price DESC;

--SELECT avg(regexp_replace(price::text, '[$,]', '', 'g')::numeric)

--Query name, size_bytes, price, review_count, rating  for all app_store_apps
SELECT  
   name,
	size_bytes, 
	price,
	rating,
	review_count
FROM app_store_apps
ORDER BY size_bytes DESC

LIMIT 20;

		
JOIN play_store_apps AS pl
ON ap.name = pl.name
GROUP BY ap.name;
-- Combine the queries
UNION ALL
-- Query season, country, and events for all winter events
SELECT 
	'winter' AS season, 
    country, 
    count(distinct(winter_games.event)) AS events
FROM winter_games
JOIN countries
ON winter_games.country_id = countries.id
GROUP BY countries.country
-- Sort the results to show most events at the top
ORDER BY events;
		
SELECT 
	distinct(name),
    price,
    rating,
    -- Show max rating per app_name and alias accordingly
	MAX(rating) OVER (PARTITION BY name) AS app_max
FROM app_store_apps
		ORDER BY rating DESC
		LIMIT 20;
-- 		
SELECT 
	distinct(name),
    price,
	category,
    content_rating,
	rating,
    -- Show max content_rating per app_name alias accordingly
	MAX(content_rating) OVER (PARTITION BY name) AS CONT_max
FROM play_store_apps
		ORDER BY content_rating DESC
		LIMIT 20;	
		
SELECT 
   name,
	primary_genre,
    CASE WHEN rating <= 0.0 THEN '0.0'
    WHEN rating <= 1.0 THEN '0.0-1.0'
    WHEN  rating > 1.0 AND rating <=1.5 THEN '1.0-1.5'
	WHEN  rating > 1.5 AND rating <=2.0 THEN '1.5-2.0'
	WHEN  rating > 2.0 AND rating <=2.5 THEN '2.0-2.5'
	WHEN  rating > 2.5 AND rating <=3.0 THEN '2.5-3.0'
	WHEN  rating > 3.0 AND rating <=3.5 THEN '3.0-3.5'
	WHEN  rating > 3.5 AND rating <=4.0 THEN '3.5-4.0'
	WHEN  rating > 4.0 AND rating <=4.5 THEN '4.0-4.5'
	WHEN  rating > 4.5 AND rating <=5.0 THEN '4.0-5.0'
    -- Add ELSE statement to output 'no rating recorded'
    ELSE 'no rating recorded' END AS rating_bucket
    
FROM app_store_apps
LIMIT 20;
--JOIN play_store_apps AS pl
--ON ap.name = pl.name
GROUP BY rating_bucket;
ORDER BY name, rating DESC;		

SELECT 
review_count,
    CASE WHEN rating <= 0.0 THEN '0.0'
    WHEN rating <= 1.0 THEN '0.0-1.0'
    WHEN  rating > 1.0 AND rating <=1.5 THEN '1.0-1.5'
	WHEN  rating > 1.5 AND rating <=2.0 THEN '1.5-2.0'
	WHEN  rating > 2.0 AND rating <=2.5 THEN '2.0-2.5'
	WHEN  rating > 2.5 AND rating <=3.0 THEN '2.5-3.0'
	WHEN  rating > 3.0 AND rating <=3.5 THEN '3.0-3.5'
	WHEN  rating > 3.5 AND rating <=4.0 THEN '3.5-4.0'
	WHEN  rating > 4.0 AND rating <=4.5 THEN '4.0-4.5'
	WHEN  rating > 4.5 AND rating <=5.0 THEN '4.0-5.0'
    -- Add ELSE statement to output 'no rating recorded'
    ELSE 'no rating recorded' END AS rating_bucket
    
FROM app_store_apps

GROUP BY rating_bucket 
ORDER BY (cast(review_count as float )) DESC
LIMIT 20;

SELECT 
	sum() as bronze_medals, 
    sum(silver) as silver_medals, 
    sum(gold) as gold_medals
FROM summer_games
-- Add the WHERE statement below
WHERE athlete_id IN
    -- Create subquery list for athlete_ids age 16 or below    
    (SELECT id 
     FROM athletes
     WHERE age <= 16);

SELECT 	
	name,
	count(distinct(category)) AS categories
FROM play_store_apps
GROUP BY name
ORDER BY categories DESC
LIMIT 20;

SELECT 
	type, 
    -- Add the gender field below
    CASE WHEN type LIKE '%Free%' THEN 'Free_apps'
	WHEN type LIKE '%Paid%' THEN 'Paid_apps'
    ELSE 'not recorded' END AS apps,
    COUNT(DISTINCT name) AS app_names
FROM play_store_apps
GROUP BY type;

SELECT 
	name,
	rating,
	price,
	size_bytes,
	review_count,
    -- Add the gender field below
    CASE WHEN  price <=0.0 THEN 'Free_apps'
	WHEN price > 0.0 THEN 'Paid_apps'
    ELSE 'not recorded' END AS apps
    --COUNT(DISTINCT Paid_apps) AS app_paid
FROM app_store_apps
GROUP BY apps, price, name, rating, size_bytes, review_count 
ORDER BY (cast(review_count as float )) DESC
LIMIT 30;

SELECT 
	distinct primary_genre AS genres,
	rating,
	name
	FROM app_store_apps
group by name, genres, rating
order by rating DESC;
--Cross_over apps 
SELECT name, price
FROM app_store_apps 
INTERSECT 
SELECT name, (cast(price as numeric ))
FROM play_store_apps
ORDER BY name;
--298
SELECT ap.name
FROM app_store_apps AS ap
INTERSECT
SELECT pl.name
FROM play_store_apps AS pl;
--328 named apps cross-over

/* Cross-over apps w/> avg rating and good price/rating*/
SELECT ap.name, ap.rating, price 
FROM app_store_apps AS ap
EXCEPT
SELECT pl.name, pl.rating, (cast(pl.price as numeric ))
FROM play_store_apps AS pl
WHERE name != '%棒棒糖-宝宝的世界衣橱%'
ORDER BY rating DESC, price ASC;

SELECT name, rating, price
FROM
	(SELECT ap.name
FROM app_store_apps AS ap
INTERSECT
SELECT pl.name
FROM play_store_apps AS pl) AS subquery
FROM subquery
group by name
order by rating;


SELECT 
	name,
    AVG(rating) AS avg_total_ratings
FROM
  (SELECT 
      name, 
      cou, 
      SUM(gold) AS total_golds
  FROM summer_games_clean AS s
  JOIN countries AS c
  ON s.country_id = c.id
  -- Alias the subquery
  GROUP BY region, country_id) AS subquery
GROUP BY region
-- Order by avg golds in descending order
ORDER BY avg_total_golds DESC;

SELECT 
name,
currency, 
price,
review_count,
rating,
content_rating
primary_genre
FROM app_store_apps
WHERE rating BETWEEN 4.0 AND 5.0
GROUP BY rating, name, currency,review_count,price, content_rating, primary_genre
ORDER BY rating;

SELECT 
primary_genre,
AVG(price) AS avg_price
FROM app_store_apps
GROUP BY primary_genre
ORDER BY avg_price DESC;

SELECT primary_genre,
COUNT(primary_genre)AS total_count
FROM app_store_apps
GROUP BY primary_genre
ORDER BY total_count DESC;

SELECT primary_genre,
COUNT(primary_genre)AS total_count,
AVG(price) AS avg_price,
AVG(rating) AS avg_rating
FROM app_store_apps
GROUP BY primary_genre
ORDER BY avg_price ASC, avg_rating DESC;

SELECT genres,
COUNT(genres)AS total_count,
AVG(cast(price as numeric )) AS avg_price,
content_rating
FROM play_store_apps
GROUP BY genres, content_rating
ORDER BY total_count DESC;

SELECT *
FROM play_store_apps
WHERE genres = 'Entertainment';


SELECT pl.name as play_store_names,
pl.genres,
pl.price,
pl.content_rating,
pl.rating,
ap.name As app_store_names,
ap.primary_genre,
ap.price,
ap.rating,
ap.content_rating
FROM play_store_apps AS pl
INNER JOIN app_store_apps AS ap
ON pl.name = ap.name
ORDER BY pl.rating DESC, 
ap.rating DESC
LIMIT 20;
--553 
/* MOST POPULAR APP_STORE_APPS*/
SELECT name,
review_count
FROM app_store_apps
ORDER BY (cast(review_count as numeric )) DESC
LIMIT 10;
/* MOST POPULAR PLAY_STORE_APPS*/
SELECT DISTINCT(name),
SUM(review_count)
FROM play_store_apps
GROUP BY name
ORDER BY sum(review_count) DESC
LIMIT 10;
--% free vs paid
SELECT name,
CASE WHEN price <=0.0 THEN 'free_app'
ELSE 'paid_app' END AS app_cost
FROM app_store_apps
COUNT(app_cost = 'free_app') AS total_free,
COUNT(app_cost  is '%paid_app%') AS total_paid;

SELECT price
FROM app_store_apps
WHERE (sum(price =0.0)
AND (sum(price > 0.0)
	 
SELECT name,
	 rating,
	 price,
	 review_count
FROM app_store_apps
WHERE price = 0.0 AND (cast(review_count as int)) >= 13000
ORDER BY rating DESC;
	 
--DUPLICATES APP store 
SELECT name, COUNT(*) AS duplicates
FROM app_store_apps
GROUP BY name 
HAVING COUNT(*) >1;	
--2
--DUPLICATES app Store	 
SELECT name, COUNT(*) AS duplicates
FROM play_store_apps
GROUP BY name 
HAVING COUNT(*) >1 
	 ORDER BY COUNT(*) DESC;
--798 
-- INNER JOIN ON APP Names 
SELECT ap.name, 
	 ap.price AS app_price, 
	 ap.rating AS app_rating,
	 ap.review_count AS review_count_app,
	 pl.price AS play_price,
	 pl.rating AS play_rating,
	 pl.review_count AS review_count_app,
	 cast(ap.rating as numeric ) - pl.review_count AS review_count_diff,
	 cast(ap.rating as numeric ) - pl.rating AS difference_in_rating,
	 cast(ap.price as numeric ) - cast(pl.price as numeric ) AS difference_in_price
  FROM app_store_apps AS ap
       INNER JOIN play_store_apps AS pl
       ON ap.name=pl.name
	 ORDER BY cast(ap.price as numeric ) - cast(pl.price as numeric ) DESC;
	
-- 553 Rows common apps 
/* ORDER BY REVIEW_COUNT*/	 

	 SELECT DISTINCT(ap.name), 
	 ap.price AS app_price, 
	 ap.rating AS app_rating,
	 ap.review_count AS review_count_app,
	 pl.price AS play_price,
	 pl.rating AS play_rating,
	 pl.review_count AS review_count_app,
	 cast(ap.rating as numeric ) - pl.review_count AS review_count_diff,
	 cast(ap.rating as numeric ) - pl.rating AS difference_in_rating,
	 cast(ap.price as numeric ) - cast(pl.price as numeric ) AS difference_in_price
  FROM app_store_apps AS ap
       INNER JOIN play_store_apps AS pl
       ON ap.name=pl.name
	 --ORDER BY pl.review_count - cast(ap.rating as numeric ) DESC;
	 ORDER BY cast(ap.rating as numeric ) - pl.review_count ASC;
	 --ORDER BY ap.price - cast(pl.price as numeric )  DESC;
	 
	 
	 
--328
--NULL VALUES
SELECT count(*) - count(rating) AS missing
	 FROM play_store_apps;
--rating NULL values 1474

SELECT count(*) - count(type) AS missing
	 FROM play_store_apps;
-- type NULL value 1
	 
SELECT count(*) - count(genres) AS missing
	 FROM play_store_apps;
	 
-- Replacing the dollar sign in the table
--SELECT avg(regexp_replace(price::text, '[$,]', '', 'g')::numeric)

-- table of earnings and purchase price per app
	 
SELECT
	 name, 
	 rating,
	 price,
	 ROUND((rating/0.5),0)*60000 AS earnings,
	 ROUND((rating/0.5+1),0)*12000 AS marketing,
	 CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END AS purchase_price
	 FROM app_store_apps;
	 
 /* TOP 20 most profitable apps*/	 
	 SELECT
	 name, 
	 rating,
	 price,
	 ROUND((rating/0.5),0)*60000 AS earnings,
	 ROUND((rating/0.5+1),0)*12000 AS marketing,
	 CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END AS purchase_price,
	 ROUND((rating/0.5),0)*60000 -(CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END) AS Profit_loss_margin
	 FROM app_store_apps
	 ORDER BY profit_loss_margin DESC
	 LIMIT 20;

	 /* TOP 10 most profitable apps*/
	 SELECT
	 name, 
	 rating,
	 price,
	 ROUND((rating/0.5),0)*60000 AS earnings,
	 ROUND((rating/0.5+1),0)*12000 AS marketing,
	 CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END AS purchase_price,
	 ROUND((rating/0.5),0)*60000 -(CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END) AS Profit_loss_margin
	 FROM app_store_apps
	 ORDER BY profit_loss_margin DESC
	 LIMIT 10; 
/* Bottom 10 Most unproductive apps*/
	 
SELECT
	 name, 
	 rating,
	 price,
	 ROUND((rating/0.5+1),0)*60000 AS earnings,
	 ROUND((rating/0.5+1),0)*12000 AS marketing,
	 CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END AS purchase_price,
	 ROUND((rating/0.5+1),0)*60000 -(CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END) AS Profit_loss_margin
	 FROM app_store_apps
	 ORDER BY profit_loss_margin ASC
	 LIMIT 10;
/* TOP 10 Play_store apps*/ 
	 
SELECT
	 name, 
	 rating,
	 price,
	 ROUND((rating/0.5 + 1),0)*60000 AS earnings,
	 ROUND((rating/0.5 + 1),0)*1200 AS marketing,
	 CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END AS purchase_price,
	 ROUND((rating/0.5 +1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END) AS Profit_loss_margin
	 FROM play_store_apps
	 WHERE (ROUND((rating/0.5 + 1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 + (ROUND((rating/0.5 + 1),0)* 12000 END) >0
	 ORDER BY profit_loss_margin DESC
	 LIMIT 20;	
/* Bottom 10 PLAY_store APPs*/ 
SELECT
	 name, 
	 rating,
	 price,
	review_count,
	 ROUND((rating/0.5+1),0)*60000 AS earnings,
	ROUND((rating/0.5+1),0)*12000 AS marketing,										  
	 CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END AS purchase_price,
											  
	 ROUND((rating/0.5+1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )* 10000 END)- (ROUND((rating/0.5+1),0) * 12000) AS Profit_loss_margin
	 FROM play_store_apps
	 --WHERE (ROUND((rating/0.5+1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 --ELSE (cast(price as numeric) * 10000 END) - (ROUND((rating/0.5+1),0) * 12000) < 0
	 ORDER BY profit_loss_margin DESC
	 LIMIT 100;		 
-- All apps ON JOIN Tables	
--Cost of app_store and profit margin updated	 
 SELECT
	 name, 
	 rating,
	 price,
	primary_genre,										  
	cast(review_count as numeric),									  
	 ROUND((rating/0.5+1),0)*60000 AS earnings,
	ROUND((rating/0.5+1),0)*12000 AS marketing,
	CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END AS purchase_price,
											  
	 ROUND((rating/0.5+1),0)*60000 -(CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END) - (ROUND((rating/0.5+1),0)*12000) AS Profit_loss_margin
											  
	 FROM app_store_apps
	 --ORDER BY profit_loss_margin DESC;
		--ORDER BY profit_loss_margin DESC, cast(review_count as numeric)DESC, rating DESC, price ='0.00'
		ORDER BY profit_loss_margin  DESC, review_count DESC									  
		LIMIT 10;								  
 
	 --TOP 10 PLAY STORE APPS WITH THE BEST RATING, PROFIT, REVIEW_COUNT
											  
	 SELECT
	 name, 
	 rating,
	 price,
	 review_count,									  
	 ROUND((rating/0.5+1),0)*60000 AS earnings,
	 ROUND((rating/0.5+1),0)*12000	AS marketing,									  
	 CASE WHEN cast(price as numeric) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END AS purchase_price,
	 ROUND((rating/0.5+1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END) - (ROUND((rating/0.5+1),0)*12000) AS profit_loss_margin
	 FROM play_store_apps
	 WHERE (ROUND((rating/0.5+1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 - (ROUND((rating/0.5+1),0)*12000) END)) >0
	 ORDER BY  profit_loss_margin  DESC, rating DESC;
			
				--END 
									  
	order by profit_loss_margin  DESC, rating DESC, cast(review_count as numeric) DESC;										  
	 LIMIT 10;	
	--TOP 10 PLAY STORE APPS WITH THE BEST PROFIT,& REVIEW_COUNT	
	SELECT
	 name, 
	 rating,
	 price,
	 review_count,									  
	 ROUND((rating/0.5+1),0)*60000 AS earnings,
	 ROUND((rating/0.5+1),0)*12000	AS marketing,									  
	 CASE WHEN cast(price as numeric) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END AS purchase_price,
	 ROUND((rating/0.5+1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END) - (ROUND((rating/0.5+1),0)*12000) AS profit_loss_margin
	 FROM play_store_apps
	 WHERE (ROUND((rating/0.5+1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 - (ROUND((rating/0.5+1),0)*12000) END)) >0
	 ORDER BY  profit_loss_margin  DESC, review_count DESC
	LIMIT 10;										  
											  
											  
											  
--JOIN APP STORE and PLAY STORE											  
	 
	 SELECT
	 DISTINCT pl.name,pl.price,pl.rating, 
	 ap.name,ap.price,ap.rating,
	ROUND((pl.rating/0.5+1),0)*60000 AS earnings,
	 CASE WHEN cast(pl.price as numeric ) <=1 THEN 10000
	 ELSE cast(pl.price as numeric )*10000 END AS purchase_price,
	 ROUND((pl.rating/0.5+1),0)*60000 -(CASE WHEN cast(pl.price as numeric ) <=1 THEN 10000
	 ELSE cast(pl.price as numeric )*10000 END) - (ROUND((pl.rating/0.5+1),0) * 12000) AS pl_profit_loss_margin,
											  
	--cast(ap.review_count as numeric),									  
	 ROUND((ap.rating/0.5+1),0)*60000 AS earnings,
	ROUND((ap.rating/0.5+1),0)*12000 AS marketing,
	CASE WHEN ap.price <=1 THEN 10000
	 ELSE ap.price*10000 END AS purchase_price,
											  
	 ROUND((ap.rating/0.5+1),0)*60000 -(CASE WHEN ap.price <=1 THEN 10000
	 ELSE ap.price*10000 END) - (ROUND((ap.rating/0.5+1),0)*12000) AS ap_profit_loss_margin
	 FROM play_store_apps AS pl
	 INNER JOIN app_store_apps AS ap									  
	 ON pl.name = ap.name 										  
	
	ORDER BY ap_profit_loss_margin DESC
		LIMIT 1000;
-- 329 rows	
											  
WITH S AS (											  
	SELECT
	 DISTINCT
	 (pl.name),pl.price,pl.rating
	cast(review_count as numeric),									  
	 ROUND((rating/0.5+1),0)*60000 AS earnings,
	ROUND((rating/0.5+1),0)*12000 AS marketing,
	CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END AS purchase_price,
	 ROUND((rating/0.5+1),0)*60000 -(CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END) - (ROUND((rating/0.5+1),0)*12000) AS Profit_loss_margin
FROM play_store_apps;
	SELECT 
	 ap.name,ap.price,ap.rating, 
	
	
--CTE	
	
WITH pl AS (
	SELECT
	 name, 
	 rating,
	 price,
	 review_count,									  
	 ROUND((rating/0.5+1),0)*60000 AS earnings,
	 CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END AS purchase_price,
	 ROUND((rating/0.5+1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END) AS Profit_loss_margin
	 FROM play_store_apps
	 WHERE (ROUND((rating/0.5+1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 - (ROUND((rating/0.5+1),0)*12000) END)) >0
	 --ORDER BY review_count DESC;
	order by profit_loss_margin ASC)
	
	SELECT
	 ap.name, 
	 ap.rating,
	 ap.price,
	ap.primary_genre
	FROM app_store_apps AS ap
	INNER JOIN pl
	ON ap.name = pl.name
	GROUP BY ap.name,ap.rating,
	 ap.price,
	ap.primary_genre
	ORDER BY rating DESC, price ASC;
	
-- END of CTE	
	
	--cast(review_count as numeric),									  
	 ROUND((rating/0.5+1),0)*60000 AS earnings,
	ROUND((rating/0.5+1),0)*12000 AS marketing,
	CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END AS purchase_price,
											  
	 ROUND((rating/0.5+1),0)*60000 -(CASE WHEN price <=1 THEN 10000
	 ELSE price*10000 END) - (ROUND((rating/0.5+1),0)*12000) AS Profit_loss_margin
											  
	 FROM app_store_apps AS ap
	 --ORDER BY profit_loss_margin DESC;
		--ORDER BY profit_loss_margin DESC, cast(review_count as numeric)DESC, rating DESC
		
	INNER JOIN pl
	ON ap.name = pl.name
	GROUP BY name
	ORDER BY profit_loss_margin DESC, cast(review_count as numeric)DESC, rating DESC
	LIMIT 100;
	
	
	--NEW CTEs
	WITH pl1 AS (
		SELECT ap.name, rating
		FROM app_store_apps AS ap
		WHERE price<=0 AND rating >=5)
	SELECT
	 name, 
	 rating,
	 price,
	 review_count,									  
	 ROUND((rating/0.5+1),0)*60000 AS earnings,
	 CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END AS purchase_price,
	 ROUND((rating/0.5+1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END) AS Profit_loss_margin
	 FROM play_store_apps
	 WHERE (ROUND((rating/0.5+1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 - (ROUND((rating/0.5+1),0)*12000) END)) >0
	 INNER JOIN pl1
	ON ap.name = pl1.name
	GROUP BY name;
	
	--ANOTHER CTE TABLE
	
	WITH pl AS (
		SELECT
	name
	price,
	 review_count,									  
	 ROUND((rating/0.5+1),0)*60000 AS earnings,
	 CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END AS purchase_price,
	 ROUND((rating/0.5+1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 END) AS Profit_loss_margin
	 FROM play_store_apps
	 WHERE (ROUND((rating/0.5+1),0)*60000 -(CASE WHEN cast(price as numeric ) <=1 THEN 10000
	 ELSE cast(price as numeric )*10000 - (ROUND((rating/0.5+1),0)*12000) END)) >0)
	SELECT 
	ap.name, ap.price, ap.review_count, ap.rating
	FROM app_store_apps AS ap
	INNER JOIN pl
	ON ap.name = ap.name
	GROUP BY ap.name, ap.price, ap.review_count, ap.rating
	ORDER BY ap.price;
	--#####
	SELECT
    ap.primary_genre,
    (SELECT name
     FROM app_store_apps AS ap
     WHERE ap.team_api_id = m.hometeam_id) AS hometeam,
    -- Connect the team to the match table
    (SELECT team_long_name
     FROM team AS t
     WHERE team_api_id = awayteam_id) AS awayteam,
    -- Select home and away goals
     home_goal,
     away_goal
FROM match AS m;
	
--FITBIT UNION	
	
SELECT name,size_bytes, price, cast(review_count as numeric), rating, content_rating, primary_genre
	
	FROM  app_store_apps as ap
	WHERE LOWER(ap.name) ='fitbit'
	UNION ALL
	--FITBIT PLAY STORE
	SELECT name, size as size_bytes, cast(price as numeric), review_count, rating, content_rating, genres as primary_genre

	FROM  play_store_apps as pl
	
	WHERE LOWER(pl.name) ='fitbit';
	
	
-- JOINING THE TABLES COSTS TO SHOW THE TOTAL PROFIT ACROSS THE TABLES
	
	
	
	SELECT
	 DISTINCT(pl.name), 
	 pl.rating,
	 pl.price,
	 ap.name, 
	 ap.rating,
	 ap.price,
	 pl.review_count,									  
	 ROUND((((pl.rating + ap.rating)/2)/0.5+1),0)*60000 AS earnings,
	 ROUND((((pl.rating + ap.rating)/2)/0.5+1),0)*6000 AS marketing,									  
	 CASE WHEN AVG(cast(pl.price as numeric) + ap.price) <=1 THEN 10000
	 ELSE (cast(pl.price as numeric) + ap.price) * 10000 END AS purchase_price,
	 ROUND((((pl.rating + ap.rating)/2)/0.5+1),0)*60000 -(CASE WHEN AVG(cast(pl.price as numeric) + ap.price) <=1 THEN 10000
	 ELSE (cast(pl.price as numeric)+ ap.price)*10000 END) - (ROUND((((pl.rating + ap.rating)/2)/0.5+1),0)*6000) AS profit_loss_margin
	 FROM play_store_apps AS pl
	 --WHERE (ROUND(AVG((pl.rating+ap.rating)/0.5+1),0)*60000 -(CASE WHEN AVG(cast(pl.price as numeric) + ap.price) <=1 THEN 10000
	-- ELSE AVG(cast(pl.price as numeric) + ap.price) * 10000 END) - (ROUND(AVG((pl.rating+ap.rating)/0.5+1),0)*12000) >0
	INNER JOIN app_store_apps AS ap
	ON pl.name = ap.name
	GROUP BY pl.name, 
	 pl.rating,
	 pl.price,
	ap.name, 
	 ap.rating,
	 ap.price,
	 pl.review_count
	
	 ORDER BY  profit_loss_margin  DESC, pl.review_count DESC
	LIMIT 10;	
	
	--END--
	
	SELECT name, earnings, marketing, purchase_price, profit_loss_margin
	FROM(
	SELECT
	 DISTINCT(pl.name), 
	 pl.rating,
	 pl.price,
	 ap.name, 
	 ap.rating,
	 ap.price,
	 pl.review_count,									  
	 ROUND((((pl.rating + ap.rating)/2)/0.5+1),0)*60000 AS earnings,
	 ROUND((((pl.rating + ap.rating)/2)/0.5+1),0)*6000 AS marketing,									  
	 CASE WHEN AVG(cast(pl.price as numeric) + ap.price) <=1 THEN 10000
	 ELSE (cast(pl.price as numeric) + ap.price) * 10000 END AS purchase_price,
	 ROUND((((pl.rating + ap.rating)/2)/0.5+1),0)*60000 -(CASE WHEN AVG(cast(pl.price as numeric) + ap.price) <=1 THEN 10000
	 ELSE (cast(pl.price as numeric)+ ap.price)*10000 END) - (ROUND((((pl.rating + ap.rating)/2)/0.5+1),0)*6000) AS profit_loss_margin
	 FROM play_store_apps AS pl
	 --WHERE (ROUND(AVG((pl.rating+ap.rating)/0.5+1),0)*60000 -(CASE WHEN AVG(cast(pl.price as numeric) + ap.price) <=1 THEN 10000
	-- ELSE AVG(cast(pl.price as numeric) + ap.price) * 10000 END) - (ROUND(AVG((pl.rating+ap.rating)/0.5+1),0)*12000) >0
	INNER JOIN app_store_apps AS ap
	ON pl.name = ap.name) AS subquery
	LIMIT 10;
		
	--GROUP BY name
	 ORDER BY  profit_loss_margin  DESC
	LIMIT 10;	
	
	--END
	
	SELECT 
	AVG(price)
	FROM app_store_apps;
	--"1.7262178685563429"
	SELECT 
	AVG (cast(price as numeric))
	FROM play_store_apps;
	--"1.02736808118081180812"
--ALL	APP STORE
	
	SELECT 
DISTINCT a.name, 
a.primary_genre,
a.price AS app_store_price, 
a.rating AS app_store_rating, 
CAST(trim('$' from p.price) as NUMERIC) AS play_store_price,
p.rating AS play_store_rating,
(a.rating + a.rating +1)*12  AS life_of_app_store_app,
((ROUND((p.rating*2),0)/2)+ ROUND(((p.rating*2)/2),0)+1)*12 AS life_of_play_store_app,
(((a.rating + a.rating +1)*12)*4500)-10000 AS lifetime_earnings_ASA,
((((ROUND(p.rating*2,0)/2)+(ROUND(p.rating*2,0)/2)+1)*12)*4500)-10000 AS lifetime_earnings_PSA
FROM app_store_apps AS a
INNER JOIN play_store_apps as p
ON a.name = p.name
WHERE CAST(a.review_count AS int) > 20000
AND a.rating >= 4.5
AND p.rating >= 4.5
AND a.price <= 0.99
ORDER BY lifetime_earnings_asa DESC, lifetime_earnings_psa DESC
LIMIT 10;
	