--CREATE TABLE employees (
--    emp_id INT PRIMARY KEY,
--    emp_name VARCHAR(50),
--    department VARCHAR(50),
--    salary INT,
--    hire_date DATE
--);


--INSERT INTO employees (emp_id, emp_name, department, salary, hire_date) VALUES
--(1, 'Alice', 'HR', 60000, '2019-02-15'),
--(2, 'Bob', 'IT', 80000, '2018-05-12'),
--(3, 'Carol', 'Finance', 75000, '2020-01-20'),
--(4, 'Dave', 'IT', 90000, '2017-09-10'),
--(5, 'Eva', 'HR', 85000, '2016-06-01'),
--(6, 'Frank', 'Marketing', 67000, '2021-03-25'),
--(7, 'Grace', 'Finance', 82000, '2018-11-30'),
--(8, 'Harry', 'IT', 95000, '2015-07-14'),
--(9, 'Irene', 'Marketing', 64000, '2020-08-18'),
--(10, 'John', 'HR', 72000, '2022-01-05'),
--(11, 'Kate', 'Finance', 71000, '2019-12-01'),
--(12, 'Leo', 'Sales', 78000, '2021-05-17'),
--(13, 'Mia', 'Sales', 69000, '2022-02-28'),
--(14, 'Nathan', 'IT', 88000, '2023-04-10'),
--(15, 'Olivia', 'HR', 77000, '2023-07-22');


-----Find employees whose salary is greater than the average salary of all employees.


SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);


-----Find the employee(s) with the highest salary using a subquery.


Select * 
from employees
where salary = (Select max(salary) from employees);


-----Find all employees not working in the department of the highest-paid employee.


SELECT emp_id, emp_name, department, salary
FROM (
    SELECT *,
        MAX(salary) OVER () AS max_salary
    FROM employees
) temp
WHERE department NOT IN (
    SELECT DISTINCT department
    FROM employees
    WHERE salary = (
        SELECT MAX(salary) FROM employees
    )
)
ORDER BY salary DESC;


-----Alternate Way Using CTE (Cleaner and Reusable):


WITH highest_paid_dept AS (
    SELECT department
    FROM employees
    WHERE salary = (SELECT MAX(salary) FROM employees)
)
SELECT emp_id, emp_name, department, salary
FROM employees
WHERE department NOT IN (SELECT department FROM highest_paid_dept)
ORDER BY salary DESC;


-----Adding new column.


--ALTER TABLE employees
--ADD performance_score INT;


-----Update records as per the new column.


--UPDATE employees SET performance_score = 85 WHERE emp_id = 1;
--UPDATE employees SET performance_score = 92 WHERE emp_id = 2;
--UPDATE employees SET performance_score = 88 WHERE emp_id = 3;
--UPDATE employees SET performance_score = 95 WHERE emp_id = 4;
--UPDATE employees SET performance_score = 78 WHERE emp_id = 5;
--UPDATE employees SET performance_score = 83 WHERE emp_id = 6;
--UPDATE employees SET performance_score = 76 WHERE emp_id = 7;
--UPDATE employees SET performance_score = 97 WHERE emp_id = 8;
--UPDATE employees SET performance_score = 68 WHERE emp_id = 9;
--UPDATE employees SET performance_score = 80 WHERE emp_id = 10;
--UPDATE employees SET performance_score = 74 WHERE emp_id = 11;
--UPDATE employees SET performance_score = 91 WHERE emp_id = 12;
--UPDATE employees SET performance_score = 89 WHERE emp_id = 13;
--UPDATE employees SET performance_score = 90 WHERE emp_id = 14;
--UPDATE employees SET performance_score = 77 WHERE emp_id = 15;


-----Track high-performing employees who have performance scores higher than the average performance score of all employees. 
--And whose salaries are below the maximum salary in the company (because they want to retain undervalued top talent).


SELECT *
FROM employees
WHERE performance_score > (
        SELECT AVG(performance_score) FROM employees
    )
  AND salary < (
        SELECT MAX(salary) FROM employees
    );


-----Which employees were hired earlier than the average hire date of employees in their respective departments?


SELECT 
    e.emp_id,
    e.emp_name,
    e.department,
    e.salary,
    e.hire_date,
    -- Subquery to calculate average hire date for each department
    (
        SELECT 
            CAST(DATEADD(DAY, AVG(CAST(CONVERT(DATETIME, hire_date) AS INT) - DATEDIFF(DAY, '1900-01-01', '1900-01-01')), '1900-01-01') AS DATETIME)
        FROM 
            employees
        WHERE 
            department = e.department
    ) AS avg_hire_date
FROM 
    employees e
WHERE 
    e.hire_date < (
        SELECT 
            CAST(DATEADD(DAY, AVG(CAST(CONVERT(DATETIME, hire_date) AS INT) - DATEDIFF(DAY, '1900-01-01', '1900-01-01')), '1900-01-01') AS DATETIME)
        FROM 
            employees
        WHERE 
            department = e.department
    )
ORDER BY 
    e.department, e.hire_date;


-----HR wants to find employees who earn the same salary as someone in the IT department, regardless of their own department.


SELECT emp_id, emp_name, department, salary
FROM employees
WHERE salary IN (
    SELECT salary
    FROM employees
    WHERE department = 'IT'
);


-----List all employees whose salary is higher than any employee in the HR department. (Using Multi Line Sub Queries)


SELECT * 
FROM employees 
WHERE salary > ANY (
    SELECT salary 
    FROM employees 
    WHERE department = 'HR'
);


-----Find employees who belong to departments where the average salary is more than ₹75,000.


SELECT * 
FROM employees 
WHERE department IN (
    SELECT department 
    FROM employees 
    GROUP BY department
    HAVING AVG(salary) > 75000
);


-----Find all employees whose salary is higher than the average salary of each department that has more than 3 employees.


Select * 
	from employees 
	where salary > Any 
(
Select AVG(salary)
	from employees
	group by department
	having count(*) > 3
	)


-----HR wants to know how each employee's salary compares to the average salary of all employees


SELECT 
    emp_id,
    emp_name,
    salary,
    (SELECT AVG(salary) FROM employees) AS avg_salary,
    salary - (SELECT AVG(salary) FROM employees) AS diff_from_avg
FROM employees;


-----the average hire_date across all employees (as a scalar subquery)


Select 
emp_id,
emp_name,
department,
hire_date,
(Select CAST(DATEADD(DAY, AVG(CAST(CONVERT(DATETIME, hire_date) AS INT) - DATEDIFF(DAY, '1900-01-01', '1900-01-01')), '1900-01-01') AS DATETIME) from employees) As AVG_HIRE_DATE
from employees


-----Show employees who were hired before the average hire date of the company 
--AND have a salary below the company’s average salary.


SELECT 
    emp_id,
    emp_name,
    department,
    hire_date,
    salary,
    (SELECT AVG(salary) FROM employees) AS AVG_SALARY,
    (
        SELECT 
            CAST(DATEADD(DAY, 
                AVG(CAST(CONVERT(DATETIME, hire_date) AS INT) - 
                DATEDIFF(DAY, '1900-01-01', '1900-01-01')), 
            '1900-01-01') AS DATETIME)
        FROM employees
    ) AS AVG_HIRE_DATE
FROM 
    employees
WHERE 
    salary < (SELECT AVG(salary) FROM employees)
    AND hire_date < (
        SELECT 
            CAST(DATEADD(DAY, 
                AVG(CAST(CONVERT(DATETIME, hire_date) AS INT) - 
                DATEDIFF(DAY, '1900-01-01', '1900-01-01')), 
            '1900-01-01') AS DATETIME)
        FROM employees
    )
ORDER BY 
    hire_date;


-----Find all employees who earn more than the average salary in their own department.


SELECT e1.emp_id, e1.emp_name, e1.department, e1.salary
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e1.department
);


-----List employees who were hired before the average hire date of their department.


select e1.emp_id, e1.emp_name, e1.department, e1.hire_date
from employees e1
where hire_date < (
	select 
	CAST(DATEADD(DAY, 
                AVG(CAST(CONVERT(DATETIME, hire_date) AS INT) - 
                DATEDIFF(DAY, '1900-01-01', '1900-01-01')), 
            '1900-01-01') AS DATETIME)
			from employees e2
			where e2.department = e1.department
		)
	
	
-----Find Departments That Have at Least One Employee with a Salary Above 90,000


SELECT DISTINCT department
FROM employees e1
WHERE EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.salary > 90000
)


-----Identify departments that have at least one employee hired before 2018 and earning more than ₹80,000


select 
	distinct department 
from employees e1
where EXISTS (
	select e2.department
	from employees e2
	where e2.department=e1.department
	and year(e2.hire_date) < 2018
	and e2.salary > 80000
	)


-----Departments Have at least one employee who earns more than the average salary of their department 
--AND that employee was hired after 2020


SELECT DISTINCT e1.department
FROM employees e1
WHERE EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.salary > (
            SELECT AVG(e3.salary)
            FROM employees e3
            WHERE e3.department = e2.department
      )
      AND YEAR(e2.hire_date) > 2020
);


-----list of departments where at least one junior employee (hired after 2020) earns more than 
--a senior employee (hired before 2015) in the same department.


SELECT DISTINCT e1.department 
FROM employees e1
WHERE EXISTS (
    SELECT 1 
    FROM employees e2
    WHERE e2.department = e1.department
      AND YEAR(e2.hire_date) > 2020 -- junior
      AND EXISTS (
          SELECT 1 
          FROM employees e3
          WHERE e3.department = e2.department
            AND YEAR(e3.hire_date) < 2015 -- senior
            AND e2.salary > e3.salary     -- junior earning more than senior
      )
)


-----To find departments where there is at least one high-performing employee (performance score > 90) 
--who earns less than the department's average salary.


select distinct department 
	from employees e1
	where exists (
		select 1
		from employees e2
		where e2.department = e1.department
		and e2.performance_score > 90
		and e2.salary < (
			select AVG(e3.salary) 
			from employees e3
			where e3.department=e2.department)
			)

-----List the names and departments of employees who belong to departments where:
--At least one employee has a performance score above 85
--AND that high-performing employee's salary is below the department's average
--AND the department has more than 3 employees hired before 2020


SELECT DISTINCT e1.emp_name, e1.department
FROM employees e1
WHERE EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.performance_score > 85
      AND e2.salary < (
          SELECT AVG(e3.salary)
          FROM employees e3
          WHERE e3.department = e2.department
      )
      AND (
          SELECT COUNT(*)
          FROM employees e4
          WHERE e4.department = e2.department
            AND e4.hire_date < '2020-01-01'
      ) > 3
);


-----You need to find the names and departments of employees who belong to departments where:
-- 1) There is at least one employee whose:
--Hire year is before 2015
--AND their salary is greater than the average salary of all employees hired after 2018 in the same department
-- 2) AND that department has at least 2 employees with a performance score above 90


SELECT DISTINCT e1.emp_name, e1.department
FROM employees e1
WHERE EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department = e1.department
      AND YEAR(e2.hire_date) < 2015
      AND e2.salary > (
          SELECT AVG(e3.salary)
          FROM employees e3
          WHERE e3.department = e2.department
            AND YEAR(e3.hire_date) > 2018
      )
)
AND (
    SELECT COUNT(*)
    FROM employees e4
    WHERE e4.department = e1.department
      AND e4.performance_score > 90
) >= 2;


-----Find departments where no employee earns more than the department’s average salary


SELECT DISTINCT e1.department
FROM employees e1
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department = e1.department
    AND e2.salary > (
        SELECT AVG(e3.salary)
        FROM employees e3
        WHERE e3.department = e2.department
    )
);

select * from employees


-----Data deleted and re-inserted with updated details to test more real world scenarios


--CREATE TABLE employees (
--    emp_id INT,
--    emp_name VARCHAR(50),
--    department VARCHAR(50),
--    salary INT,
--    hire_date DATE,
--    performance_score INT
--);


--INSERT INTO employees (emp_id, emp_name, department, salary, hire_date, performance_score) VALUES
--(1, 'Alice', 'HR', 60000, '2019-02-15', 85),
--(2, 'Bob', 'IT', 80000, '2018-05-12', 92),
--(3, 'Carol', 'Finance', 75000, '2020-01-20', 88),
--(4, 'Dave', 'IT', 90000, '2017-09-10', 95),
--(5, 'Eva', 'HR', 85000, '2016-06-01', 78),
--(6, 'Frank', 'Marketing', 67000, '2021-03-25', 83),
--(7, 'Grace', 'Finance', 82000, '2018-11-30', 76),
--(8, 'Harry', 'IT', 95000, '2015-07-14', 97),
--(9, 'Irene', 'Marketing', 64000, '2020-08-18', 68),
--(10, 'John', 'HR', 72000, '2022-01-05', 80),
--(11, 'Kate', 'Finance', 71000, '2019-12-01', 74),
--(12, 'Leo', 'Sales', 78000, '2021-05-17', 91),
--(13, 'Mia', 'Sales', 69000, '2022-02-28', 89),
--(14, 'Nathan', 'IT', 88000, '2023-04-10', 90),
--(15, 'Olivia', 'HR', 77000, '2023-07-22', 77);


-----Return department names where no employee in that department has a performance score of 80 or less.


SELECT DISTINCT e1.department
FROM employees e1
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.performance_score <= 80
);


-----List the employees who belong to departments where no one hired before 2019 has a performance score below 85.


SELECT emp_id, emp_name, department, hire_date, performance_score
FROM employees e1
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.hire_date < '2019-01-01'
      AND e2.performance_score < 85
);


-----List all employees who are the only ones in their department hired after 2020 — i.e., 
--no other employee from the same department was hired after 2020.
--So, we want to include an employee only if:
--They were hired after 2020, and
--No one else from their department was also hired after 2020.


SELECT emp_id, emp_name, department, hire_date
FROM employees e1
WHERE hire_date > '2020-12-31'
  AND NOT EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.emp_id <> e1.emp_id
      AND e2.hire_date > '2020-12-31'
);


-----List the departments that do not have any employee who:
--Has a performance score below 75, and
--Was hired before 2019, and
--Has a salary above the department’s average


SELECT DISTINCT department
FROM employees e1
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.performance_score < 75
      AND e2.hire_date < '2019-01-01'
      AND e2.salary > (
          SELECT AVG(salary)
          FROM employees e3
          WHERE e3.department = e2.department
      )
);


-----List departments where no employee has both:
--A performance score above 90
--AND a salary greater than the department's average salary


SELECT DISTINCT e1.department
FROM employees e1
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.performance_score > 90
      AND e2.salary > (
          SELECT AVG(e3.salary)
          FROM employees e3
          WHERE e3.department = e2.department
      )
);


-----Find employees whose salary is greater than at least one department's average salary, among departments with more than 2 employees.

SELECT *
FROM employees
WHERE salary > ANY (
    SELECT AVG(salary)
    FROM employees
    GROUP BY department
    HAVING COUNT(*) > 2
);


--Using SOME


SELECT *
FROM employees
WHERE salary > SOME (
    SELECT AVG(salary)
    FROM employees
    GROUP BY department
    HAVING COUNT(*) > 2
);


-----Find employees whose salary is greater than the average salary of all departments with more than 2 employees.

SELECT *
FROM employees
WHERE salary > ALL (
    SELECT AVG(salary)
    FROM employees
    GROUP BY department
    HAVING COUNT(*) > 2
);


-----Find employees who earn more than all other employees in their department hired before 2020.

SELECT emp_id, emp_name, department, salary, hire_date
FROM employees e1
WHERE salary > ALL (
    SELECT e2.salary
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.hire_date < '2020-01-01'
      AND e2.emp_id <> e1.emp_id
);

-----Using Any

SELECT emp_id, emp_name, department, salary, hire_date
FROM employees e1
WHERE salary > ANY (
    SELECT e2.salary
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.hire_date < '2020-01-01'
      AND e2.emp_id <> e1.emp_id
);


-----Find departments where all employees hired before 2020 have a salary above the average salary of their department, 
--only if the department also has at least one employee with a performance score below 75.


SELECT DISTINCT e1.department
FROM employees e1
WHERE EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.performance_score < 75
)
AND 'TRUE' = ALL (
    SELECT 
        CASE 
            WHEN e3.salary > (
                SELECT AVG(e4.salary)
                FROM employees e4
                WHERE e4.department = e3.department
            ) THEN 'TRUE'
            ELSE 'FALSE'
        END
    FROM employees e3
    WHERE e3.department = e1.department
      AND e3.hire_date < '2020-01-01'
);


----- Find all departments where:
-- At least one employee earns below the department average, and
-- All employees with a performance_score > 90 have a hire_date after 2019."


SELECT DISTINCT e1.department
FROM employees e1
WHERE EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.salary < (
          SELECT AVG(e3.salary)
          FROM employees e3
          WHERE e3.department = e2.department
      )
)
AND 'TRUE' = ALL (
    SELECT 
        CASE 
            WHEN e4.hire_date > '2019-12-31' THEN 'TRUE'
            ELSE 'FALSE'
        END
    FROM employees e4
    WHERE e4.department = e1.department
      AND e4.performance_score > 90
);

-----Find all departments where:
--There exists at least one employee whose salary is higher than the average salary of their department.
--All employees in the department with a performance score below 85 were hired before 2020.
--The department has at least one employee with a performance score > 90."**

select distinct department 
from employees e1
where exists (
		select 1
		from employees e2
		where e2.department = e1.department
		and e2.salary > ( select avg (e3.salary)
							from employees e3
							where e3.department = e2.department))
	and 'TRUE' = ALL ( select
						case
						when
						year(e4.hire_date) > 2020
						then 'TRUE'
						else 'FALSE'
						end
						from employees e4
						where e4.department = e1.department
						and e4.performance_score > 85)
	and exists (select 1 
				from employees e5
				where e5.department = e1.department
				and e5.performance_score  > 90)


-----Find all departments where the average salary of employees who joined after 2018 is greater than 75,000, 
--and there is at least one employee in that department with a performance score > 90.


SELECT e.department, AVG(e.salary) AS avg_recent_salary
FROM employees e
WHERE YEAR(e.hire_date) > 2018
GROUP BY e.department
HAVING AVG(e.salary) > 75000
   AND EXISTS (
       SELECT 1
       FROM employees e2
       WHERE e2.department = e.department
         AND e2.performance_score > 90
   );


-----Show departments that have more than 2 employees with average salary above 75,000,
--and at least one high performer (performance score > 90), using a JOIN and HAVING.


SELECT d.department, COUNT(e.emp_id) AS employee_count, AVG(e.salary) AS avg_salary
FROM employees e
JOIN (
    SELECT department
    FROM employees
    GROUP BY department
    HAVING COUNT(*) > 2
) d ON e.department = d.department
GROUP BY d.department
HAVING AVG(e.salary) > 75000
   AND EXISTS (
       SELECT 1
       FROM employees e2
       WHERE e2.department = d.department
         AND e2.performance_score > 90
   );

---

--CREATE TABLE departments (
--    department_id INT,
--    department_name VARCHAR(50),
--    manager_id INT  -- Refers to emp_id in employees
--);

--INSERT INTO departments (department_id, department_name, manager_id) VALUES
--(1, 'HR', 5),         -- Eva
--(2, 'IT', 8),         -- Harry
--(3, 'Finance', 7),    -- Grace
--(4, 'Marketing', 6),  -- Frank
--(5, 'Sales', 12);     -- Leo

-----The department must exist in the departments table.
--The average performance score of the department must be greater than 85.
--All employees in the department with performance_score > 90 must have been hired after 2018.
--The department should have at least 3 employees.
--Include only those departments where at least one employee has a salary above the average salary of their department.


SELECT 
    e1.department,
    AVG(e1.performance_score) AS avg_performance,
    COUNT(*) AS total_employees
FROM employees e1
JOIN departments d
    ON d.department_name = e1.department
GROUP BY e1.department
HAVING 
    -- Condition 1: Average performance score > 85
    AVG(e1.performance_score) > 85

    -- Condition 2: At least 3 employees in the department
    AND COUNT(*) >= 3

    -- Condition 3: All high performers (score > 90) hired after 2018
    AND 'TRUE' = ALL (
        SELECT 
            CASE 
                WHEN YEAR(e2.hire_date) > 2018 THEN 'TRUE'
                ELSE 'FALSE'
            END
        FROM employees e2
        WHERE e2.department = e1.department
        AND e2.performance_score >  90
    )

    -- Condition 4: At least one person with salary > department average
    AND EXISTS (
        SELECT 1
        FROM employees e3
        WHERE e3.department = e1.department
        AND e3.salary > (
            SELECT AVG(e4.salary)
            FROM employees e4
            WHERE e4.department = e1.department
        )
    )


-----

---- IT Department (4 Employees, all meet conditions)
--INSERT INTO employees (emp_id, emp_name, department, salary, hire_date, performance_score) VALUES
--(16, 'Arjun', 'IT', 97000, '2020-01-10', 91),
--(17, 'Bhavna', 'IT', 99000, '2021-03-12', 95),
--(18, 'Chirag', 'IT', 85000, '2022-08-18', 90),
--(19, 'Deepika', 'IT', 88000, '2023-06-05', 98);

---- Sales Department (3 Employees, all meet conditions)
--INSERT INTO employees (emp_id, emp_name, department, salary, hire_date, performance_score) VALUES
--(20, 'Esha', 'Sales', 85000, '2020-04-10', 91),
--(21, 'Farhan', 'Sales', 90000, '2021-05-17', 92),
--(22, 'Gita', 'Sales', 87000, '2022-07-22', 87);

---- HR Department (Fails some conditions)
--INSERT INTO employees (emp_id, emp_name, department, salary, hire_date, performance_score) VALUES
--(23, 'Harish', 'HR', 70000, '2016-03-11', 78),
--(24, 'Ishita', 'HR', 76000, '2017-10-19', 82);

---- Finance Department (Less than 3 employees, won't show up)
--INSERT INTO employees (emp_id, emp_name, department, salary, hire_date, performance_score) VALUES
--(25, 'Jatin', 'Finance', 79000, '2020-12-01', 89);

-----Increase salary by 10% only for those employees whose salary is below the average salary of their department.


UPDATE e
SET e.salary = e.salary * 1.10
FROM employees e
WHERE e.salary < (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e.department
);


SELECT emp_id, emp_name, department, salary
FROM employees
ORDER BY department, salary;


-----Delete Employees with Salary Below Department Average AND Performance Below 75


DELETE FROM employees
WHERE salary < (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = employees.department
)
AND performance_score < 75;

-----Insert High Performers into a New Table


CREATE TABLE top_performers (
    emp_id INT,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    performance_score INT
);


INSERT INTO top_performers (emp_id, emp_name, department, salary, performance_score)
SELECT emp_id, emp_name, department, salary, performance_score
FROM employees
WHERE performance_score > (
    SELECT AVG(performance_score)
    FROM employees
);


-----how we can rewrite a subquery as a join to see the performance difference.

---Using Subquery (Not Optimized)


SELECT emp_id, emp_name, salary
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department = e1.department
);


---Using JOIN (Optimized)


SELECT e1.emp_id, e1.emp_name, e1.salary
FROM employees e1
JOIN (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
) e2 ON e1.department = e2.department
WHERE e1.salary > e2.avg_salary;


-----