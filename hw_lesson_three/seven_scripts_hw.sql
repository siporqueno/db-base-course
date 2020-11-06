-- База данных «Страны и города мира»:
-- 1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.

-- Город выбирается по id
SELECT 
    ci.id,
    important,
    ci.title AS city_name,
    area,
    r.title AS region_name,
    co.title AS country_name
FROM
    geodata._cities ci
        JOIN
    geodata._regions r ON ci.region_id = r.id
        JOIN
    geodata._countries co ON ci.country_id = co.id
WHERE
    ci.id = 96;
    
    -- Город выбирается по имени (в этом случае, может быть возвращен не один город или вообще 0)
SELECT 
    ci.id,
    important,
    ci.title AS city_name,
    area,
    r.title AS region_name,
    co.title AS country_name
FROM
    geodata._cities ci
        JOIN
    geodata._regions r ON ci.region_id = r.id
        JOIN
    geodata._countries co ON ci.country_id = co.id
WHERE
    ci.title = 'Кыштым';
    
-- 2. Выбрать все города из Московской области.

SELECT 
    c.id, important, c.title AS city_name, area
FROM
    geodata._cities c
        JOIN
    geodata._regions r ON c.region_id = r.id
WHERE
    r.title = 'Московская область';

-- База данных «Сотрудники»:
-- 1. Выбрать среднюю зарплату по отделам.

SELECT 
    d.dept_name, AVG(salary) AS average_salary
FROM
    employees.employees e
        JOIN
    employees.dept_emp d_e ON e.emp_no = d_e.emp_no
        JOIN
    employees.departments d ON d_e.dept_no = d.dept_no
        JOIN
    employees.salaries s ON e.emp_no = s.emp_no
WHERE
    s.to_date = '9999-01-01'
GROUP BY d.dept_name
ORDER BY average_salary DESC;

-- 2. Выбрать максимальную зарплату у сотрудника.
    
    SELECT 
    e.*, MAX(salary) AS max_salary
FROM
    employees.employees e
        LEFT JOIN
    employees.salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no
ORDER BY max_salary DESC;

-- 3. Удалить одного сотрудника, у которого максимальная зарплата.
-- решение

DELETE FROM employees.employees 
WHERE
    emp_no = (SELECT 
        emp_no
    FROM
        employees.salaries
    ORDER BY salary DESC
    LIMIT 1);
    
-- запросы для вставки модельных строк и проверки до/после действия запроса-решения
SELECT * FROM employees.employees ORDER BY emp_no DESC;
SELECT * FROM employees.salaries ORDER BY salary DESC;

INSERT INTO employees.employees VALUES(555555, '1999-01-01', 'mock_first_nm', 'mock_last_nm', 'M', '2019-01-15');
INSERT INTO employees.salaries VALUES(555555, 210000, '2001-03-22', '2002-03-22');
INSERT INTO employees.salaries VALUES(555555, 220000, '2002-03-22', '9999-01-01');

-- 4. Посчитать количество сотрудников во всех отделах.
-- Подсчет кол-ва сотрудников в каждом отделе (первый вариант понимания задачи)

SELECT 
    d.*, COUNT(e.emp_no) AS staff_no
FROM
    employees.employees e
        JOIN
    employees.dept_emp d_e ON e.emp_no = d_e.emp_no
        JOIN
    employees.departments d ON d_e.dept_no = d.dept_no
GROUP BY d.dept_no;

-- Подсчет общего кол-ва сотрудников во всех отделах (второй вариант понимания задачи)

SELECT 
    COUNT(e.emp_no) AS staff_no_in_all_departments
FROM
    employees.employees e
        JOIN
    employees.dept_emp d_e ON e.emp_no = d_e.emp_no
        JOIN
    employees.departments d ON d_e.dept_no = d.dept_no;

-- 5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.

SELECT 
    d.*,
    COUNT(e.emp_no) AS staff_no,
    SUM(salary) AS total_salary
FROM
    employees.salaries s
        JOIN
    employees.employees e ON s.emp_no = e.emp_no
        JOIN
    employees.dept_emp d_e ON e.emp_no = d_e.emp_no
        JOIN
    employees.departments d ON d_e.dept_no = d.dept_no
WHERE
    s.to_date = '9999-01-01'
GROUP BY d.dept_no
ORDER BY d.dept_no;