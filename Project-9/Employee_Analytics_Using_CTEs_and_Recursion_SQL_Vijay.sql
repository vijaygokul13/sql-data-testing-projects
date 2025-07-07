
--UPDATE d
--SET manager_id = e.emp_id
--FROM departments d
--CROSS APPLY (
--    SELECT TOP 1 emp_id
--    FROM employees
--    WHERE department_id = d.department_id
--    ORDER BY hire_date ASC
--) e
--WHERE d.department_id IN (
--    SELECT DISTINCT department_id FROM employees WHERE department_id IS NOT NULL
--);


--UPDATE e
--SET manager_id = d.manager_id
--FROM employees e
--JOIN departments d ON e.department_id = d.department_id
--WHERE e.department_id IS NOT NULL
--  AND e.emp_id <> d.manager_id; -- Avoid assigning employee as their own manager


-----Common Table Expressions (CTEs) Based Exercises.


----- 1. Basic CTEs


-----Use a CTE to find employees whose performance score is above the average performance score across the company.


WITH avg_score_cte AS (
    SELECT AVG(performance_score) AS avg_score
    FROM employees
)
SELECT 
    e.emp_id,
    e.emp_name,
    e.performance_score,
    a.avg_score AS average_company_score
FROM 
    employees e
JOIN 
    avg_score_cte a
ON 
    e.performance_score > a.avg_score;


-----Filter Active Employees with Salary Above Average


with cte1 as
(
select 
avg(e1.salary) as average_salary
from employees e1
)
select 
e2.emp_id,
e2.emp_name,
e2.department_id,
e2.salary,
e2.performance_score
from employees e2
join cte1
on e2.salary > cte1.average_salary;


-----Find Employees with Birthdays in the Next 30 Days Using CTE


WITH upcoming_birthdays AS (
    SELECT
        emp_id,
        emp_name,
        date_of_birth,
        -- Construct birthday for the current year
        CAST(
            CAST(YEAR(GETDATE()) AS VARCHAR(4)) + '-' +
            RIGHT('0' + CAST(MONTH(date_of_birth) AS VARCHAR(2)), 2) + '-' +
            RIGHT('0' + CAST(DAY(date_of_birth) AS VARCHAR(2)), 2)
            AS DATE
        ) AS birthday_this_year
    FROM employees
),
final_birthdays AS (
    SELECT
        emp_id,
        emp_name,
        date_of_birth,
        -- If birthday already passed, move to next year
        CASE 
            WHEN birthday_this_year >= CAST(GETDATE() AS DATE) THEN birthday_this_year
            ELSE DATEADD(YEAR, 1, birthday_this_year)
        END AS next_birthday
    FROM upcoming_birthdays
)
SELECT
    emp_id,
    emp_name,
    date_of_birth,
    next_birthday,
    DATEDIFF(DAY, CAST(GETDATE() AS DATE), next_birthday) AS days_left
FROM final_birthdays
WHERE next_birthday BETWEEN CAST(GETDATE() AS DATE) AND DATEADD(DAY, 30, CAST(GETDATE() AS DATE))
ORDER BY days_left;


----- 2. CTEs with Aggregation & Joins


-----Count Employees per Location by Joining Employee and Location Tables Using a CTE


WITH employee_location AS (
    SELECT 
        l.location_name,
        e.emp_id
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
)
SELECT 
    location_name,
    COUNT(emp_id) AS employee_count
FROM employee_location
GROUP BY location_name
ORDER BY employee_count DESC;


-----Calculate Total Department-Wise Project Budget Using JOINs in CTE


WITH department_project_budget AS (
    SELECT 
        d.department_id,
        d.department_name,
        p.budget
    FROM projects p
    JOIN departments d ON p.department_id = d.department_id
)
SELECT 
    department_name,
    SUM(budget) AS total_budget
FROM department_project_budget
GROUP BY department_name
ORDER BY total_budget DESC;


-----Find Departments Having More Than 3 Employees Using CTE and HAVING


WITH dept_employee_count AS (
    SELECT 
        e.department_id,
        d.department_name,
        COUNT(*) AS employee_count
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE e.department_id IS NOT NULL
    GROUP BY e.department_id, d.department_name
)
SELECT 
    department_id,
    department_name,
    employee_count
FROM dept_employee_count
WHERE employee_count > 3;


----- Identify Employees Working on Multiple Projects Using CTE with GROUP BY


WITH project_counts AS (
    SELECT 
        emp_id,
        COUNT(DISTINCT project_id) AS project_count
    FROM employee_projects
    GROUP BY emp_id
)
SELECT 
    e.emp_id,
    e.emp_name,
    pc.project_count
FROM project_counts pc
JOIN employees e ON e.emp_id = pc.emp_id
WHERE pc.project_count > 1;


----- 3. Multiple CTEs


-----Use Two CTEs: One for Headcount, Another for Average Salary per Department


WITH dept_headcount AS (
    SELECT 
        department_id,
        COUNT(emp_id) AS headcount
    FROM employees
    GROUP BY department_id
),
dept_avg_salary AS (
    SELECT 
        department_id,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department_id
)
SELECT 
    d1.department_id,
    d1.headcount,
    d2.average_salary
FROM dept_headcount d1
JOIN dept_avg_salary d2 ON d1.department_id = d2.department_id;


-----Chain CTEs to List Underpaid Employees Based on Department Average


WITH dept_avg_salary AS (
    SELECT 
        department_id,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT 
    e.emp_id,
    e.emp_name,
    e.department_id,
    e.salary,
    d.avg_salary
FROM employees e
JOIN dept_avg_salary d ON e.department_id = d.department_id
WHERE e.salary < d.avg_salary
ORDER BY e.department_id, e.salary;


-----Use CTE to Compute Employee Age, Then Filter Employees by Age Group


WITH employee_age AS (
    SELECT
        emp_id,
        emp_name,
        date_of_birth,
        DATEDIFF(year, date_of_birth, GETDATE()) 
            - CASE 
                WHEN DATEADD(year, DATEDIFF(year, date_of_birth, GETDATE()), date_of_birth) > GETDATE() 
                THEN 1 ELSE 0 
              END AS age
    FROM employees
)

SELECT 
    emp_id,
    emp_name,
    date_of_birth,
    age
FROM employee_age
WHERE age BETWEEN 30 AND 40
ORDER BY age;


-----Assign performance grades (A/B/C) based on score ranges using nested CTEs


WITH base_cte AS (
    SELECT 
        emp_id,
        emp_name,
        department_id,
        salary,
        performance_score
    FROM employees
),
grade_cte AS (
    SELECT 
        emp_id,
        emp_name,
        department_id,
        salary,
        performance_score,
        CASE 
            WHEN performance_score >= 85 THEN 'A'
            WHEN performance_score >= 70 THEN 'B'
            ELSE 'C'
        END AS performance_grade
    FROM base_cte
)
SELECT * 
FROM grade_cte;


-----4. Recursive CTEs


-----Build employee-manager hierarchy using recursive CTE


WITH EmployeeHierarchy AS (
    -- Anchor: top-level managers (no manager_id)
    SELECT
        emp_id,
        emp_name,
        manager_id,
        CAST(emp_name AS VARCHAR(MAX)) AS hierarchy_path,
        1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member: get direct reports
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        CAST(eh.hierarchy_path + ' > ' + e.emp_name AS VARCHAR(MAX)) AS hierarchy_path,
        eh.level + 1 AS level
    FROM employees e
    INNER JOIN EmployeeHierarchy eh ON e.manager_id = eh.emp_id
)

SELECT *
FROM EmployeeHierarchy
ORDER BY hierarchy_path;


-----Calculate total team size reporting to each manager recursively


WITH RecursiveTeam AS (
    -- Anchor: Each employee starts as themselves
    SELECT
        emp_id AS root_manager_id,
        emp_id AS emp_id
    FROM employees

    UNION ALL

    -- Recursive: Find subordinates reporting to current emp_id
    SELECT
        rt.root_manager_id,
        e.emp_id
    FROM RecursiveTeam rt
    JOIN employees e ON e.manager_id = rt.emp_id
)
SELECT 
    rt.root_manager_id AS manager_id,
    m.emp_name AS manager_name,
    COUNT(*) - 1 AS team_size -- exclude manager themselves
FROM RecursiveTeam rt
JOIN employees m ON rt.root_manager_id = m.emp_id
GROUP BY rt.root_manager_id, m.emp_name
ORDER BY team_size DESC;


-----Flatten organizational tree with depth level for each employee using recursion


WITH OrgTree AS (
    -- Anchor: Top-level employees (no manager)
    SELECT 
        emp_id,
        emp_name,
        manager_id,
        1 AS depth
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: Employees reporting to someone
    SELECT 
        e.emp_id,
        e.emp_name,
        e.manager_id,
        ot.depth + 1 AS depth
    FROM employees e
    INNER JOIN OrgTree ot ON e.manager_id = ot.emp_id
)
SELECT 
    emp_id,
    emp_name,
    manager_id,
    depth
FROM OrgTree
ORDER BY depth, emp_name;


----- Version : 2


WITH OrgTree AS (
    -- Anchor: Top-level employees with valid department
    SELECT 
        e.emp_id,
        e.emp_name,
        e.manager_id,
        e.department_id,
        1 AS depth
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    WHERE e.manager_id IS NULL

    UNION ALL

    -- Recursive: Employees reporting to someone and with valid department
    SELECT 
        e.emp_id,
        e.emp_name,
        e.manager_id,
        e.department_id,
        ot.depth + 1 AS depth
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    INNER JOIN OrgTree ot ON e.manager_id = ot.emp_id
)
SELECT 
    emp_id,
    emp_name,
    manager_id,
    department_id,
    depth
FROM OrgTree
ORDER BY depth, emp_name;


-----Advanced Use Cases with CTEs


-----Top 3 Highest Paid Employees per Department


WITH RankedSalaries AS (
    SELECT 
        e.emp_id,
        e.emp_name,
        e.salary,
        e.department_id,
        d.department_name,
        ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rn
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
)
SELECT 
    emp_id,
    emp_name,
    salary,
    department_id,
    department_name,
    rn AS rank_in_dept
FROM RankedSalaries
WHERE rn <= 3
ORDER BY department_id, rn;


-----Find employees assigned to more than 2 projects using CTE + COUNT


WITH ProjectCount AS (
    SELECT 
        emp_id,
        COUNT(DISTINCT project_id) AS total_projects
    FROM employee_projects
    GROUP BY emp_id
)
SELECT 
    e.emp_id,
    e.emp_name,
    pc.total_projects
FROM ProjectCount pc
JOIN employees e ON e.emp_id = pc.emp_id
WHERE pc.total_projects > 2
ORDER BY pc.total_projects DESC;


-----Fetch latest project assignment date for each employee using CTE + RANK


WITH RankedProjects AS (
    SELECT 
        ep.emp_id,
        ep.project_id,
        ep.assignment_date,
        RANK() OVER (PARTITION BY ep.emp_id ORDER BY ep.assignment_date DESC) AS rnk
    FROM employee_projects ep
)
SELECT 
    rp.emp_id,
    e.emp_name,
    rp.project_id,
    rp.assignment_date AS latest_assigned_date
FROM RankedProjects rp
JOIN employees e ON e.emp_id = rp.emp_id
WHERE rp.rnk = 1
ORDER BY rp.emp_id;


-----Rank employees based on performance score within their department using CTE + DENSE_RANK


WITH RankedEmployees AS (
    SELECT 
        e.emp_id,
        e.emp_name,
        e.department_id,
        d.department_name,
        e.performance_score,
        DENSE_RANK() OVER (
            PARTITION BY e.department_id 
            ORDER BY e.performance_score DESC
        ) AS performance_rank
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE e.department_id IS NOT NULL
)
SELECT 
    emp_id,
    emp_name,
    department_id,
    department_name,
    performance_score,
    performance_rank
FROM RankedEmployees
ORDER BY department_id, performance_rank;


-----Detect performance outliers using CTE + statistical functions like STDDEV


WITH DeptStats AS (
    SELECT 
        department_id,
        AVG(performance_score * 1.0) AS avg_score,
        STDEV(performance_score * 1.0) AS stddev_score
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
),
WithScores AS (
    SELECT 
        e.emp_id,
        e.emp_name,
        e.department_id,
        e.performance_score,
        ds.avg_score,
        ds.stddev_score,
        ABS(e.performance_score - ds.avg_score) AS deviation
    FROM employees e
    JOIN DeptStats ds ON e.department_id = ds.department_id
)
SELECT 
    emp_id,
    emp_name,
    department_id,
    performance_score,
    avg_score,
    stddev_score,
    deviation,
    CASE 
        WHEN deviation > stddev_score THEN 'Outlier'
        ELSE 'Normal'
    END AS performance_flag
FROM WithScores
ORDER BY department_id, deviation DESC;


-----
