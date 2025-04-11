USE sqlcasestudy;
SELECT * FROM playstore;
truncate playstore;

load data infile "D:/Data Analysis/Data Analysis using SQL/CaseStudy02/playstore.csv"
into table playstore
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

/*
1. You're working as a market analyst for a mobile app development 
company. Your task is to identify the most promising categories (TOP 5) 
for launching new free apps based on their average ratings. 
*/
SELECT Category, AVG(Rating) as Avg_rating 
From playstore WHERE Type = 'Free' 
Group By Category 
ORDER BY Avg_rating DESC 
LIMIT 5;

/*
2. As a business strategist for a mobile app company, your objective is 
to pinpoint the three categories that generate the most revenue from 
paid apps. This calculation is based on the product of the app price 
and its number of installations.
*/
SELECT Category, AVG(rev) as 'Revenue' FROM (
	SELECT *, (Installs*Price) as 'rev'
	FROM playstore WHERE Type = 'Paid'
	)t 
    GROUP BY Category 
    ORDER BY Revenue DESC 
    LIMIT 3;

/*
3. As a data analyst for a company, you're tasked with 
calculating the percentage of apps within each category. This 
information will help the company understand the distribution of 
apps across different categories.
*/
SELECT Category, ((no_of_apps)/(SELECT COUNT(*) FROM playstore)) * 100 AS Percentage FROM
(
	SELECT Category, COUNT(app) as no_of_apps 
	FROM playstore GROUP BY Category
)t ORDER BY Percentage DESC;

/*
4. As a data analyst at a mobile app-focused market research firm you’ll 
recommend whether the company should develop paid or free apps 
for each category based on the ratings of that category. 
*/
WITH t1 AS 
(
	SELECT Category, ROUND(AVG(Rating), 2) AS avg_rating_paid FROM playstore WHERE Type = 'Paid' Group by Category
),
t2 AS 
(
	SELECT Category, ROUND(AVG(Rating), 2) AS avg_rating_free FROM playstore WHERE Type = 'Free' Group by Category
)
SELECT *, IF(avg_rating_paid>avg_rating_free, "Develop Paid App", "Develop Free App") AS Decision 
FROM
(
	SELECT a.Category, avg_rating_paid, avg_rating_free FROM t1 AS a INNER JOIN t2 AS b ON a.Category = b.Category
)k;

/*
5. Suppose you're a database administrator your databases have been 
hacked and hackers are changing price of certain apps on the 
database, it is taking long for IT team to neutralize the hack, however 
you as a responsible manager don’t want your data to be changed, do 
some measure where the changes in price can be recorded as you 
can’t stop hackers from making changes.
*/
CREATE TABLE PriceChangeLog (
	App VARCHAR(255),
    Old_Price DECIMAL(10, 2),
    New_Price DECIMAL(10, 2),
    Operation_Type VARCHAR(10),
    Operation_Date TIMESTAMP
);

-- copy of playstore table
CREATE TABLE playstorecopy AS 
SELECT * FROM playstore;

DELIMITER // 
CREATE TRIGGER price_change_update
AFTER UPDATE ON playstorecopy
FOR EACH ROW
BEGIN 
	INSERT INTO PriceChangeLog( App, Old_Price, New_Price, Operation_Type, Operation_Date) 
    VALUES (NEW.App, OLD.Price, NEW.Price, 'UPDATE', CURRENT_TIMESTAMP);
end;
// DELIMITER ;

SET SQL_SAFE_UPDATES = 0;

UPDATE playstorecopy
SET price = 4
WHERE app = 'Coloring book moana';

UPDATE playstorecopy
SET price = 5
WHERE app = 'Photo Editor & Candy Camera & Grid & ScrapBook';

SELECT * FROM pricechangelog;

/*
Your IT team have neutralized the threat; however, hackers have 
made some changes in the prices, but because of your measure you 
have noted the changes, now you want correct data to be inserted 
into the database again.
*/
SELECT * FROM playstorecopy AS a INNER JOIN pricechangelog AS b ON a.App = b.App;

DROP TRIGGER price_change_update;

UPDATE playstorecopy AS a 
INNER JOIN pricechangelog AS b ON a.App = b.App
SET a.Price = b.Old_Price;

SELECT * FROM playstorecopy WHERE App = 'Photo Editor & Candy Camera & Grid & ScrapBook';
SELECT * FROM playstorecopy WHERE App = 'Coloring book moana';

/*
7. As a data person you are assigned the task of investigating the 
correlation between two numeric factors: app ratings and the 
quantity of reviews.
*/
SET @avg_rating =( SELECT ROUND(AVG(Rating)) FROM playstore);
SET @avg_reviews =( SELECT ROUND(AVG(Reviews)) FROM playstore);

WITH t AS 
(
	SELECT *, ROUND((rat*rat), 2) AS 'sqr_X', ROUND((rev*rev), 2) AS 'sqr_Y'
	FROM (
	SELECT Rating, @avg_rating, ROUND((Rating - @avg_rating), 2) AS 'rat', Reviews, @avg_reviews, ROUND((Reviews-@avg_reviews), 2) AS 'rev'
	FROM playstore
	)t
)
SELECT @numerator := SUM(rat*rev), @deno_1 := SUM(sqr_X), @deno_2 := SUM(sqr_Y) FROM t;
SELECT ROUND( (@numerator)/(SQRT(@deno_1*@deno_2)), 2) as "Correlation Cofficient, r";

/*
Your boss noticed  that some rows in genres columns have multiple 
genres in them, which was creating issue when developing the  
recommender system from the data he/she assigned you the task to 
clean the genres column and make two genres out of it, rows that 
have only one genre will have other column as blank.
*/

DELIMITER // 
CREATE FUNCTION f_name (a VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN 
	SET @l = LOCATE(';', a);
    SET @s = IF(@l>0, LEFT(a, @l-1), a);
    RETURN @s;
END;
// DELIMITER ;

SELECT f_name ('Art & Design;Pretend Play')

DELIMITER // 
CREATE FUNCTION l_name (a VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN 
	SET @l = LOCATE(';', a);
    SET @s = IF(@l=0, '', SUBSTRING(a, @l+1, LENGTH(a)));
    RETURN @s;
END;
// DELIMITER ;

SELECT l_name ('Art & Design;Pretend Play');

SELECT Genres, f_name(Genres), l_name(Genres) FROM playstore;

/*
9. Your senior manager wants to know which apps are not performing 
as par in their particular category, however he is not interested in 
handling too many files or list for every  category and he/she assigned  
you with a task of creating a dynamic tool where he/she  can input a 
category of apps he/she  interested in  and your tool then provides 
real-time feedback by displaying apps within that category that have 
ratings lower than the average rating for that specific category. 
*/

DELIMITER //
CREATE PROCEDURE checking(in cat VARCHAR(30))
BEGIN 
	SET @c = 
		( SELECT Avg_Rating FROM
		( SELECT Category, ROUND(AVG(Rating), 2) as Avg_Rating
		  FROM playstore GROUP BY Category
		  )m WHERE Category = cat
		);
    SELECT * FROM playstore WHERE Category = Cat AND @c> Rating;
END // 
DELIMITER ;

Call checking('business');

DROP PROCEDURE checking;

-- 10.What is the diAerence between “Duration Time” and “Fetch Time.”
-- Ans: 
/*EXAMPLE
Duration Time: Imagine you type in your search query, such as "fiction books," and hit enter. The duration time is the period it takes for the system to process your 
request from the moment you hit enter until it comprehensively understands what you're asking for and how to execute it. This includes parsing your query, 
analyzing keywords, and preparing to fetch the relevant data.

Fetch Time: Once the system has fully understood your request, it begins fetching the results. Fetch time refers to the time it takes for the system to 
retrieve and present the search results back to you.

For instance, if your query is straightforward but requires fetching a large volume of data (like all fiction books in the library), the fetch time may be
 prolonged as the system sifts through extensive records to compile the results. Conversely, if your query is complex, involving multiple criteria or parameters,
 the duration time might be longer as the system processes the intricacies of your request before initiating the fetch process.*/