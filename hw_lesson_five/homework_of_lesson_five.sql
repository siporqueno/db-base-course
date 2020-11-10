-- Урок 5. Транзакции и оптимизация запросов
-- 1. Реализовать практические задания на примере других таблиц и запросов.

-- Смотри файлы task_1_screen_1.jpg и task_1_screen_2.jpg 

-- 2. Подумать, какие операции являются транзакционными, и написать несколько примеров с транзакционными запросами.

-- Первый пример транзакции - это взятие на работу.
BEGIN;
-- Включить в список сотрудников
INSERT INTO employees.employees VALUES(555555, '1999-01-01', 'mock_first_nm', 'mock_last_nm', 'M', '2019-01-15');
-- Дать должность
INSERT INTO employees.titles VALUES(555555, 'Engineer', CURDATE(), '9999-01-01');
-- Зачислить в отдел
INSERT INTO employees.dept_emp VALUES(555555, 'd004', CURDATE(), '9999-01-01');
-- Установить зарплату с завтрашнего дня (Сегодня наш триггер ему уже начислил бонус)
INSERT INTO employees.salaries VALUES(555555, 50000, CURDATE()+1, '9999-01-01');
COMMIT;

-- Второй пример транзакции - перевод сотрудника в другой отдел
BEGIN;
-- Поменять крайнюю дату нахождения в текущем отделе с 9999-01-01 на текущую дату
UPDATE employees.dept_emp SET to_date=CURDATE() WHERE emp_no=555555;
-- Включить сотрудника в новый отдел с текущей даты
INSERT INTO employees.dept_emp VALUES(555555, 'd006', CURDATE(), '9999-01-01');
COMMIT;

-- Аналогичными примерами транзакций являются, на мой взгляд, изменение зарплаты сотруднику и изменение его должности.
-- ROLLBACK после второго примера не дает никакого эффекта. Не могу понять почему.

-- Команды для проверки
SELECT * FROM employees.employees WHERE emp_no = 555555;
DELETE FROM employees.employees WHERE emp_no = 555555;
SELECT * FROM employees.titles WHERE emp_no = 555555;
DELETE FROM employees.titles WHERE emp_no = 555555;
SELECT * FROM employees.dept_emp WHERE emp_no = 555555;
DELETE FROM employees.dept_emp WHERE emp_no = 555555;
SELECT * FROM employees.salaries WHERE emp_no = 555555;
DELETE FROM employees.salaries WHERE emp_no = 555555;

-- 3. Проанализировать несколько запросов с помощью EXPLAIN.

-- Первый запрос
SELECT 
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
        AND e.first_name = 'Vishwani'
        AND e.last_name = 'Minakawa';
        
-- Смотри файлы task_3_screen_1.jpg и task_3_screen_2.jpg . Поскольку Query cost маленький (6.51), вряд ли тут что-то стоит улучшать.

-- Второй запрос

SELECT 
    e.first_name
FROM
    employees.employees e
        JOIN
    employees.dept_emp de ON e.emp_no = de.emp_no
        JOIN
    employees.departments d ON de.dept_no = d.dept_no
WHERE
    d.dept_name = 'Production'
        AND e.first_name LIKE '%va%'
        AND de.from_date <= CURDATE()
        AND de.to_date > CURDATE();

-- Смотри файлы task_3_screen_3.jpg, task_3_screen_4.jpg, task_3_screen_5.jpg, task_3_screen_6.jpg .
-- Добавление индекса на first_name в таблице employees не помогло никак (Query cost остался более 41 тысячи),
-- поскольку все равно каждая строка в этой таблице сравнивалась по этому полю с условием '%va%'.
-- Затем я ввел еще два условия de.from_date <= CURDATE() AND de.to_date > CURDATE(); с целью отсеять, только людей,
-- работающих сейчас. Это улучшило Query cost более, чем в два раза - до 18 тысяч.