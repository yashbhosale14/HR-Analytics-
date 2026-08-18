CREATE TABLE hr_analytics (
    employeeid VARCHAR(20),
    gender VARCHAR(30),
    age INT,
    businesstravel VARCHAR(50),
    department VARCHAR(100),
    distancefromhomekm INT,
    education INT,
    educationfield VARCHAR(100),
    jobrole VARCHAR(100),
    salary NUMERIC(12,2),
    overtime VARCHAR(10),
    hiredate DATE,
    attrition VARCHAR(10),
    yearsatcompany INT,
    yearsinmostrecentrole INT,
    yearssincelastpromotion INT,
    yearswithcurrentmanager INT,
    reviewdate DATE,
    environmentsatisfaction INT,
    jobsatisfaction INT,
    relationshipsatisfaction INT,
    trainingopportunitieswithinyear INT,
    trainingopportunitiestaken INT,
    worklifebalance INT,
    selfrating INT,
    managerrating INT
);

SELECT COUNT(*) AS total_rows
FROM hr_analytics;

SELECT * FROM hr_analytics;


--1. How many employees are in each department?

SELECT department,
       COUNT(DISTINCT employeeid) AS employees
FROM hr_analytics
GROUP BY department
ORDER BY employees DESC;

--2. Which job roles have the most employees?

SELECT jobrole ,
     COUNT(DISTINCT employeeid) AS employees
FROM hr_analytics
GROUP BY jobrole
ORDER BY employees DESC;


--3. What is the overall employee attrition rate?
SELECT
    COUNT(DISTINCT employeeid) AS total_employees,

    COUNT(DISTINCT CASE
        WHEN attrition = 'Yes' THEN employeeid
    END) AS employees_left,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE
            WHEN attrition = 'Yes' THEN employeeid
        END)
        / COUNT(DISTINCT employeeid),
        2
    ) AS attrition_rate

FROM hr_analytics;

--4. Which department has the highest attrition?

WITH employees AS (
    SELECT DISTINCT employeeid, department, attrition
    FROM hr_analytics
)
SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employees
GROUP BY department
ORDER BY attrition_rate DESC;

--5.How many employees left from each department?
SELECT department,
       COUNT(DISTINCT employeeid) AS employees_left
FROM hr_analytics
WHERE attrition = 'Yes'
GROUP BY department
ORDER BY employees_left DESC;


--6.How many employees left based on overtime?
SELECT overtime,
       COUNT(DISTINCT employeeid) AS employees_left
FROM hr_analytics
WHERE attrition = 'Yes'
GROUP BY overtime;

--7.How many employees left based on job satisfaction?
SELECT jobsatisfaction,
       COUNT(DISTINCT employeeid) AS employees_left
FROM hr_analytics
WHERE attrition = 'Yes'
GROUP BY jobsatisfaction
ORDER BY jobsatisfaction;

--8.How many employees were hired each year?
SELECT EXTRACT(YEAR FROM hiredate) AS year,
       COUNT(DISTINCT employeeid) AS hires
FROM hr_analytics
GROUP BY year
ORDER BY year;

--9.Which department hired the most employees?
SELECT department,
       COUNT(DISTINCT employeeid) AS hires
FROM hr_analytics
GROUP BY department
ORDER BY hires DESC;

--10.Which department has the highest performance?
SELECT department,
       AVG(managerrating) AS avg_rating
FROM hr_analytics
GROUP BY department
ORDER BY avg_rating DESC;


--11.
SELECT AVG(managerrating) AS avg_rating
FROM hr_analytics;


--12.Does training relate to performance?
SELECT trainingopportunitiestaken,
       AVG(managerrating) AS avg_rating
FROM hr_analytics
GROUP BY trainingopportunitiestaken
ORDER BY trainingopportunitiestaken;

--13.Attrition by tenure
WITH employee_data AS (
    SELECT DISTINCT employeeid,
           yearsatcompany,
           attrition
    FROM hr_analytics
)
SELECT
    CASE
        WHEN yearsatcompany < 2 THEN '0-1 Years'
        WHEN yearsatcompany < 5 THEN '2-4 Years'
        ELSE '5+ Years'
    END AS tenure,
    COUNT(*) AS employees_left
FROM employee_data
WHERE attrition = 'Yes'
GROUP BY tenure;