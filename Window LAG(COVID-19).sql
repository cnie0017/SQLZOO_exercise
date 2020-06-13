2.The LAG function is used to show data from the preceding row or the table. When lining up rows the data is partitioned by country name and ordered by the data whn. That means that only data from Italy is considered.
Modify the query to show confirmed for the day before.

SELECT name, DAY(whn), confirmed,
       LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) as dbf
FROM covid
WHERE name = 'Italy'
AND MONTH(whn) = 3
ORDER BY whn


3. The number of confirmed case is cumulative - but we can use LAG to recover the number of new cases reported for each day.
Show the number of new cases for each day, for Italy, for March.

SELECT name, DAY(whn), 
       confirmed-LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) as 'new cases'
FROM covid
WHERE name = 'Italy'
AND MONTH(whn) = 3
ORDER BY whn


4. The data gathered are necessarily estimates and are inaccurate. However by taking a longer time span we can mitigate some of the effects.
You can filter the data to view only Monday's figures WHERE WEEKDAY(whn) = 0.
Show the number of new cases in Italy for each week - show Monday only.

SELECT name, DATE_FORMAT(whn,'%Y-%m-%d') as date, 
       confirmed -  LAG(confirmed,1) OVER (PARTITION BY name ORDER by whn) as 'new cases'
FROM covid
WHERE name = 'Italy'
AND WEEKDAY(whn) = 0
ORDER BY whn


5.You can JOIN a table using DATE arithmetic. This will give different results if data is missing.
Show the number of new cases in Italy for each week - show Monday only.
In the sample query we JOIN this week tw with last week lw using the DATE_ADD function.

SELECT tw.name, DATE_FORMAT(tw.whn,'%Y-%m-%d'), 
       tw.confirmed-LAG(tw.confirmed,1) OVER (PARTITION BY tw.name ORDER by tw.whn) as 'new cases'
FROM covid tw LEFT JOIN covid lw
     ON DATE_ADD(lw.whn, INTERVAL 1 WEEK) = tw.whn
     AND tw.name=lw.name
WHERE tw.name = 'Italy'
AND WEEKDAY(tw.whn) = 0
ORDER BY tw.whn


6.The query shown shows the number of confirmed cases together with the world ranking for cases.
United States has the highest number, Spain is number 2...
Notice that while Spain has the second highest confirmed cases, Italy has the second highest number of deaths due to the virus.
Include the ranking for the number of deaths in the table.
******NOTE***********The problem asks us to only consider countries with population of at least 10 million, but the correct answer cannot be obtained by specifying this.

SELECT 
   covid.name,
   confirmed,
   RANK() OVER (ORDER BY confirmed DESC) rc,
   deaths,
   RANK() OVER (ORDER BY deaths DESC) rd
FROM covid JOIN world ON covid.name = world.name
WHERE whn = '2020-04-20'
ORDER BY confirmed DESC


7.The query shown includes a JOIN t the world table so we can access the total population of each country and calculate infection rates (in cases per 100,000).
Show the infect rate ranking for each country. Only include countries with a population of at least 10 million.

SELECT world.name,
   ROUND(100000*confirmed/population,0) as rate,
   RANK() OVER (ORDER BY confirmed/population) rank
FROM covid JOIN world ON covid.name=world.name
WHERE whn = '2020-04-20' AND population >= 10000000
ORDER BY population DESC


8.For each country that has had at lEast(typo lol) 1000 new cases in a single day, show the date of the peak number of new cases.
********NOTE********This will give you all the rows shown in the correct answer, but the answer's order is strange since on 2020-4-10, Portugal with 1516 is put before Ireland 1515, with US in-between. 


SELECT b.name, b.date, b.new
FROM (SELECT t2.name, t2.date,MAX(t2.new) as new
FROM (SELECT t.name, t.date, t.new FROM (SELECT y.name, DATE_FORMAT(y.whn,'%Y-%m-%d') as date, confirmed -  LAG(y.confirmed,1) OVER (PARTITION BY y.name ORDER by y.whn) as new
FROM covid y) as t
WHERE t.new >= 1000)as t2
GROUP BY t2.name) as a
JOIN 
(SELECT t.name, t.date, t.new FROM (SELECT y.name, DATE_FORMAT(y.whn,'%Y-%m-%d') as date, confirmed -  LAG(y.confirmed,1) OVER (PARTITION BY y.name ORDER by y.whn) as new
FROM covid y) as t
WHERE t.new >= 1000) as b
ON a.name = b.name AND a.new = b.new
ORDER BY b.date, b.new, b.name
