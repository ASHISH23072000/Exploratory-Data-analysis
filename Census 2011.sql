SELECT 
    *
FROM
    dataset2;


/* Q1 Total population of india*/
SELECT 
    SUM(population)
FROM
    dataset2;

/*  Q2 data only for uttar pradesh and maharastra*/
SELECT 
    *
FROM
    dataset1
WHERE
    state IN ('uttar pradesh' , 'maharastra');

/* Q3 avg growth  of india*/
SELECT 
    AVG(growth) AS average_growth
FROM
    dataset1;

/*  Q4 average growth by state?*/
SELECT 
    AVG(growth) AS average_growth, state
FROM
    dataset1
GROUP BY state;


/* Q5 A) avg sex ratio of india
      B) avg sex ratio by  state in descending order*/

SELECT 
    AVG(sex_ratio) AS average_SR
FROM
    dataset1;
SELECT 
    ROUND(AVG(sex_ratio)) AS average_SR, state
FROM
    dataset1
GROUP BY state
ORDER BY average_sr DESC;

/* Q6 A)average literacy rate  of  india?
      B)average literacy rate  by state?*/

SELECT 
    ROUND(AVG(Literacy)) AS avg_literacy
FROM
    dataset1;

/* Q7 state where avg literacy rate is greater than 90*/

SELECT 
    ROUND(AVG(literacy)) AS avg_literacy, state
FROM
    dataset1
GROUP BY state
HAVING avg_literacy > 90;

/* Q8 top 3 states with highest growth percentage*/

SELECT 
    state, AVG(growth)
FROM
    dataset1
GROUP BY state
ORDER BY AVG(growth) DESC;

/* Q9 top 3 states with lowest growth percentage*/
SELECT 
    AVG(growth) AS avg_growth, state
FROM
    dataset1
GROUP BY state
ORDER BY avg_growth ASC
LIMIT 3;

/* Q10 top 3 states with highest sex ratio*/
SELECT 
    AVG(sex_ratio), state
FROM
    dataset1
GROUP BY state
ORDER BY AVG(sex_ratio) DESC
LIMIT 3;
 
 /* Q11 top 3 and bottom 3 states in literacy rate?*/
 
CREATE TABLE IF NOT EXISTS literacy_rate (
    state VARCHAR(255) NOT NULL,
    top_states FLOAT NOT NULL
);
  insert into literacy_rate (state, top_states)
  select state, round(avg(literacy)) as avg_literacy  from dataset1
  group by state 
  order by avg_literacy;
  
SELECT 
    *
FROM
    literacy_rate
ORDER BY top_states DESC
LIMIT 4;
   
CREATE TABLE literacy (
    state VARCHAR(255) NOT NULL,
    bottom_states FLOAT NOT NULL
);
    
     insert into literacy
     select state , round(avg(literacy)) as avg_literacy  from dataset1
     group by state
     order by avg_literacy asc;
     	
     
(SELECT 
    *
FROM
    literacy_rate
ORDER BY top_states DESC
LIMIT 3) UNION ALL (SELECT 
    *
FROM
    literacy
ORDER BY bottom_states ASC
LIMIT 3);
 
 /* Q12 all data of states starting with a*/
 
SELECT 
    *
FROM
    dataset1
WHERE
    state LIKE ('a%') OR state LIKE ('A%');

/* Q13 total no. of males and females in states?*/
SELECT 
    d.state,
    SUM(d.males) AS total_males,
    SUM(d.females) AS total_females
FROM
    (SELECT 
        c.district,
            c.state,
            ROUND(c.population / (c.sex_ratio + 1), 0) AS males,
            ROUND((c.population * c.sex_ratio) / (c.sex_ratio + 1), 0) AS females
    FROM
        (SELECT 
        a.district,
            a.state,
            (a.sex_ratio) / 1000 sex_ratio,
            b.population
    FROM
        dataset1 AS a
    INNER JOIN dataset2 AS b ON a.district = b.district) AS c) AS d
GROUP BY d.state;


/*Q14  total literacy rate*/
SELECT 
    d.state, SUM(literate_people), SUM(illiterate_people)
FROM
    (SELECT 
        c.district,
            c.state,
            ROUND(c.literacy_ratio * c.population, 0) AS literate_people,
            ROUND((1 - literacy_ratio) * c.population, 0) AS illiterate_people
    FROM
        (SELECT 
        a.district,
            a.state,
            a.literacy / 100 AS literacy_ratio,
            b.population
    FROM
        dataset1 AS a
    INNER JOIN dataset2 AS b ON a.district = b.district) AS c) AS d
GROUP BY d.state;

/* Q15 population in previous census*/

SELECT 
    SUM(m.previous_census_population),
    SUM(m.current_census_population)
FROM
    (SELECT 
        e.state,
            SUM(e.previous_census_population) previous_census_population,
            SUM(e.current_census_population) current_census_population
    FROM
        (SELECT 
        d.district,
            d.state,
            ROUND(population / (1 + growth), 0) AS previous_census_population,
            ROUND(population, 0) AS current_census_population
    FROM
        (SELECT 
        a.district, a.state, a.growth / 100 AS growth, b.population
    FROM
        dataset1 AS a
    INNER JOIN dataset2 AS b ON a.district = b.district) AS d) AS e
    GROUP BY e.state) m
ORDER BY SUM(m.current_census_population);









