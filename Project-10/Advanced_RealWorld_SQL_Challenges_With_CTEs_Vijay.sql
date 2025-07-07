-----Advanced SQL Real-World Challenges Series

-----Challenge 6.1 : Under-Utilized Employees Analysis step by step.
--Find employees who are assigned to fewer projects than the average number 
--of projects assigned to employees in their department.


WITH EmpProjectCount AS (
    SELECT 
        e.emp_id,
        e.emp_name,
        e.department_id,
        COUNT(ep.project_id) AS project_count
    FROM employees e
    LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
    WHERE e.department_id IS NOT NULL
    GROUP BY e.emp_id, e.emp_name, e.department_id
),
DeptAvgProjectCount AS (
    SELECT 
        department_id,
        AVG(project_count * 1.0) AS avg_project_count
    FROM EmpProjectCount
    GROUP BY department_id
)
SELECT 
    epc.emp_id,
    epc.emp_name,
    d.department_name,
    epc.project_count,
    dapc.avg_project_count
FROM EmpProjectCount epc
JOIN DeptAvgProjectCount dapc 
    ON epc.department_id = dapc.department_id
JOIN departments d 
    ON epc.department_id = d.department_id
WHERE epc.project_count < dapc.avg_project_count
ORDER BY d.department_name, epc.project_count;


-----Challenge 6.2 : Department-Level Salary Insights
--Show each department's total salary, average performance score, and the highest-paid employee.


WITH RankedSalaries AS (
    SELECT 
        e.emp_id,
        e.emp_name,
        e.salary,
        e.department_id,
        d.department_name,
        ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rn
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE e.department_id IS NOT NULL
),
DeptAggregates AS (
    SELECT 
        e.department_id,
        SUM(e.salary) AS total_salary,
        AVG(e.performance_score * 1.0) AS avg_performance_score
    FROM employees e
    WHERE e.department_id IS NOT NULL
    GROUP BY e.department_id
),
TopEarners AS (
    SELECT 
        department_id,
        emp_name AS highest_paid_employee,
        salary AS highest_salary
    FROM RankedSalaries
    WHERE rn = 1
)
SELECT 
    d.department_name,
    da.total_salary,
    format(da.avg_performance_score, 'N2') AS avg_performance_score,
    te.highest_paid_employee,
    te.highest_salary
FROM DeptAggregates da
JOIN departments d ON da.department_id = d.department_id
LEFT JOIN TopEarners te ON da.department_id = te.department_id
ORDER BY da.total_salary DESC;


-----Challenge 6.3 : Project Load vs. Performance Matrix.
---Identify employees who:
---Are working on more projects than the average
---Have a performance score below average
---These are potentially overloaded underperformers.


WITH ProjectCounts AS (
    SELECT 
        ep.emp_id,
        COUNT(DISTINCT ep.project_id) AS project_count
    FROM employee_projects ep
    GROUP BY ep.emp_id
),
Averages AS (
    SELECT 
        AVG(pc.project_count * 1.0) AS avg_project_count,
        AVG(e.performance_score * 1.0) AS avg_performance_score
    FROM ProjectCounts pc
    JOIN employees e ON pc.emp_id = e.emp_id
),
Combined AS (
    SELECT 
        e.emp_id,
        e.emp_name,
        e.performance_score,
        pc.project_count,
        a.avg_project_count,
        a.avg_performance_score
    FROM employees e
    JOIN ProjectCounts pc ON e.emp_id = pc.emp_id
    CROSS JOIN Averages a
)
SELECT 
    emp_id,
    emp_name,
    project_count,
    performance_score,
    format(avg_project_count, 'N2') AS avg_project_count,
    format(avg_performance_score, 'N2') AS avg_performance_score
FROM Combined
WHERE project_count > avg_project_count
  AND performance_score < avg_performance_score
ORDER BY project_count DESC, performance_score ASC;


-----Challenge 6.4 : Managerial Effectiveness Score
--For each manager in the organization, calculate:
--Team Size → Count of direct reports
--Average Performance Score → Of their direct reports
--This will help assess each manager's effectiveness through their team size and average team performance.


WITH DirectReports AS (
    SELECT 
        manager_id,
        COUNT(*) AS team_size,
        AVG(performance_score * 1.0) AS avg_team_performance
    FROM employees
    WHERE manager_id IS NOT NULL
    GROUP BY manager_id
)
SELECT 
    m.emp_id AS manager_id,
    m.emp_name AS manager_name,
    dr.team_size,
    format(dr.avg_team_performance, 'N2') AS avg_team_performance,
	CASE 
    WHEN dr.avg_team_performance >= 90 THEN 'Excellent'
    WHEN dr.avg_team_performance >= 80 THEN 'Good'
    ELSE 'Needs Improvement'
	END AS effectiveness_grade
FROM DirectReports dr
JOIN employees m ON dr.manager_id = m.emp_id
ORDER BY dr.avg_team_performance DESC;


-----Challenge 6.5 : Performance Outliers by Department
--Identify employees whose performance score is significantly different from others in their department — specifically, 
--those beyond ±2 standard deviations from the department average.


DECLARE @ThresholdMultiplier FLOAT = 1.5;  -- Change this value to adjust sensitivity

WITH DeptStats AS (
    SELECT 
        department_id,
        AVG(performance_score) AS avg_score,
        STDEV(performance_score) AS std_dev
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
),
EmployeeStats AS (
    SELECT 
        e.emp_id,
        e.emp_name,
        e.department_id,
        e.performance_score,
        ds.avg_score,
        ds.std_dev,
        ABS(e.performance_score - ds.avg_score) AS deviation
    FROM employees e
    INNER JOIN DeptStats ds ON e.department_id = ds.department_id
)
SELECT 
    emp_id,
    emp_name,
    department_id,
    performance_score,
    avg_score,
    format(std_dev, 'N2') as std_dev,
    deviation
FROM EmployeeStats
WHERE deviation > (@ThresholdMultiplier * std_dev)
ORDER BY department_id, deviation DESC;


-----Challenge 6.6 – Continuous Project Involvement Gaps, we need to:
--Find employees who haven’t worked on any project in the last 6 months from today.


DECLARE @SixMonthsAgo DATE = DATEADD(MONTH, -6, GETDATE());

WITH LastAssignment AS (
    SELECT 
        emp_id,
        MAX(assignment_date) AS last_project_date
    FROM employee_projects
    GROUP BY emp_id
)
SELECT 
    e.emp_id,
    e.emp_name,
    d.department_name,
    la.last_project_date
FROM employees e
LEFT JOIN LastAssignment la ON e.emp_id = la.emp_id
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE la.last_project_date IS NULL 
   OR la.last_project_date < @SixMonthsAgo
ORDER BY la.last_project_date;


----- Challenge 6.7 – Deepest Reporting Chain
--Goal: For each employee, determine:
--Their top-level manager (i.e., the highest person in the reporting chain)
--The number of levels it takes to reach that top-level manager


--version : 1


WITH RecursiveHierarchy AS (
    SELECT 
        emp_id,
        emp_name,
        manager_id,
        emp_id AS root_emp_id,
        emp_name AS original_emp_name,
        manager_id AS current_manager_id,
        0 AS level,
        CAST(emp_name AS VARCHAR(MAX)) AS chain
    FROM employees

    UNION ALL

    SELECT 
        eh.emp_id,
        eh.emp_name,
        eh.manager_id,
        rh.root_emp_id,
        rh.original_emp_name,
        eh.manager_id AS current_manager_id,
        rh.level + 1,
        CAST(rh.chain + ' -> ' + eh.emp_name AS VARCHAR(MAX))
    FROM RecursiveHierarchy rh
    JOIN employees eh ON rh.current_manager_id = eh.emp_id
)
SELECT 
    root_emp_id AS emp_id,
    e.emp_name,
    MAX(rh.level) AS levels_to_top,
    rh.emp_name AS top_level_manager
FROM RecursiveHierarchy rh
JOIN employees e ON rh.root_emp_id = e.emp_id
GROUP BY root_emp_id, e.emp_name, rh.emp_name
HAVING MAX(rh.level) = (
    SELECT MAX(level)
    FROM RecursiveHierarchy rh2
    WHERE rh2.root_emp_id = rh.root_emp_id
)
ORDER BY levels_to_top DESC;


--version:2


WITH ReportingChain AS (
    SELECT 
        emp_id,
        emp_name,
        manager_id,
        0 AS level,
        emp_id AS root_emp_id
    FROM employees

    UNION ALL

    SELECT 
        e.emp_id,
        e.emp_name,
        e.manager_id,
        rc.level + 1,
        rc.root_emp_id
    FROM employees e
    JOIN ReportingChain rc ON e.emp_id = rc.manager_id
)
SELECT 
    e.emp_id AS employee_id,
    e.emp_name AS employee_name,
    MAX(rc.level) AS levels_to_top,
    TOPM.emp_name AS top_level_manager
FROM ReportingChain rc
	JOIN employees e ON rc.root_emp_id = e.emp_id
	JOIN employees TOPM ON rc.emp_id = TOPM.emp_id
WHERE rc.level = (
				SELECT MAX(level)
				FROM ReportingChain rc2
				WHERE rc2.root_emp_id = rc.root_emp_id )
GROUP BY e.emp_id, e.emp_name, TOPM.emp_name
ORDER BY levels_to_top DESC;


-----Challenge 6.8 – Salary Growth Opportunity Analysis
--Identify employees who:
--Earn below their department’s average salary, and
--Have a performance score above their department’s average score


WITH dept_avg AS (
    SELECT 
        department_id,
        AVG(salary) AS avg_salary,
        AVG(performance_score) AS avg_performance
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT 
    e.emp_id,
    e.emp_name,
    e.department_id,
    d.department_name,
    e.salary,
    da.avg_salary,
    e.performance_score,
    da.avg_performance
FROM employees e
JOIN dept_avg da 
    ON e.department_id = da.department_id
JOIN departments d 
    ON e.department_id = d.department_id
WHERE 
    e.salary < da.avg_salary
    AND e.performance_score > da.avg_performance
ORDER BY e.department_id, e.emp_name;


-----Challenge 6.9 – Department Saturation Report
--Identify departments where more than 70% of employees are assigned to at least 2 projects.


WITH project_counts AS (
    SELECT 
        ep.emp_id,
        COUNT(DISTINCT ep.project_id) AS project_count
    FROM employee_projects ep
    GROUP BY ep.emp_id
),
employee_with_projects AS (
    SELECT 
        e.emp_id,
        e.department_id,
        pc.project_count
    FROM employees e
    JOIN project_counts pc ON e.emp_id = pc.emp_id
    WHERE e.department_id IS NOT NULL
),
department_stats AS (
    SELECT 
        department_id,
        COUNT(DISTINCT emp_id) AS total_employees,
        COUNT(DISTINCT CASE WHEN project_count >= 2 THEN emp_id END) AS multi_project_employees
    FROM employee_with_projects
    GROUP BY department_id
)
SELECT 
    d.department_id,
    d.department_name,
    ds.total_employees,
    ds.multi_project_employees,
    CAST(ds.multi_project_employees AS FLOAT) / ds.total_employees * 100 AS percentage_multi_project
FROM department_stats ds
JOIN departments d ON d.department_id = ds.department_id
WHERE 
    CAST(ds.multi_project_employees AS FLOAT) / ds.total_employees > 0.7
ORDER BY percentage_multi_project DESC;


-----Challenge 6.10 – Employee Leaderboard (Composite KPI)
--Rank employees based on a composite KPI score calculated using:
--Salary
--Performance Score
--Number of Projects


WITH project_counts AS (
    SELECT 
        ep.emp_id,
        COUNT(DISTINCT ep.project_id) AS project_count
    FROM employee_projects ep
    GROUP BY ep.emp_id
),
employee_data AS (
    SELECT 
        e.emp_id,
        e.emp_name,
        e.salary,
        e.performance_score,
        ISNULL(pc.project_count, 0) AS project_count
    FROM employees e
    LEFT JOIN project_counts pc ON e.emp_id = pc.emp_id
),
stats AS (
    SELECT 
        MIN(salary) AS min_salary,
        MAX(salary) AS max_salary,
        MIN(performance_score) AS min_perf,
        MAX(performance_score) AS max_perf,
        MIN(project_count) AS min_proj,
        MAX(project_count) AS max_proj
    FROM employee_data
),
normalized_data AS (
    SELECT 
        ed.emp_id,
        ed.emp_name,
        ed.salary,
        ed.performance_score,
        ed.project_count,
        CAST(ed.salary - s.min_salary AS FLOAT) / NULLIF(s.max_salary - s.min_salary, 0) AS norm_salary,
        CAST(ed.performance_score - s.min_perf AS FLOAT) / NULLIF(s.max_perf - s.min_perf, 0) AS norm_perf,
        CAST(ed.project_count - s.min_proj AS FLOAT) / NULLIF(s.max_proj - s.min_proj, 0) AS norm_proj
    FROM employee_data ed
    CROSS JOIN stats s
),
composite_score AS (
    SELECT 
        emp_id,
        emp_name,
        salary,
        performance_score,
        project_count,
        norm_salary,
        norm_perf,
        norm_proj,
        format((0.4 * norm_salary + 0.4 * norm_perf + 0.2 * norm_proj), 'N4') AS final_score
    FROM normalized_data
)
SELECT 
    emp_id,
    emp_name,
    salary,
    performance_score,
    project_count,
    final_score,
    RANK() OVER (ORDER BY final_score DESC) AS rank
FROM composite_score
ORDER BY rank;


-----Challenge 6.11 – Longest Reporting Chain (Deepest Org Level) step by step.
--Find the employee who is farthest from the top-level manager 
--(i.e. with the longest reporting chain — the most levels to reach the top).


-- Step 1: Build recursive reporting chain for each employee
WITH ReportingChain AS (
    -- Anchor member: every employee starts at level 0
    SELECT 
        emp_id,
        emp_name,
        manager_id,
        0 AS level
    FROM employees

    UNION ALL

    -- Recursive member: climb up the manager hierarchy
    SELECT 
        e.emp_id,
        e.emp_name,
        e.manager_id,
        rc.level + 1
    FROM employees e
    JOIN ReportingChain rc ON e.emp_id = rc.manager_id
)

-- Step 2: Get the employee with the maximum level
SELECT TOP 1
    emp_id,
    emp_name,
    level AS levels_to_top
FROM ReportingChain
ORDER BY level DESC;


-----Challenge 6.12 – Employees Missing Performance Reviews
--List employees who don’t have any performance score recorded in the current year.

--v.1

SELECT emp_id, emp_name, performance_score, performance_review_date
FROM employees
WHERE YEAR(performance_review_date) < YEAR(GETDATE())
   OR performance_review_date IS NULL;

--v.2

SELECT e.emp_id, e.emp_name
FROM employees e
LEFT JOIN (
    SELECT emp_id
    FROM employee_performance
    WHERE YEAR(review_date) = YEAR(GETDATE())
    GROUP BY emp_id
) p ON e.emp_id = p.emp_id
WHERE p.emp_id IS NULL;


-----Challenge 6.13 – Multi-Department Exposure via Projects
-- Find employees who are working on projects across multiple departments.


SELECT 
    ep.emp_id,
    e.emp_name,
    COUNT(DISTINCT p.department_id) AS department_count
FROM employee_projects ep
JOIN employees e ON ep.emp_id = e.emp_id
JOIN projects p ON ep.project_id = p.project_id
GROUP BY ep.emp_id, e.emp_name
HAVING COUNT(DISTINCT p.department_id) > 1
ORDER BY department_count DESC;


-----Challenge 6.14 – Latest Joiners in Each Department
--List the most recently joined employee(s) in each department.


WITH RankedJoiners AS (
    SELECT 
        emp_id,
        emp_name,
        department_id,
        hire_date,
        RANK() OVER (PARTITION BY department_id ORDER BY hire_date DESC) AS rnk
    FROM employees
    WHERE department_id IS NOT NULL
)
SELECT 
    emp_id,
    emp_name,
    department_id,
    hire_date
FROM RankedJoiners
WHERE rnk = 1
ORDER BY department_id;


-----Challenge 6.15 – Find Ghost Employees
--Detect employees who are not assigned to any valid department and not on any project.


WITH ValidDepartments AS 
(
    SELECT department_id FROM departments
),
EmployeesWithoutValidDept AS 
(
    SELECT e.emp_id
    FROM employees e
    LEFT JOIN ValidDepartments vd ON e.department_id = vd.department_id
    WHERE vd.department_id IS NULL
),
EmployeesWithProjects AS 
(
    SELECT DISTINCT emp_id
    FROM employee_projects
)
SELECT 
e.emp_id, 
e.emp_name
FROM employees e
	LEFT JOIN EmployeesWithoutValidDept ewvd 
ON e.emp_id = ewvd.emp_id
	LEFT JOIN EmployeesWithProjects ewp 
ON e.emp_id = ewp.emp_id
WHERE ewvd.emp_id IS NOT NULL
	AND ewp.emp_id IS NULL
ORDER BY e.emp_id;


-----Challenge 6.16 – Monthly Hiring Trend with Running Total
--Show number of employees hired per month, and cumulative hires over time.

WITH MonthlyHires AS (
    SELECT
        FORMAT(hire_date, 'yyyy-MM') AS hire_month,
        COUNT(*) AS hires_in_month
    FROM employees
    GROUP BY FORMAT(hire_date, 'yyyy-MM')
)
SELECT
    hire_month,
    hires_in_month,
    SUM(hires_in_month) OVER (ORDER BY hire_month 
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_hires
FROM MonthlyHires
ORDER BY hire_month;


-----Challenge 6.17 – Identify Stagnant Employees
--Find employees whose salary has never changed (assume you track salary history).


SELECT 
    e.emp_id,
    e.emp_name,
    MAX(h.salary) AS current_salary
FROM 
    employee_salary_history h
JOIN 
    employees e ON e.emp_id = h.emp_id
GROUP BY 
    e.emp_id, e.emp_name
HAVING 
    COUNT(DISTINCT h.salary) = 1
ORDER BY e.emp_id;


-----Challenge 6.18 – Project Allocation Imbalance
--Compare the project-to-employee ratio across departments and highlight departments that are under or over-utilized.


WITH dept_project_count AS (
    SELECT 
        department_id,
        COUNT(DISTINCT project_id) AS total_projects
    FROM projects
    GROUP BY department_id
),
dept_employee_count AS (
    SELECT 
        department_id,
        COUNT(DISTINCT emp_id) AS total_employees
    FROM employees
    GROUP BY department_id
),
project_allocation_ratio AS (
    SELECT 
        d.department_id,
        d.total_projects,
        e.total_employees,
        CAST(d.total_projects AS FLOAT) / NULLIF(e.total_employees, 0) AS project_to_employee_ratio
    FROM dept_project_count d
    JOIN dept_employee_count e ON d.department_id = e.department_id
)
SELECT 
    p.department_id,
    dept.department_name,
    p.total_projects,
    p.total_employees,
    ROUND(p.project_to_employee_ratio, 2) AS ratio,
    CASE 
        WHEN p.project_to_employee_ratio > 1.5 THEN 'Over-utilized'
        WHEN p.project_to_employee_ratio < 0.5 THEN 'Under-utilized'
        ELSE 'Balanced'
    END AS status
FROM 
    project_allocation_ratio p
JOIN 
    departments dept ON p.department_id = dept.department_id
ORDER BY 
    ratio DESC;


-----Challenge 6.19 – Top 5 Highest Performing Teams
--Rank all departments based on the average performance score of their members and return top 5.


WITH DepartmentPerformance AS (
    SELECT 
        d.department_id,
        d.department_name,
        AVG(e.performance_score * 1.0) AS avg_performance
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    GROUP BY d.department_id, d.department_name
),
RankedDepartments AS (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY avg_performance DESC) AS perf_rank
    FROM DepartmentPerformance
)
SELECT department_id, department_name, avg_performance, perf_rank
FROM RankedDepartments
WHERE perf_rank <= 5
ORDER BY perf_rank;


-----Challenge 6.20 – Manager Salary Justification Check
--Find managers earning less than the average salary of their direct reports.


WITH DirectReportAvgSalary AS (
    SELECT 
        e.manager_id,
        AVG(e.salary * 1.0) AS avg_report_salary
    FROM employees e
    WHERE e.manager_id IS NOT NULL
    GROUP BY e.manager_id
)
SELECT 
    m.emp_id AS manager_id,
    m.emp_name AS manager_name,
    m.salary AS manager_salary,
    d.avg_report_salary
FROM DirectReportAvgSalary d
JOIN employees m ON d.manager_id = m.emp_id
WHERE m.salary < d.avg_report_salary
ORDER BY d.avg_report_salary - m.salary DESC;


-----Challenge 6.21: Gender Diversity by Department
--Show a breakdown of gender diversity per department.


WITH GenderCounts AS (
    SELECT
        ISNULL(d.department_name, 'Unassigned Department') AS department_name,
        e.gender
    FROM employees e
    LEFT JOIN departments d ON e.department_id = d.department_id
),
AggregatedCounts AS (
    SELECT
        department_name,
        SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
        SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_count,
        COUNT(*) AS total_employees
    FROM GenderCounts
    GROUP BY department_name
)
SELECT
    department_name,
    male_count,
    female_count,
    total_employees,
    format(100.0 * female_count / total_employees, 'N2') AS female_percentage
FROM AggregatedCounts
ORDER BY department_name;


-----Challenge 6.22: multi-level Employee Reporting Chain challenge
--For each employee, show the full chain of managers up to the top-level (where manager_id IS NULL).


WITH EmployeeHierarchy AS (
    -- Anchor: Employees with no manager (top-level)
    SELECT 
        emp_id,
        emp_name,
        manager_id,
        CAST(emp_name AS VARCHAR(MAX)) AS reporting_chain
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: Add next level
    SELECT 
        e.emp_id,
        e.emp_name,
        e.manager_id,
        CAST(eh.reporting_chain + ' > ' + e.emp_name AS VARCHAR(MAX)) AS reporting_chain
    FROM employees e
    INNER JOIN EmployeeHierarchy eh ON e.manager_id = eh.emp_id
)

SELECT emp_id, emp_name, reporting_chain
FROM EmployeeHierarchy
ORDER BY emp_id;


-----Challenge 6.23: Multi-Level Department Reporting Structure


WITH DepartmentHierarchy AS (
    SELECT 
        department_id,
        department_name,
        CAST(department_name AS VARCHAR(MAX)) AS reporting_chain,
        parent_department_id
    FROM departments
    WHERE parent_department_id IS NULL

    UNION ALL

    SELECT 
        d.department_id,
        d.department_name,
        CAST(dh.reporting_chain + ' > ' + d.department_name AS VARCHAR(MAX)) AS reporting_chain,
        d.parent_department_id
    FROM departments d
    INNER JOIN DepartmentHierarchy dh ON d.parent_department_id = dh.department_id
)

SELECT department_id, department_name, reporting_chain
FROM DepartmentHierarchy
ORDER BY reporting_chain;


-----Challenge 6.24: Longest Tenured Employees per Department
--For each department, return the employee(s) with the earliest hire date (i.e., longest tenured) along with department name.


WITH RankedEmployees AS (
    SELECT 
        e.emp_id,
        e.emp_name,
        e.department_id,
        d.department_name,
        e.hire_date,
        DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.hire_date ASC) AS rk
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
)
SELECT emp_id, emp_name, department_name, hire_date
FROM RankedEmployees
WHERE rk = 1
ORDER BY department_name;


-----