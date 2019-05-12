-- name	         continent	        area	         population	           gdp
-- Afghanistan	   Asia	              652230	       25500100	             20343000000
-- Albania	       Europe	            28748	         2831741	             12960000000
-- Algeria	       Africa	            2381741	       37100000	             188681000000
-- Andorra	       Europe	            468	           78115	               3712000000
-- Angola	       Africa	            1246700	       20609294	             100990000000
-- ...

-- 1. List each country name where the population is larger than that of 'Russia'.

SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')

-- 2. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.

SELECT name FROM world WHERE continent = 'Europe' AND
gdp/population > (SELECT gdp/population FROM world WHERE name = 'United Kingdom')

-- 3. List the name and continent of countries in the continents
-- containing either Argentina or Australia. Order by name of the country.

SELECT name, continent FROM world WHERE continent IN
(SELECT continent FROM world WHERE name IN ('Argentina', 'Australia')) ORDER BY name;

-- 4. Which country has a population that is more than Canada but less than Poland? Show the name and the population.

SELECT name, population FROM world WHERE population > (SELECT population FROM world WHERE name = 'Canada')
AND population < (SELECT population FROM world WHERE name = 'Poland')

-- 5. Show the name and the population of each country in Europe.
-- Show the population as a percentage of the population of Germany.

SELECT name, CONCAT(ROUND(population/(SELECT population FROM world WHERE name = 'Germany')*100), '%')
FROM world WHERE continent = 'Europe';

-- 6. Which countries have a GDP greater than every country in Europe? [Give the name only.]
-- (Some countries may have NULL gdp values)

SELECT name FROM world WHERE gdp > ALL(SELECT gdp FROM world WHERE gdp > 0 AND continent = 'Europe');

-- 7. Find the largest country (by area) in each continent, show the continent, the name and the area:

SELECT continent, name, area FROM world x
  WHERE area >= ALL(SELECT area FROM world y WHERE x.continent = y.continent AND y.area>0);

-- 8.List each continent and the name of the country that comes first alphabetically.

SELECT continent, name FROM world x WHERE name <= ALL(SELECT name FROM world y WHERE x.continent = y.continent);

-- 9. Find the continents where all countries have a population <= 25000000.
-- Then find the names of the countries associated with these continents.
-- Show name, continent and population.

SELECT name, continent, population FROM world WHERE continent
IN (SELECT continent FROM world  x WHERE 25000000 >= (SELECT MAX(population)
FROM world y WHERE x.continent = y.continent));

-- 10. Some countries have populations more than three times that of any of
-- their neighbours (in the same continent). Give the countries and continents.

SELECT name, continent
FROM world x
WHERE population/3 > ALL(SELECT population FROM world y WHERE x.continent = y.continent AND x.name <> y.name)

-- quiz

-- Nested SELECT quiz
--
-- bbc
-- name	           region	             area	         population	               gdp
-- Afghanistan	     South Asia	         652225	       26000000
-- Albania	         Europe	             28728	       3200000	                 6656000000
-- Algeria	         Middle East	       2400000	     32900000	                 75012000000
-- Andorra	         Europe	             468	         64000
-- Bangladesh	     South Asia	         143998	       152600000	               67144000000
-- United Kingdom	 Europe	             242514	       59600000	                 2022824000000
-- ...
--

-- 1. Select the code that shows the name, region and population of the smallest country in each region

 SELECT region, name, population
 FROM bbc x
 WHERE population <= ALL
 (SELECT population FROM bbc y WHERE y.region=x.region AND population>0)

 -- 2. Select the code that shows the countries belonging to regions with all populations over 50000

 SELECT name,region,population
 FROM bbc x
 WHERE 50000 < ALL
 (SELECT population FROM bbc y WHERE x.region=y.region AND y.population>0)

 -- 3. Select the code that shows the countries with a less than a third of the population of the countries around it

 SELECT name, region
 FROM bbc x
 WHERE population < ALL
 (SELECT population/3 FROM bbc y WHERE y.region = x.region AND y.name != x.name)

 -- 4. Select the result that would be obtained from the following code:
 -- SELECT name FROM bbc
 -- WHERE population >
 --       (SELECT population
 --          FROM bbc
 --         WHERE name='United Kingdom')
 --   AND region IN
 --       (SELECT region
 --          FROM bbc
 --         WHERE name = 'United Kingdom')

Table-D
France
Germany
Russia
Turkey

-- 5. Select the code that would show the countries with a greater GDP than any country
-- in Africa (some countries may have NULL gdp values).

SELECT name FROM bbc
 WHERE gdp > (SELECT MAX(gdp) FROM bbc WHERE region = 'Africa')

 -- 6. Select the code that shows the countries with population smaller than Russia but bigger than Denmark

 SELECT name FROM bbc
 WHERE population < (SELECT population FROM bbc WHERE name='Russia')
   AND population > (SELECT population FROM bbc WHERE name='Denmark')

-- 7. Select the result that would be obtained from the following code:

-- SELECT name FROM bbc
--  WHERE population > ALL
--        (SELECT MAX(population)
--           FROM bbc
--          WHERE region = 'Europe')
--    AND region = 'South Asia'


Table-B
Bangladesh
India
Pakistan
