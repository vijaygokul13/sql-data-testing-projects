-----

select * from locations;

select * from employees;

select * from departments;

select * from projects;

select * from employee_projects;


-----


--CREATE TABLE locations (
--    location_id INT PRIMARY KEY,
--    location_name VARCHAR(100),
--    region VARCHAR(50)
--);

--INSERT INTO locations VALUES
--(1, 'New York', 'Northeast'),
--(2, 'San Francisco', 'West'),
--(3, 'Chicago', 'Midwest'),
--(4, 'Austin', 'South'),
--(5, 'Seattle', 'Pacific Northwest'),
--(6, 'Miami', 'South'),
--(7, 'Denver', 'Mountain'),
--(8, 'Boston', 'Northeast');

--CREATE TABLE departments (
--    department_id INT PRIMARY KEY,
--    department_name VARCHAR(100),
--    manager_id INT,
--    location_id INT,
--    FOREIGN KEY (location_id) REFERENCES locations(location_id)
--);

--INSERT INTO departments VALUES
--(1, 'HR', 5, 1),
--(2, 'IT', 8, 2),
--(3, 'Finance', 7, 3),
--(4, 'Marketing', 6, 4),
--(5, 'Sales', 12, 5),
--(6, 'Legal', NULL, 6),
--(7, 'Procurement', NULL, 7);

--CREATE TABLE employees (
--    emp_id INT PRIMARY KEY,
--    emp_name VARCHAR(100),
--    department_id INT,
--    salary DECIMAL(10, 2),
--    hire_date DATE,
--    performance_score INT,
--    gender VARCHAR(10),
--    date_of_birth DATE,
--    email VARCHAR(100),
--    FOREIGN KEY (department_id) REFERENCES departments(department_id)
--);

--INSERT INTO employees VALUES
--(1, 'Alice', 1, 66000, '2019-02-15', 85, 'Female', '1990-05-10', 'alice@example.com'),
--(2, 'Bob', 2, 88000, '2018-05-12', 92, 'Male', '1988-03-15', 'bob@example.com'),
--(3, 'Carol', 3, 82500, '2020-01-20', 88, 'Female', '1992-06-20', 'carol@example.com'),
--(4, 'Dave', 2, 99000, '2017-09-10', 95, 'Male', '1985-08-25', 'dave@example.com'),
--(5, 'Eva', 1, 85000, '2016-06-01', 78, 'Female', '1991-01-30', 'eva@example.com'),
--(6, 'Frank', 4, 67000, '2021-03-25', 83, 'Male', '1995-12-05', 'frank@example.com'),
--(7, 'Grace', 3, 82000, '2018-11-30', 76, 'Female', '1994-11-22', 'grace@example.com'),
--(8, 'Harry', 2, 95000, '2015-07-14', 97, 'Male', '1990-04-14', 'harry@example.com'),
--(9, 'Irene', 4, 70400, '2020-08-18', 68, 'Female', '1992-09-30', 'irene@example.com'),
--(10, 'John', 1, 79200, '2022-01-05', 80, 'Male', '1993-02-17', 'john@example.com'),
--(12, 'Leo', 5, 85800, '2021-05-17', 91, 'Male', '1987-07-19', 'leo@example.com');

--CREATE TABLE projects (
--    project_id INT PRIMARY KEY,
--    project_name VARCHAR(100),
--    start_date DATE,
--    end_date DATE,
--    budget DECIMAL(12, 2)
--);

--INSERT INTO projects VALUES
--(101, 'Apollo', '2022-01-01', '2022-12-31', 1000000),
--(102, 'Hermes', '2022-06-01', '2023-05-31', 750000),
--(103, 'Zeus', '2023-01-01', '2023-12-31', 1200000),
--(104, 'Athena', '2023-03-15', '2023-11-30', 950000);


--CREATE TABLE employee_projects (
--    emp_id INT,
--    project_id INT,
--    assignment_date DATE,
--    role VARCHAR(100),
--    PRIMARY KEY (emp_id, project_id),
--    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
--    FOREIGN KEY (project_id) REFERENCES projects(project_id)
--);

--INSERT INTO employee_projects VALUES
--(1, 101, '2022-01-10', 'Developer'),
--(2, 101, '2022-02-15', 'Tester'),
--(3, 102, '2022-06-10', 'Analyst'),
--(4, 102, '2022-07-01', 'Team Lead'),
--(5, 103, '2023-01-05', 'Developer'),
--(6, 103, '2023-02-10', 'QA'),
--(7, 104, '2023-04-01', 'Architect'),
--(8, 101, '2022-03-20', 'Support'),
--(9, 104, '2023-04-20', 'Developer'),
--(10, 102, '2022-06-25', 'Intern'),
--(12, 103, '2023-01-17', 'Tester');

--INSERT INTO employees (
--  emp_id, emp_name, department_id, salary, hire_date,
--  performance_score, gender, date_of_birth, email
--) VALUES
--(13, 'Mona', NULL, 72000.00, '2023-03-01', 82, 'Female', '1991-04-18', 'mona@example.com'),
--(14, 'Nikhil', NULL, 68000.00, '2022-07-15', 79, 'Male', '1989-11-22', 'nikhil@example.com'),
--(15, 'Priya', NULL, 75000.00, '2021-09-10', 85, 'Female', '1992-08-30', 'priya@example.com'),
--(16, 'Ravi', NULL, 69000.00, '2020-12-20', 77, 'Male', '1990-03-14', 'ravi@example.com'),
--(17, 'Sneha', NULL, 71000.00, '2023-05-12', 88, 'Female', '1993-06-01', 'sneha@example.com');

--INSERT INTO projects (
--  project_id, project_name, start_date, end_date, budget
--) VALUES
--(105, 'Poseidon', '2023-09-01', '2024-08-31', 880000.00),
--(106, 'Hera', '2024-01-01', '2024-12-31', 1020000.00),
--(107, 'Ares', '2024-05-01', '2025-04-30', 970000.00);

--INSERT INTO employee_projects (
--  emp_id, project_id, assignment_date, role
--) VALUES
--(1, 102, '2022-08-10', 'QA'),           -- Alice now on projects 101 & 102
--(2, 103, '2023-01-20', 'Support'),      -- Bob now on projects 101 & 103
--(3, 104, '2023-04-05', 'Consultant'),   -- Carol now on projects 102 & 104
--(4, 104, '2023-05-15', 'Coordinator'),  -- Dave now on projects 102 & 104
--(5, 101, '2022-02-01', 'Intern'),       -- Eva now on projects 103 & 101
--(6, 104, '2023-06-01', 'Developer');    -- Frank now on projects 103 & 104

---- Employees in empty departments (6, 7)
--INSERT INTO employees (emp_id, emp_name, department_id, salary, hire_date, performance_score, gender, date_of_birth, email) VALUES
--(18, 'Tina', 6, 74000.00, '2023-07-10', 86, 'Female', '1990-12-12', 'tina@example.com'),
--(19, 'Uday', 7, 76500.00, '2023-08-12', 80, 'Male', '1989-10-20', 'uday@example.com');

---- Employee with no project
--INSERT INTO employees (emp_id, emp_name, department_id, salary, hire_date, performance_score, gender, date_of_birth, email) VALUES
--(20, 'Vikram', 2, 81000.00, '2024-01-01', 90, 'Male', '1991-09-09', 'vikram@example.com');

--INSERT INTO employee_projects (emp_id, project_id, assignment_date, role) VALUES
--(6, 105, '2023-10-01', 'Consultant'),
--(7, 106, '2024-02-10', 'Lead QA'),
--(8, 107, '2024-06-15', 'Analyst');

--INSERT INTO departments (department_id, department_name, manager_id, location_id)
--VALUES (8, 'R&D', NULL, 8);

--INSERT INTO employees (emp_id, emp_name, department_id, salary, hire_date, performance_score, gender, date_of_birth, email) VALUES
--(21, 'Yash', 8, 78000.00, '2024-03-10', 87, 'Male', '1990-11-11', 'yash@example.com');

--INSERT INTO projects (project_id, project_name, start_date, end_date, budget) VALUES
--(108, 'Poseidon', '2024-02-01', '2024-12-31', 850000.00),
--(109, 'Hercules', '2024-06-01', '2025-05-31', 910000.00);

--INSERT INTO employees (
--  emp_id, emp_name, department_id, salary, hire_date,
--  performance_score, gender, date_of_birth, email
--)
--VALUES (
--  11, 'Nina', NULL, 72000.00, '2021-07-10',
--  82, 'Female', '1991-10-15', 'nina@example.com'
--);


---- Employee 11: Assigned to 2 projects with different roles
--INSERT INTO employee_projects (emp_id, project_id, assignment_date, role) VALUES
--(11, 108, '2024-03-01', 'Tester'),
--(11, 109, '2024-07-01', 'Developer');

---- Employee 13: Assigned to 3 projects but with SAME role (should be excluded in query result)
--INSERT INTO employee_projects (emp_id, project_id, assignment_date, role) VALUES
--(13, 101, '2022-01-20', 'Analyst'),
--(13, 102, '2022-05-15', 'Analyst'),
--(13, 103, '2023-03-01', 'Analyst');

---- Employee 14: Assigned to only 1 project (should be excluded)
--INSERT INTO employee_projects (emp_id, project_id, assignment_date, role) VALUES
--(14, 105, '2023-09-12', 'Support');

---- Employee 15: Assigned to 2 projects with different roles
--INSERT INTO employee_projects (emp_id, project_id, assignment_date, role) VALUES
--(15, 106, '2024-01-05', 'Developer'),
--(15, 107, '2024-03-10', 'QA');

--ALTER TABLE employee_projects
--DROP CONSTRAINT PK__employee__F95E31804613FFE4;


-- Add new identity primary key

--ALTER TABLE employee_projects 
--ADD id INT IDENTITY(1,1) PRIMARY KEY;



---- Employee 2 assigned to project 103 as both Support and Coordinator on the same date
--INSERT INTO employee_projects (emp_id, project_id, assignment_date, role)
--VALUES 
--(2, 103, '2023-01-20', 'Coordinator');

---- Employee 6 assigned to project 105 as both Consultant and Lead Architect
--INSERT INTO employee_projects (emp_id, project_id, assignment_date, role)
--VALUES 
--(6, 105, '2023-10-01', 'Lead Architect');

---- Employee 13 working on project 103 as Analyst and Reviewer on the same date
--INSERT INTO employee_projects (emp_id, project_id, assignment_date, role)
--VALUES 
--(13, 103, '2023-03-01', 'Reviewer');

---- Employee 8 on project 101 as both Support and Documentation Specialist
--INSERT INTO employee_projects (emp_id, project_id, assignment_date, role)
--VALUES 
--(8, 101, '2022-03-20', 'Documentation Specialist');


--CREATE TABLE employee_projects_new (
--    id INT PRIMARY KEY,
--    emp_id INT,
--    project_id INT,
--    assignment_date DATE,
--    role VARCHAR(100)
--);

--INSERT INTO employee_projects_new (id, emp_id, project_id, assignment_date, role)
--SELECT id, emp_id, project_id, assignment_date, role
--FROM employee_projects;

--DROP TABLE employee_projects;

--EXEC sp_rename 'employee_projects_new', 'employee_projects';

--ALTER TABLE projects
--ADD department_id INT;

--UPDATE projects SET department_id = 1 WHERE project_id = 101; -- Apollo - HR
--UPDATE projects SET department_id = 2 WHERE project_id = 102; -- Hermes - IT
--UPDATE projects SET department_id = 2 WHERE project_id = 103; -- Zeus - IT
--UPDATE projects SET department_id = 3 WHERE project_id = 104; -- Athena - Finance
--UPDATE projects SET department_id = 4 WHERE project_id = 105; -- Poseidon - Marketing
--UPDATE projects SET department_id = 3 WHERE project_id = 106; -- Hera - Finance
--UPDATE projects SET department_id = 3 WHERE project_id = 107; -- Ares - Finance
--UPDATE projects SET department_id = 1 WHERE project_id = 108; -- Poseidon - HR
--UPDATE projects SET department_id = 1 WHERE project_id = 109; -- Hercules - HR

--INSERT INTO projects (project_id, project_name, start_date, end_date, budget, department_id)
--VALUES
--(110, 'Janus', '2024-03-15', '2025-02-28', 940000.00, 1),  -- Same department (1) and year (2024) as 108 and 109
--(111, 'Neptune', '2024-07-01', '2025-06-30', 970000.00, 3); -- Same dept (3), same year (2024) as 106 and 107

--INSERT INTO employee_projects (id, emp_id, project_id, assignment_date, role)
--VALUES
--(33, 11, 110, '2024-03-10', 'Tester'),
--(34, 15, 111, '2024-08-10', 'Developer');

--ALTER TABLE employees
--ADD manager_id INT;

--UPDATE e
--SET e.manager_id = d.manager_id
--FROM employees e
--JOIN departments d ON e.department_id = d.department_id;


-----Find the total salary paid for each department and show only departments with a total salary greater than 100,000.


SELECT 
  d.department_name, 
  SUM(e.salary) AS total_salary
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING SUM(e.salary) > 100000;


-----Top N Employees by Salary in Each Department


WITH RankedEmployees AS (
  SELECT 
    e.emp_id, 
    e.emp_name, 
    e.salary, 
    d.department_name,
    ROW_NUMBER() OVER (PARTITION BY e.department_name ORDER BY e.salary DESC) AS rank
  FROM employees e
  INNER JOIN departments d
    ON e.department_id = d.department_id
)
SELECT 
  emp_id, 
  emp_name, 
  salary, 
  department_name
FROM RankedEmployees
WHERE rank <= 3;


-----You want to compare the number of employees and average salary in each department.


SELECT 
  d.department_name,
  COUNT(e.emp_id) AS employee_count, 
  AVG(e.salary) AS average_salary
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.department_id
GROUP BY d.department_name;


-----List employees who don't belong to any department. These could be employees in transition or errors in data.


SELECT 
  e.emp_id, 
  e.emp_name, 
  e.department_name
FROM employees e
LEFT JOIN departments d
  ON e.department_id = d.department_id
WHERE d.department_id IS NULL;


-----Show the number of employees per region and department. List only regions with more than 3 employees.


SELECT 
  d.department_name,
  e.region,
  COUNT(e.emp_id) AS employee_count
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.department_id
GROUP BY d.department_name, e.region
HAVING COUNT(e.emp_id) > 3;


-----You need to analyze which departments have employees from multiple regions, e.g., regions with employees from more than 2 distinct regions.


SELECT 
  d.department_name,
  COUNT(DISTINCT e.region) AS region_count
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(DISTINCT e.region) > 2;


-----Get the distribution of employees in each department, sorted by department name.


SELECT 
  d.department_name, 
  COUNT(e.emp_id) AS employee_count
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY d.department_name;


-----Get all employees with their department name


SELECT 
    e.emp_id,
    e.emp_name,
    d.department_name
FROM 
    employees e
INNER JOIN 
    departments d ON e.department_id = d.department_id;


-----Get all departments and their employees (even if no employee)


SELECT 
    d.department_id,
    d.department_name,
    e.emp_name
FROM 
    departments d
LEFT JOIN 
    employees e ON d.department_id = e.department_id;


-----Get all employees and their department (even if no department exists)


SELECT 
    e.emp_id,
    e.emp_name,
    d.department_name
FROM 
    employees e
RIGHT JOIN 
    departments d ON e.department_id = d.department_id;


-----Get all employees and departments, even if no match on either side


SELECT 
    e.emp_id,
    e.emp_name,
    d.department_name
FROM 
    employees e
LEFT JOIN 
    departments d ON e.department_id = d.department_id

UNION

SELECT 
    e.emp_id,
    e.emp_name,
    d.department_name
FROM 
    employees e
RIGHT JOIN 
    departments d ON e.department_id = d.department_id;


-----List all employees along with the project names they are assigned to


SELECT 
    e.emp_name,
    p.project_name,
    ep.role,
    ep.assignment_date
FROM 
    employees e
JOIN 
    employee_projects ep ON e.emp_id = ep.emp_id
JOIN 
    projects p ON ep.project_id = p.project_id;


-----List all employees along with their department name and manager name. Only show those who are currently assigned to a department with a known manager.


SELECT 
    e.emp_id, 
    e.emp_name, 
    d1.department_name,
    temp.manager_name
FROM employees e
INNER JOIN departments d1 ON e.department_id = d1.department_id
INNER JOIN (
    SELECT 
        d2.department_id, 
        d2.department_name, 
        e2.emp_name AS manager_name 
    FROM departments d2
    INNER JOIN employees e2 ON d2.manager_id = e2.emp_id
) temp ON d1.department_id = temp.department_id;


----- find the names of employees who are assigned to at least one project, along with the project name and their department name.


SELECT 
    e1.emp_id, 
    e1.emp_name, 
    d.department_name, 
    p.project_name
FROM employees e1
INNER JOIN departments d ON e1.department_id = d.department_id
INNER JOIN employee_projects ep ON ep.emp_id = e1.emp_id
INNER JOIN projects p ON p.project_id = ep.project_id;


-----Show all employees, their department name, and the project they are assigned to (if any).


SELECT
  e1.emp_id,
  e1.emp_name,
  COALESCE(d.department_name, 'No Department Assigned') AS department_name,
  COALESCE(p.project_name, 'No Project Assigned') AS project_name
FROM employees e1 
LEFT JOIN departments d ON d.department_id = e1.department_id
LEFT JOIN employee_projects ep ON ep.emp_id = e1.emp_id
LEFT JOIN projects p ON p.project_id = ep.project_id;


-----prepare a report for the Project Management Office that shows all projects, along with employees assigned to them (if any). 
--If a project has no employees, it should still appear. 


select 
	p.project_id,
	p.project_name,
	coalesce (e1.emp_id, 0) as Emp_ID,
	coalesce (e1.emp_name, 'Not Assigned') as Emp_Name
from employees e1 
	right join employee_projects ep on e1.emp_id = ep.emp_id
	right join projects p on ep.project_id = p.project_id;


-----Write a query to list all employees and all projects, even if an employee is not 
--assigned to any project or a project has no employees assigned.


select 
	coalesce(e1.emp_id,0) as Emp_Id,
	coalesce(e1.emp_name,'Not Assigned') as Emp_Name,
	coalesce(p.project_id,0) as Project_Id,
	coalesce(p.project_name,'Not Assigned') as Project_Name
from employees e1
	 full outer join employee_projects ep on ep.emp_id = e1.emp_id
	 full outer join projects p on p.project_id = ep.project_id
order by emp_name


----- retrieve the employees who have the same department as any other employee and show their details (Emp_ID, Emp_Name, Department_Name) 
--along with the other employee’s details (Emp_ID, Emp_Name, Department_Name).


select * from employees;
select * from departments;
select * from projects;
select * from employee_projects;

SELECT 
    e1.emp_id AS Emp1_ID,
    e1.emp_name AS Emp1_Name,
    d.department_name,
    e2.emp_id AS Emp2_ID,
    e2.emp_name AS Emp2_Name
FROM employees e1
JOIN employees e2 
    ON e1.department_id = e2.department_id 
    AND e1.emp_id <> e2.emp_id
JOIN departments d 
    ON d.department_id = e1.department_id
ORDER BY d.department_name, e1.emp_id;


-----Write a SQL query to find all employees who are assigned to more than one project.
--Display their emp_id, emp_name, and the total number of projects they are assigned to.


select * from employees
select * from employee_projects
select * from projects

SELECT 
    e1.emp_id, 
    e1.emp_name, 
    temp.No_Of_Projects 
FROM employees e1
INNER JOIN (
    SELECT 
        ep.emp_id, 
        COUNT(*) AS No_Of_Projects
    FROM employee_projects ep
    GROUP BY ep.emp_id
    HAVING COUNT(*) > 1
) temp ON temp.emp_id = e1.emp_id
ORDER BY e1.emp_id;


-----List all departments with the number of employees in each department, including departments that have no employees.


select 
	d.department_id,
	d.department_name,
	coalesce(temp.No_of_employees, 0) as No_of_employees
from departments d
left join (select 
			e1.department_id,
			count(*) as No_of_employees
			from employees e1
			group by e1.department_id) temp
		on temp.department_id = d.department_id
		order by department_id;


-----For each employee, display their emp_id, emp_name, and the most recently assigned project's name (project_name), using joins.

	SELECT
    e.emp_id,
    e.emp_name,
    d.department_name,
    p.project_name,
    temp.assignment_date
FROM employees e
INNER JOIN departments d ON d.department_id = e.department_id
INNER JOIN (
    SELECT 
        ep.emp_id,
        ep.project_id,
        ep.assignment_date,
        ROW_NUMBER() OVER (PARTITION BY ep.emp_id ORDER BY ep.assignment_date DESC) AS Row_Num
    FROM employee_projects ep
) temp ON temp.emp_id = e.emp_id AND temp.Row_Num = 1
INNER JOIN projects p ON p.project_id = temp.project_id;


-----Show only departments where none of the employees (in that department) are assigned to any project.


SELECT 
    d.department_id,
    d.department_name,
    e.emp_id,
    e.emp_name
FROM departments d
LEFT JOIN employees e ON e.department_id = d.department_id
LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
WHERE ep.project_id IS NULL AND e.emp_id IS NOT NULL
ORDER BY d.department_id, e.emp_id;


-----Top Performer per Department (For each department, list the employee with the highest performance score.)
--Return one row per department.
--Show the department name, top performer’s name, employee ID, and performance score.
--If two employees have the same top score in the same department, return only one (any one).


select 
	temp.department_id,
	d.department_name,
	temp.emp_id,
	temp.emp_name,
	temp.performance_score
from departments d
	inner join (select 
				e.department_id,
				e.emp_id,
				e.emp_name,
				e.performance_score,
					ROW_NUMBER() over (
					partition by e.department_id 
					order by e.performance_score desc) as Row_Num_
	from employees e) temp on temp.department_id = d.department_id
	where temp.Row_Num_ = 1;
 
 
-----Top Performer per Department (For each department, list the employee with the highest performance score.)
--Return one row per department.
--Show the department name, top performer’s name, employee ID, and performance score.
--If two employees have the same top score in the same department, return only one (any one).


select 
	temp.department_id,
	d.department_name,
	temp.emp_id,
	temp.emp_name,
	temp.performance_score
from departments d
	inner join (select 
				e.department_id,
				e.emp_id,
				e.emp_name,
				e.performance_score,
					RANK() over (
					partition by e.department_id 
					order by e.performance_score desc) as Rank_
	from employees e) temp on temp.department_id = d.department_id
	where temp.Rank_ = 1;
 

 -----Employee Info with Department, Manager, and Location


select * from employees;

select * from departments;

select * from locations;

SELECT 
    e.emp_name AS employee_name,
		coalesce(d.department_name, 'No Dept Mapped') AS department_name,
		coalesce(m.emp_name, 'No Manager') AS manager_name,
		coalesce(l.location_name, 'No Location Mapped') AS location_name
	FROM 
    employees e
LEFT JOIN 
    departments d ON e.department_id = d.department_id
LEFT JOIN 
    employees m ON d.manager_id = m.emp_id
LEFT JOIN 
    locations l ON d.location_id = l.location_id
ORDER BY 
    employee_name;


-----Projects Assigned in 2023 with Employee Names and Roles
--List all employee assignments to projects that started or ended in 2023, showing:
--Employee name
--Project name
--Assignment role
--Assignment date


SELECT
    e.emp_name,
    p.project_name,
    ep.role,
    ep.assignment_date
FROM employees e
JOIN employee_projects ep ON ep.emp_id = e.emp_id
JOIN projects p ON p.project_id = ep.project_id
WHERE YEAR(p.start_date) = 2023 
   OR YEAR(p.end_date) = 2023;

-----Employees Assigned to Multiple Projects
--Find the names of employees who are assigned to more than one project.
--Display:
--Employee name
--Number of projects assigned


select 
	e.emp_name,
	temp.No_Of_Projects
from employees e
inner join
	(
		select 
			ep.emp_id,
			count(*) as No_Of_Projects
		from employee_projects ep
		group by ep.emp_id
		having count(*) > 1  -- 👈 Add this line
	) temp
	on temp.emp_id = e.emp_id;


-----Department-Wise Average Salary and Headcount
--For each department, show:
--Department name
--Average salary of employees in that department
--Number of employees in that department
--Include only departments that have at least one employee.


SELECT 
    d.department_name,
    FORMAT(temp.average_salary, 'N2') AS average_salary,
    temp.employee_count
FROM departments d
INNER JOIN (
    SELECT 
        e.department_id,
        AVG(e.salary) AS average_salary,
        COUNT(e.emp_id) AS employee_count
    FROM employees e
    WHERE e.department_id IS NOT NULL
    GROUP BY e.department_id
) temp ON temp.department_id = d.department_id
ORDER BY temp.average_salary DESC;


-----List employees who are working on multiple projects with different roles
--Show only those employees who have been assigned to more than one project and have served in different roles across those projects.
--Expected Output:
--emp_name
--number_of_projects
--distinct_roles
--Only include employees where number_of_projects > 1 and distinct_roles > 1.


select 
	e.emp_name,
	temp.Count_Of_Projects,
	temp.Distinct_Roles
from employees e
	inner join 
	(SELECT 
		ep.emp_id,
		count(ep.project_id) as Count_Of_Projects,
		count(distinct ep.role) as Distinct_Roles
	FROM employee_projects ep
	GROUP BY ep.emp_id
	HAVING count(distinct ep.role)>1 and count(ep.project_id)>1) temp
	on temp.emp_id = e.emp_id;


-----Find employees who were assigned to every project that started in the year 2023


-- Step 1: Get the total number of projects that started in 2023
WITH Projects2023 AS (
    SELECT project_id
    FROM projects
    WHERE YEAR(start_date) = 2023
),
-- Step 2: Count how many of these projects each employee worked on
EmployeeProjectCounts AS (
    SELECT ep.emp_id, COUNT(DISTINCT ep.project_id) AS project_count
    FROM employee_projects ep
    INNER JOIN Projects2023 p23 ON ep.project_id = p23.project_id
    GROUP BY ep.emp_id
),
-- Step 3: Get the total number of 2023 projects
TotalProjects AS (
    SELECT COUNT(*) AS total_2023_projects FROM Projects2023
)
-- Step 4: Find employees who worked on all 2023 projects
SELECT e.emp_id, e.emp_name
FROM EmployeeProjectCounts epc
CROSS JOIN TotalProjects tp
INNER JOIN employees e ON e.emp_id = epc.emp_id
WHERE epc.project_count = tp.total_2023_projects;


-----Employees Assigned to Multiple Projects in the Same Year


---Method 1 (Using Inner Join + CTE)


WITH employees_with_multiple_projects AS (
    select 
        ep.emp_id,
        year(ep.assignment_date) as Assignment_Year,
        count(*) as No_Of_Projects
    from employee_projects ep
    group by ep.emp_id, year(ep.assignment_date)
    having count(*) > 1
)
select 
    e.emp_name, 
    ewmp.No_Of_Projects, 
    ewmp.Assignment_Year 
from employees_with_multiple_projects ewmp
inner join employees e on e.emp_id = ewmp.emp_id;


---Method 2 (Using Self-Join + Subquery)


SELECT 
    e.emp_name,
    derived.emp_id,
    derived.assignment_year,
    derived.project_count
FROM 
    (
        SELECT 
            ep1.emp_id,
            YEAR(ep1.assignment_date) AS assignment_year,
            COUNT(DISTINCT ep1.project_id) AS project_count
        FROM 
            employee_projects ep1
        JOIN 
            employee_projects ep2 
            ON ep1.emp_id = ep2.emp_id 
            AND ep1.project_id <> ep2.project_id
            AND YEAR(ep1.assignment_date) = YEAR(ep2.assignment_date)
        GROUP BY 
            ep1.emp_id, YEAR(ep1.assignment_date)
        HAVING 
            COUNT(DISTINCT ep1.project_id) > 1
    ) derived
JOIN 
    employees e ON e.emp_id = derived.emp_id;


-----Find the names of employees who were assigned to at least one project in 2023 and 
--belong to a department where the average salary is more than ₹60,000.


--Method 1 (IN + Subquery)


select 
	e.emp_name,
	d.department_name,
	p.project_name,
	ep.assignment_date
from employees e
inner join departments d on d.department_id = e.department_id
inner join employee_projects ep on ep.emp_id = e.emp_id
inner join projects p on p.project_id = ep.project_id
where year(ep.assignment_date) = 2023
and d.department_id in ( select e2.department_id
						from employees e2
						where e2.department_id is not null
						group by e2.department_id
						having avg(e2.salary) > 60000);


--Method 2 (Derived Table Join)


SELECT 
    e.emp_name,
    d.department_name,
    p.project_name,
    ep.assignment_date
FROM employees e
INNER JOIN departments d ON d.department_id = e.department_id
INNER JOIN employee_projects ep ON ep.emp_id = e.emp_id
INNER JOIN projects p ON p.project_id = ep.project_id
INNER JOIN (
    SELECT 
        department_id
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
    HAVING AVG(salary) > 60000
) dept_filter ON dept_filter.department_id = e.department_id
WHERE YEAR(ep.assignment_date) = 2023;


--Method 3 (CTE + Join)


WITH High_Salary_Depts AS (
    SELECT department_id
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
    HAVING AVG(salary) > 60000
)
SELECT 
    e.emp_name,
    d.department_name,
    p.project_name,
    ep.assignment_date
FROM employees e
INNER JOIN departments d ON d.department_id = e.department_id
INNER JOIN employee_projects ep ON ep.emp_id = e.emp_id
INNER JOIN projects p ON p.project_id = ep.project_id
INNER JOIN High_Salary_Depts hsd ON hsd.department_id = e.department_id
WHERE YEAR(ep.assignment_date) = 2023;


----- Identify Cross-Department Collaboration.
--Find employees who have worked on projects with other employees from different departments.
--Return each such employee’s emp_name, their department_name, and the number of distinct departments (excluding their own) they collaborated with.

--Method 1

SELECT 
    e1.emp_id,
    e1.emp_name,
    COUNT(DISTINCT e2.department_id) AS distinct_departments_collaborated
FROM 
    employees e1
JOIN employee_projects ep1 ON e1.emp_id = ep1.emp_id
JOIN employee_projects ep2 ON ep1.project_id = ep2.project_id
JOIN employees e2 ON ep2.emp_id = e2.emp_id
WHERE 
    e1.emp_id <> e2.emp_id
    AND e1.department_id IS NOT NULL
    AND e2.department_id IS NOT NULL
    AND e1.department_id <> e2.department_id

GROUP BY 
    e1.emp_id, e1.emp_name
ORDER BY 
    distinct_departments_collaborated DESC;

--Method 2

SELECT 
    e.emp_id,
    e.emp_name,
    (
        SELECT COUNT(DISTINCT e2.department_id)
        FROM employee_projects ep1
        JOIN employee_projects ep2 ON ep1.project_id = ep2.project_id
        JOIN employees e2 ON e2.emp_id = ep2.emp_id
        WHERE 
            ep1.emp_id = e.emp_id
            AND e2.emp_id <> e.emp_id
            AND e2.department_id IS NOT NULL
            AND e.department_id IS NOT NULL
            AND e2.department_id <> e.department_id
    ) AS distinct_departments_collaborated
FROM employees e
WHERE e.department_id IS NOT NULL
ORDER BY distinct_departments_collaborated DESC;


-----Find employees who are assigned to multiple projects, and those projects include team members from different departments.
--looking for employees who worked on at least 2 projects, where different departments of employees were involved on those projects 
--(even if the projects themselves don’t have a department).


SELECT 
    ep1.emp_id,
    e1.emp_name,
    COUNT(DISTINCT e2.department_id) AS distinct_departments
FROM employee_projects ep1
JOIN employee_projects ep2 
    ON ep1.project_id = ep2.project_id
JOIN employees e1 
    ON ep1.emp_id = e1.emp_id
JOIN employees e2 
    ON ep2.emp_id = e2.emp_id
WHERE e2.department_id IS NOT NULL
GROUP BY ep1.emp_id, e1.emp_name
HAVING COUNT(DISTINCT e2.department_id) >= 2;


-----Find the names of employees who are working on more than one project where all the assigned projects started in different years.
--Also show:
--The number of such projects
--The list of unique start years (comma-separated)


SELECT 
    e.emp_name,
    COUNT(DISTINCT p.project_id) AS No_Of_Projects,
    COUNT(DISTINCT YEAR(p.start_date)) AS Unique_Years
FROM 
    employees e
INNER JOIN employee_projects ep ON e.emp_id = ep.emp_id
INNER JOIN projects p ON ep.project_id = p.project_id
GROUP BY 
    e.emp_id, e.emp_name
HAVING 
    COUNT(DISTINCT YEAR(p.start_date)) > 1;


-----List employees who worked on at least 2 different projects in the same department, and those projects were both started in the same year.


WITH emp_project_info AS (
    SELECT 
        ep.emp_id,
        ep.project_id,
        p.department_id,
        YEAR(p.start_date) AS start_year
    FROM 
        employee_projects ep
    JOIN 
        projects p ON ep.project_id = p.project_id
),
emp_valid_pairs AS (
    SELECT 
        a.emp_id
    FROM 
        emp_project_info a
    JOIN 
        emp_project_info b 
        ON a.emp_id = b.emp_id 
        AND a.department_id = b.department_id 
        AND a.start_year = b.start_year 
        AND a.project_id < b.project_id
)
SELECT DISTINCT emp_id 
FROM emp_valid_pairs;


-----List departments that have more than 2 employees working on more than 1 project each.
--Then, also show the count of such employees per department.


SELECT 
    e.emp_name,
    COUNT(DISTINCT ep1.project_id) AS projects_count
FROM employee_projects ep1
JOIN projects p1 ON ep1.project_id = p1.project_id
JOIN employee_projects ep2 ON ep1.emp_id = ep2.emp_id AND ep1.project_id < ep2.project_id
JOIN projects p2 ON ep2.project_id = p2.project_id
JOIN employees e ON ep1.emp_id = e.emp_id
WHERE 
    p1.department_id = p2.department_id
    AND YEAR(p1.start_date) = YEAR(p2.start_date)
GROUP BY e.emp_name
HAVING COUNT(DISTINCT ep1.project_id) > 1;


-----List employees who worked on at least two different projects in the same department, and those projects must have both started in the same year.


SELECT 
    ep1.emp_id, 
    e.emp_name,
    ep1.project_id AS project_1, 
    ep2.project_id AS project_2, 
    p1.department_id,
    YEAR(p1.start_date) AS project_year
FROM 
    employee_projects ep1
JOIN employee_projects ep2 ON ep1.emp_id = ep2.emp_id AND ep1.project_id < ep2.project_id
JOIN projects p1 ON ep1.project_id = p1.project_id
JOIN projects p2 ON ep2.project_id = p2.project_id
JOIN employees e ON ep1.emp_id = e.emp_id
WHERE 
    p1.department_id = p2.department_id 
    AND YEAR(p1.start_date) = YEAR(p2.start_date)
ORDER BY e.emp_name;


-----List all employees who worked on projects from different departments, and the projects they worked on, along with the year the project was started.


SELECT * FROM employees;

SELECT * FROM departments;

SELECT * FROM employee_projects;

SELECT * FROM projects;

WITH project_details AS (
    SELECT 
        e.emp_id,
        e.emp_name,
        p.project_id,
        p.department_id,
        YEAR(p.start_date) AS project_year
    FROM employees e
    JOIN employee_projects ep ON e.emp_id = ep.emp_id
    JOIN projects p ON ep.project_id = p.project_id
    WHERE p.department_id IS NOT NULL
),
project_pairs AS (
    SELECT 
        pd1.emp_id,
        pd1.emp_name,
        pd1.project_id AS project_1,
        pd2.project_id AS project_2,
        pd1.department_id,
        pd1.project_year
    FROM project_details pd1
    JOIN project_details pd2 
        ON pd1.emp_id = pd2.emp_id
        AND pd1.project_id < pd2.project_id
        AND pd1.department_id = pd2.department_id
        AND pd1.project_year = pd2.project_year
)

SELECT * FROM project_pairs
ORDER BY emp_id, project_year;


-----List employees who worked on more than 2 such project pairs in the same department and year


WITH project_details AS (
    SELECT 
        e.emp_id,
        e.emp_name,
        p.project_id,
        p.department_id,
        YEAR (p.start_date) AS project_year
    FROM employees e
    JOIN employee_projects ep ON e.emp_id = ep.emp_id
    JOIN projects p ON ep.project_id = p.project_id
    WHERE p.department_id IS NOT NULL
),
project_pairs AS (
    SELECT 
        pd1.emp_id,
        pd1.emp_name,
        pd1.project_id AS project_1,
        pd2.project_id AS project_2,
        pd1.department_id,
        pd1.project_year
    FROM project_details pd1
    JOIN project_details pd2 
        ON pd1.emp_id = pd2.emp_id
        AND pd1.project_id < pd2.project_id
        AND pd1.department_id = pd2.department_id
        AND pd1.project_year = pd2.project_year
),
pair_count AS (
    SELECT 
        emp_id,
        emp_name,
        department_id,
        project_year,
        COUNT(*) AS project_pair_count
    FROM project_pairs
    GROUP BY emp_id, emp_name, department_id, project_year
    HAVING COUNT(*) > 2
)

SELECT * FROM pair_count
ORDER BY emp_id, project_year;

-----Challenge Goal: Get detailed information about each employee along with:
--Their assigned project
--The department of that project
--The department’s location
--And the department manager’s name


select 
e1.emp_id,
e1.emp_name,
ep1.project_id,
p1.project_name,
p1.department_id,
d1.department_name,
l1.location_name,
d1.manager_id,
e2.emp_name as Manager_Name
from employees e1
inner join employee_projects ep1
on ep1.emp_id = e1.emp_id
inner join projects p1
on p1.project_id = ep1.project_id
inner join departments d1
on d1.department_id = p1.department_id
inner join locations l1
on l1.location_id = d1.location_id
inner join employees e2
on e2.emp_id = d1.manager_id;


-----List employees who have worked on projects in more than one department, along with the count of distinct departments they've contributed to.


select 
distinct
e1.emp_id,
e1.emp_name,
count(distinct p1.department_id) as distinct_dept_count
from employees e1
inner join employee_projects ep1
on ep1.emp_id = e1.emp_id
inner join projects p1
on p1.project_id = ep1.project_id
group by e1.emp_id, e1.emp_name
having count(distinct p1.department_id)>1;


-----Employees with Project Duration and Department Information
--We need to list employees who have worked on projects, showing:
--Their name.
--The name of each project they've worked on.
--The department they worked for on each project.
--The duration they have worked on the project (start date to end date).
--The total number of projects they have worked on.
--Make sure to:
--Join the tables employees, employee_projects, projects, and departments.
--Use aggregation to get the total number of projects.
--Calculate the duration each employee worked on the project in days.


select 
e1.emp_id,
e1.emp_name,
COUNT(distinct p1.department_id) as count_of_depts,
SUM(DATEDIFF(DAY, p1.start_date, p1.end_date)) as Total_Duration_In_Days
from employees e1
inner join employee_projects ep1
on ep1.emp_id = e1.emp_id
inner join projects p1
on p1.project_id = ep1.project_id
inner join departments d1
on d1.department_id = p1.department_id
group by e1.emp_id, e1.emp_name
having COUNT(distinct p1.department_id) > 1;


-----Top 2 Employees by Total Project Duration in Each Department


WITH Employees_Details_1 AS (
    SELECT 
        e1.emp_id,
        e1.emp_name,
        p1.department_id,
        d1.department_name,
        SUM(DATEDIFF(DAY, p1.start_date, p1.end_date)) AS Total_Project_Duration
    FROM employees e1
    INNER JOIN employee_projects ep1 ON ep1.emp_id = e1.emp_id
    INNER JOIN projects p1 ON p1.project_id = ep1.project_id
    INNER JOIN departments d1 ON d1.department_id = p1.department_id
    GROUP BY e1.emp_id, e1.emp_name, p1.department_id, d1.department_name
),
Employees_Details_2 AS (
    SELECT *,
           RANK() OVER (PARTITION BY ED1.department_id ORDER BY ED1.Total_Project_Duration DESC) AS rank_in_employee
    FROM Employees_Details_1 ED1
)
SELECT *
FROM Employees_Details_2
WHERE rank_in_employee <= 2;


---


WITH Employees_Details_1 AS (
    SELECT 
        e1.emp_id,
        e1.emp_name,
        p1.department_id,
        d1.department_name,
        SUM(DATEDIFF(DAY, p1.start_date, p1.end_date)) AS Total_Project_Duration
    FROM employees e1
    INNER JOIN employee_projects ep1 ON ep1.emp_id = e1.emp_id
    INNER JOIN projects p1 ON p1.project_id = ep1.project_id
    INNER JOIN departments d1 ON d1.department_id = p1.department_id
    GROUP BY e1.emp_id, e1.emp_name, p1.department_id, d1.department_name
)
SELECT *
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY department_id ORDER BY Total_Project_Duration DESC) AS rank_in_employee
    FROM Employees_Details_1
) ranked
WHERE rank_in_employee <= 2;


-----Find employees who worked on the same project together
--Goal:
--List all pairs of employees who have worked together on the same project.
--For each pair, show:
--emp1_id, emp1_name
--emp2_id, emp2_name
--project_id
--✅ Notes:
--Do not show pairs like (A, A) → no self-pairing
--Do not show duplicate pairs → (A, B) and (B, A) should appear only once


select 
	distinct
	ep1.emp_id,
	e1.emp_name,
	ep2.emp_id,
	e2.emp_name,
	count (ep1.project_id) as Shared_Project_Count
from employee_projects ep1
	inner join employee_projects ep2
on ep2.project_id = ep1.project_id and ep1.emp_id < ep2.emp_id
	inner join employees e1
on e1.emp_id = ep1.emp_id
	inner join employees e2
on e2.emp_id = ep2.emp_id
group by ep1.emp_id, e1.emp_name, ep2.emp_id, e2.emp_name
having count (ep1.project_id) > 1;


-----Find top 3 employee pairs based on shared project count
--Show:
--emp1_id, emp1_name
--emp2_id, emp2_name
--shared_project_count
--Only top 3 pairs with the highest shared_project_count across all pairs.


WITH Employees_Details_1 AS
(
select 
	distinct
	ep1.emp_id as emp_id1,
	e1.emp_name as emp_name1,
	ep2.emp_id as emp_id2,
	e2.emp_name as emp_name2,
	count (ep1.project_id) as Shared_Project_Count
from employee_projects ep1
	inner join employee_projects ep2
on ep2.project_id = ep1.project_id and ep1.emp_id < ep2.emp_id
	inner join employees e1
on e1.emp_id = ep1.emp_id
	inner join employees e2
on e2.emp_id = ep2.emp_id
group by ep1.emp_id, e1.emp_name, ep2.emp_id, e2.emp_name
having count (ep1.project_id) > 1
),
Employees_Details_2 AS
(
select *,
ROW_NUMBER() OVER (ORDER BY ED1.Shared_Project_Count DESC) as Row_Num_
from Employees_Details_1 ED1
)
select * from Employees_Details_2 ED2
where ED2.Row_Num_ <= 3;


-----Find employees who have never worked on any project


SELECT e.emp_id, e.emp_name
FROM employees e
LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
WHERE ep.emp_id IS NULL;


-----Find departments with no projects assigned


SELECT d.department_id, d.department_name
FROM departments d
LEFT JOIN projects p ON d.department_id = p.department_id
WHERE p.department_id IS NULL;


-----Find Employee-Manager Chains
--Task: Write a recursive query to get:
--emp_id, emp_name, manager_id
--level (how deep in the hierarchy)
--top manager’s emp_id


WITH hierarchy AS (
    -- Anchor part: top-level managers
    SELECT emp_id, emp_name, manager_id, 1 AS level, emp_id AS top_manager
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive part: join employees reporting to managers
    SELECT e.emp_id, e.emp_name, e.manager_id, h.level + 1, h.top_manager
    FROM employees e
    INNER JOIN hierarchy h ON e.manager_id = h.emp_id
)
SELECT * FROM hierarchy;

-----