-- Урок 4. Объединение запросов, хранимые процедуры, триггеры, функции
-- 1. Создать VIEW на основе запросов, которые вavg_salary_by_dept_viewы сделали в ДЗ к уроку 3.

USE `employees`;
CREATE OR REPLACE VIEW `avg_salary_by_dept_view` AS
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
        s.from_date <= CURDATE()
            AND s.to_date > CURDATE()
    GROUP BY d.dept_name
    ORDER BY average_salary DESC;
    
-- DDL результата

   CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `employees`.`avg_salary_by_dept_view` AS
    SELECT 
        `d`.`dept_name` AS `dept_name`,
        AVG(`s`.`salary`) AS `average_salary`
    FROM
        (((`employees`.`employees` `e`
        JOIN `employees`.`dept_emp` `d_e` ON ((`e`.`emp_no` = `d_e`.`emp_no`)))
        JOIN `employees`.`departments` `d` ON ((`d_e`.`dept_no` = `d`.`dept_no`)))
        JOIN `employees`.`salaries` `s` ON ((`e`.`emp_no` = `s`.`emp_no`)))
    WHERE
        ((`s`.`from_date` <= CURDATE())
            AND (`s`.`to_date` > CURDATE()))
    GROUP BY `d`.`dept_name`
    ORDER BY `average_salary` DESC;

-- 2. Создать функцию, которая найдет менеджера по имени и фамилии.
-- Я предположил, что найти менеджера - это найти название его департамента, а там его точно найдут

CREATE DEFINER=`root`@`localhost` FUNCTION `find_dept_of_manager_by_first_and_last_name_function`(first_name_param VARCHAR(14), last_name_param VARCHAR(16)) RETURNS varchar(40) CHARSET utf8mb4
    READS SQL DATA
BEGIN
RETURN (SELECT 
    d.dept_name
FROM
    employees.dept_manager dm
        LEFT JOIN
    employees.employees e ON e.emp_no = dm.emp_no
        LEFT JOIN
    employees.departments d ON dm.dept_no = d.dept_no
WHERE
    from_date <= CURDATE()
        AND to_date > CURDATE()
        AND e.first_name = first_name_param
        AND e.last_name = last_name_param
LIMIT 1);
END

-- DDL результата:

USE `employees`;
DROP function IF EXISTS `find_dept_of_manager_by_first_and_last_name_function`;

DELIMITER $$
USE `employees`$$
CREATE FUNCTION `find_dept_of_manager_by_first_and_last_name_function` (first_name_param VARCHAR(14), last_name_param VARCHAR(16))
RETURNS VARCHAR(40)
READS SQL DATA
BEGIN
RETURN (SELECT 
    d.dept_name
FROM
    employees.dept_manager dm
        LEFT JOIN
    employees.employees e ON e.emp_no = dm.emp_no
        LEFT JOIN
    employees.departments d ON dm.dept_no = d.dept_no
WHERE
    from_date <= CURDATE()
        AND to_date > CURDATE()
        AND e.first_name = first_name_param
        AND e.last_name = last_name_param
LIMIT 1);
END$$

DELIMITER ;

-- evg-rudakov: "найти менеджера это найти его emp_no, но в целом вы работу сделали верно) спасибо)"

CREATE FUNCTION `find_emp_no_of_manager_by_first_and_last_name_function` (first_name_param VARCHAR(14), last_name_param VARCHAR(16))
RETURNS INT(11)
READS SQL DATA
BEGIN
RETURN (SELECT 
    e.emp_no
FROM
    employees.dept_manager dm
        LEFT JOIN
    employees.employees e ON e.emp_no = dm.emp_no
        LEFT JOIN
    employees.departments d ON dm.dept_no = d.dept_no
WHERE
    from_date <= CURDATE()
        AND to_date > CURDATE()
        AND e.first_name = first_name_param
        AND e.last_name = last_name_param);
END

-- DDL результата:

USE `employees`;
DROP function IF EXISTS `find_emp_no_of_manager_by_first_and_last_name_function`;

DELIMITER $$
USE `employees`$$
CREATE FUNCTION `find_emp_no_of_manager_by_first_and_last_name_function` (first_name_param VARCHAR(14), last_name_param VARCHAR(16))
RETURNS INT(11)
READS SQL DATA
BEGIN
RETURN (SELECT 
    e.emp_no
FROM
    employees.dept_manager dm
        LEFT JOIN
    employees.employees e ON e.emp_no = dm.emp_no
        LEFT JOIN
    employees.departments d ON dm.dept_no = d.dept_no
WHERE
    from_date <= CURDATE()
        AND to_date > CURDATE()
        AND e.first_name = first_name_param
        AND e.last_name = last_name_param);
END$$

DELIMITER ;

SELECT 
    *
FROM
    employees.dept_manager dm
        LEFT JOIN
    employees.employees e ON e.emp_no = dm.emp_no
        LEFT JOIN
    employees.departments d ON dm.dept_no = d.dept_no;

-- 3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.

CREATE DEFINER = CURRENT_USER TRIGGER `employees`.`pay_bonus` AFTER INSERT ON `employees` FOR EACH ROW
BEGIN
INSERT INTO employees.salaries VALUES(NEW.emp_no, 1000, CURDATE(), CURDATE());
END

DROP TRIGGER IF EXISTS `employees`.`pay_bonus`;

-- DDL результата:

DELIMITER $$
USE `employees`$$
CREATE DEFINER = CURRENT_USER TRIGGER `employees`.`pay_bonus` AFTER INSERT ON `employees` FOR EACH ROW
BEGIN
INSERT INTO employees.salaries VALUES(NEW.emp_no, 1000, CURDATE(), CURDATE());
END$$
DELIMITER ;

-- для проверки триггера
INSERT INTO employees.employees VALUES(555555, '1999-01-01', 'mock_first_nm', 'mock_last_nm', 'M', '2019-01-15');