/*1. Create the database with all the tables, keys and constraints. Add at least five employees, ten
projects and three departments.*/

DROP DATABASE IF EXISTS ejercicio;
CREATE DATABASE ejercicio;
\c ejercicio;

CREATE TABLE IF NOT EXISTS employees(
  employee_id   NUMERIC(8),
  first_name    VARCHAR(30),
  last_name    VARCHAR(30),
  birthdate    DATE,
  address   VARCHAR(50),
  gender    CHAR,
  salary    NUMERIC,
  supervisor_id   NUMERIC(8),
  department_id   NUMERIC(8),
  PRIMARY KEY (employee_id),
  FOREIGN KEY (supervisor_id)
    REFERENCES employees (employee_id) 
);

--TENGO QUE ANADIR DEPARTMENT ID DESPUES YA QUE NO ESTAN TODAVIA SU TABLA CREADAS--

CREATE TABLE IF NOT EXISTS projects(
  project_id    NUMERIC(8),
  name    VARCHAR(30),
  place   VARCHAR(50),
  budget    NUMERIC,
  department_id   NUMERIC(8),
  PRIMARY KEY (project_id)
);

--TENGO QUE ANADIR DEPARTMENT ID DESPUES YA QUE NO ESTAN TODAVIA SUS TABLAS CREADAS--

CREATE TABLE IF NOT EXISTS departments(
  department_id   NUMERIC(8),
  name  VARCHAR(30),
  manager_id    NUMERIC(8),
  PRIMARY KEY (department_id),
  FOREIGN KEY (manager_id)
    REFERENCES employees (employee_id)
);

CREATE TABLE IF NOT EXISTS works_in(
  employee_id   NUMERIC(8),
  project_id    NUMERIC(8),
  total_time    NUMERIC,
  PRIMARY KEY (employee_id, project_id),
  FOREIGN KEY (employee_id)
    REFERENCES employees (employee_id),
  FOREIGN KEY (project_id)
    REFERENCES projects (project_id)
);

INSERT INTO employees (VALUES
  (11111111, 'Pedro', 'Lopez Amezcua', '06/05/1995', 'Rumania', 'H', '1300', NULL, 1),
  (22222222, 'María', 'García Hernandez', '04/07/1999', 'Eslovaquia', 'M', '1100', NULL, 2),
  (33333333, 'Pablo', 'Campos Lopez', '05/09/1993', 'Sydney', 'H', '1500', 22222222, 3),
  (44444444, 'Ana', 'Muros Linares', '01/01/2000', 'Francia', 'M', '1300', 11111111, 3),
  (55555555, 'José', 'Trujillo Zafon', '09/03/1990', 'Solaria', 'H', NULL, 11111111, 2)
);

INSERT INTO projects (VALUES
  (1, 'Project1', 'Laboratory', 10, 1),
  (2, 'Project2', 'Laboratory', 20, 1),
  (3, 'Project3', 'Research', 30, 2),
  (4, 'Project4', 'Laboratory', 40, 3),
  (5, 'Project5', 'Laboratory', 50, 1),
  (6, 'Project6', 'Laboratory', 60, 3),
  (7, 'Project7', 'Laboratory', 70, 3),
  (8, 'Project8', 'Research', 80, 2),
  (9, 'Project9', 'Research', 90, 2),
  (10, 'Project10', 'Research', 100, 1)
);

INSERT INTO departments (VALUES
  (1, 'Marketing', 11111111),
  (2, 'Finances', 22222222),
  (3, 'Research', 33333333)
);

INSERT INTO works_in (VALUES
  (11111111, 1, '30'),
  (11111111, 2, '45'),
  (11111111, 3, '60'),
  (22222222, 4, '25'),
  (22222222, 5, '75'),
  (22222222, 6, '80'),
  (33333333, 7, '70'),
  (44444444, 8, '50'),
  (44444444, 9, '80'),
  (55555555, 10, '90')
);

--Aniado las claves foraneas que faltan

ALTER TABLE employees 
  ADD constraint fk_employees 
    FOREIGN KEY (department_id)
      REFERENCES departments (department_id);

ALTER TABLE projects 
  ADD constraint fk_projects 
    FOREIGN KEY (department_id)
      REFERENCES departments (department_id);

--2. Get the salary of each employee with his or her name.
SELECT salary, first_name, last_name FROM employees;

--3. Get all the different salaries of the employees.
SELECT salary FROM employees;

--4. Find out what employees are working for the department number 2.
SELECT first_name, last_name, department_id FROM employees NATURAL JOIN departments WHERE department_id=2;

--5. Find out all the employees from the departments 1 and 2.
SELECT first_name, last_name, department_id FROM employees NATURAL JOIN departments WHERE department_id=2 OR department_id=1;

--6. Find out all the employees with unknown salary.
SELECT first_name, last_name, salary FROM employees WHERE salary IS NULL;

--7. Look for all the employees from Sidney
SELECT first_name, last_name, address address FROM employees WHERE address LIKE 'Sydney';

--8. Look for all the employees from towns starting with S (e.g. Stockholm, Sidney, etc.)
SELECT first_name, last_name, address FROM employees WHERE address LIKE 'S%';

--9. What employees have no supervisor?
SELECT first_name, last_name, supervisor_id FROM employees WHERE supervisor_id IS NULL;

--10. What employees are supervisors?
SELECT first_name, last_name, supervisor_id FROM employees WHERE supervisor_id IS NOT NULL;

--11. Find out all the employees from the ‘Research’ department.
SELECT first_name, last_name, name FROM employees NATURAL JOIN departments WHERE name='Research';

--12. Find out all the employees from the ‘Research’ department, along with the department data.
SELECT first_name, last_name, departments.* FROM employees INNER JOIN departments ON departments.name='Research'
    WHERE departments.department_id= employees.department_id;

--13. Get the list with all the employees along with their supervisors
SELECT emp.first_name, emp.last_name, sup.first_name, sup.last_name FROM employees AS emp, employees AS sup 
    WHERE emp.supervisor_id= sup.employee_id;

--14. Get the combinations of employees with their departments.
SELECT first_name, last_name, name FROM employees INNER JOIN departments ON employees.department_id= departments.department_id;

--15. Get the list of all the departments along with the names of their employees. The result must
--be sorted: #d8fb5f
--◦ In descending order for the department name.
--◦ In ascending order for employee surname.
SELECT departments.*, first_name, last_name FROM departments INNER JOIN employees
     ON departments.department_id = employees.department_id ORDER BY name DESC, last_name ASC;

--16. Calculate the total salaries, the higest salary, the lowest one and the average salary for all the
--employees.
SELECT salary FROM employees;
SELECT max(salary) FROM employees;
SELECT min(salary) FROM employees;
SELECT avg(salary) FROM employees; 

--17. Calculate the total salaries, the higest salary, the lowest one and the average salary for all the
--employees from the ‘Research’ department.
SELECT salary FROM employees NATURAL JOIN departments WHERE departments.name= 'Research';
SELECT max(salary) FROM employees NATURAL JOIN departments WHERE departments.name = 'Research';
SELECT min(salary) FROM employees NATURAL JOIN departments WHERE departments.name = 'Research';
SELECT avg(salary) FROM employees NATURAL JOIN departments WHERE departments.name = 'Research';

--18. How many people work in the ‘Research department’?
SELECT count(*) FROM employees NATURAL JOIN departments WHERE departments.name='Research';

--19. How many different salaries are in the database?
SELECT DISTINCT count(salary) FROM employees;

--20. What’s the total budget for each department?
SELECT sum(budget) FROM projects INNER JOIN departments ON projects.department_id= departments.department_id 
    WHERE departments.name='Marketing';

-- SELECT salary FROM employees
-- WHERE

-- SELECT salary FROM employees;

--SELECT salary FROM employees ORDER BY ASC/DESC

--SELECT DISTINCT salary FROM employees ORDER BY ASC/DESC

--SELECT salary FROM employees WHERE gender = 'M' 

--SELECT 'amigoscode' <> 'AMIGOSCODE 

--SELECT * FROM projects WHERE country_of_birth IN ('Brazil')

-- SELECT * FROM employee WHERE birthdate BETWEEN DATE '2000-01-01' AND '2002-01-01';

-- SELECT * FROM employee WHERE address LIKE '%ito'; -- --TIENE QUE SER COMO ACABA NO COMO EMPIEZA
-- SELECT * FROM employee WHERE address LIKE 'Calle%'; -- --TIENE QUE SER COMO EMPIEZA NO COMO ACABA

-- SELECT gender, COUNT(*) FROM employees GROUP BY gender;

--SELECT gender, COUNT(*) FROM employees GROUP BY gender HAVING COUNT(*) > 1 ORDER BY gender;
