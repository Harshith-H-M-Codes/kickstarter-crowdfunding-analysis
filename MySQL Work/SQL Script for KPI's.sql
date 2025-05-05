USE Crowd_Funding;

-- Total Number of Projects
CREATE TABLE Total_Projects AS
SELECT CONCAT(ROUND(COUNT(id) / 1000), 'K') AS total_projects 
FROM Main_Table;

select * from Total_Projects;

-- Total Number of Projects based on outcome
CREATE TABLE Project_Outcome_Summary AS
SELECT state, 
       CASE 
           WHEN COUNT(id) < 10000 THEN COUNT(id)
           ELSE CONCAT(FLOOR(COUNT(id) / 1000), 'k') 
       END AS total_projects
FROM Main_Table
GROUP BY state;

select * from Project_Outcome_Summary;

-- Total Number of Projects based on Countries
CREATE TABLE Total_Projects_By_Country AS
SELECT cl.`country name` AS `country name`, COUNT(mt.id) AS total_projects
FROM Main_Table mt
JOIN Crowdfunding_Location cl ON mt.location_id = cl.id
GROUP BY cl.`country name`;

select * from Total_Projects_By_Country;

-- Total Number of Projects based on  Category
CREATE TABLE Total_Projects_By_Category AS
SELECT c.name AS category_name, COUNT(mt.id) AS total_projects
FROM Main_Table mt
JOIN Category c ON mt.category_id = c.id
GROUP BY c.name;

select * from Total_Projects_By_Category;

-- Total Number of Projects created by Year , Quarter , Month
CREATE TABLE Total_Projects_By_Date AS
SELECT 
    c.`Year` AS `Year`,
    c.`Quarter` AS `Quarter`,
    c.Monthfullname AS `Month`,
    COUNT(mt.id) AS total_projects
FROM Main_Table mt
JOIN Calendar_Table c ON mt.created_at = c.created_at
GROUP BY c.`Year`, c.`Quarter`, c.Monthfullname
ORDER BY `Year`, `Quarter`, `Month`;

select * from Total_Projects_By_Date;

-- Successful Projects
CREATE TABLE Total_Successful_Projects AS
SELECT CONCAT(ROUND(COUNT(id) / 1000,2), 'K') AS successful_projects
FROM Main_Table
WHERE state = 'successful';

select * from Total_Successful_Projects;
 
-- Amount Raised
CREATE TABLE Total_Amount_Raised AS
SELECT 
    CASE 
        WHEN SUM(usd_pledged) >= 1000000000 THEN CONCAT(ROUND(SUM(usd_pledged) / 1000000000, 2), 'B')
        WHEN SUM(usd_pledged) >= 1000000 THEN CONCAT(ROUND(SUM(usd_pledged) / 1000000, 2), 'M')
        WHEN SUM(usd_pledged) >= 1000 THEN CONCAT(ROUND(SUM(usd_pledged) / 1000, 2), 'K')
        ELSE CONCAT('$', SUM(usd_pledged))
    END AS total_amount_raised
FROM Main_Table;

select * from  Total_Amount_Raised;

-- Number of Backers
CREATE TABLE Total_Number_of_Backers AS
SELECT 
    CASE 
        WHEN SUM(backers_count) >= 1000000 THEN CONCAT(ROUND(SUM(backers_count) / 1000000, 2), 'M')
        WHEN SUM(backers_count) >= 1000 THEN CONCAT(ROUND(SUM(backers_count) / 1000, 2), 'K')
        ELSE SUM(backers_count)
    END AS total_number_of_backers
FROM Main_Table;

select * from Total_Number_of_Backers;

-- Avg Number of Days for successful projects
CREATE TABLE Avg_Number_of_Days_Successful_Projects AS
SELECT FLOOR(AVG(`no. of days`)) AS avg_number_of_days
FROM Main_Table
WHERE state = 'successful';

select * from Avg_Number_of_Days_Successful_Projects;

-- Top Successful Projects based on Number of Backers
CREATE TABLE Top_Successful_Projects_By_Backers AS
SELECT id, `name`, created_at, backers_count
FROM Main_Table
WHERE state = 'successful'
ORDER BY backers_count DESC
LIMIT 10;  

select * from Top_Successful_Projects_By_Backers;

-- Top Successful Projects based on Amount Raised
CREATE TABLE Top_Successful_Projects_By_Amount_Raised AS
SELECT id, name, created_at, usd_pledged
FROM Main_Table
WHERE state = 'successful'
ORDER BY usd_pledged DESC
LIMIT 10;  

select * from Top_Successful_Projects_By_Amount_Raised;

 -- Percentage of Successful Projects overall
CREATE TABLE Percentage_Successful_Projects AS
WITH ProjectCounts AS (
    SELECT  COUNT(*) AS total_projects,SUM(state = 'successful') AS successful_projects
    FROM Main_Table
)
SELECT CONCAT(FLOOR(successful_projects * 100.0 / total_projects),'%') AS percentage_successful_projects
FROM ProjectCounts;

select * from Percentage_Successful_Projects;

-- Percentage of Successful Projects by Category
CREATE TABLE Percentage_Successful_Projects_By_Category AS
WITH CategoryCounts AS (
    SELECT c.`name` AS category_name,COUNT(*) AS total_projects,SUM(mt.state = 'successful') AS successful_projects
    FROM Main_Table mt
    JOIN Category c ON mt.category_id = c.id
    GROUP BY c.name
)
SELECT category_name,CONCAT(FLOOR(successful_projects * 100.0 / total_projects), '%') AS percentage_successful_projects
FROM CategoryCounts;

select * from Percentage_Successful_Projects_By_Category;

-- Percentage of Successful Projects by Year , Quarter, Month
CREATE TABLE Percentage_Successful_Projects_By_Date AS
WITH ProjectCounts AS (
    SELECT c.Year,c.Quarter,c.Monthfullname,COUNT(*) AS total_projects,SUM(state = 'successful') AS successful_projects
    FROM Main_Table mt
    JOIN Calendar_Table c ON mt.created_at = c.created_at
    GROUP BY c.Year, c.Quarter, c.Monthfullname
)
SELECT `Year`,`Quarter`,Monthfullname,CONCAT(FLOOR(successful_projects * 100.0 / total_projects), '%') AS percentage_successful_projects
FROM ProjectCounts;

select * from Percentage_Successful_Projects_By_Date;

-- Percentage of Successful projects by Goal Range
CREATE TABLE Percentage_Successful_Projects_By_Goal_Range AS
WITH GoalRangeCounts AS (
    SELECT `Goal Range`,COUNT(*) AS total_projects,SUM(state = 'successful') AS successful_projects
    FROM Main_Table
    GROUP BY `Goal Range`
)
SELECT `Goal Range`,CONCAT(FLOOR(successful_projects * 100.0 / total_projects), '%') AS percentage_successful_projects
FROM GoalRangeCounts;

select * from Percentage_Successful_Projects_By_Goal_Range;	