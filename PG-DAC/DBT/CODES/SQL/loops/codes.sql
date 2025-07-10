DELIMITER $$

CREATE PROCEDURE IncreaseSalaryByDept(IN p_dept_id INT)
BEGIN
    DECLARE emp INT DEFAULT 101;
    loop_label: LOOP
        IF emp > (SELECT MAX(emp_id) FROM employee) THEN
            LEAVE loop_label;
        END IF;
        IF (SELECT dept_id FROM employee WHERE emp_id = emp) = p_dept_id THEN
            UPDATE employee
            SET salary = salary * 1.10
            WHERE emp_id = emp;
        END IF;
        SET emp = emp + 1;
    END LOOP;
END $$

CREATE PROCEDURE InsertDummyEmployees(IN p_dept_id INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE next_emp_id INT DEFAULT 101;
    SET next_emp_id = (SELECT IFNULL(MAX(emp_id), 100) + 1 FROM employee);
    WHILE i <= 5 DO
        INSERT INTO employee (emp_id, emp_name, salary, dept_id)
        VALUES (next_emp_id, CONCAT('Dummy', i), 10000, p_dept_id);
        SET i = i + 1;
        SET next_emp_id = next_emp_id + 1;
    END WHILE;
END $$

CREATE PROCEDURE DeleteLowSalaryEmployees(IN p_salary_limit DECIMAL(10,2))
BEGIN
    DECLARE emp INT DEFAULT 101;
    DECLARE max_emp INT;
    SET max_emp = (SELECT MAX(emp_id) FROM employee);
    REPEAT
        IF emp > max_emp THEN
            LEAVE;
        END IF;
        IF (SELECT salary FROM employee WHERE emp_id = emp) < p_salary_limit THEN
            DELETE FROM employee WHERE emp_id = emp;
        END IF;
        SET emp = emp + 1;
    UNTIL emp > max_emp
    END REPEAT;
END $$

CREATE FUNCTION TotalSalaryByDept(p_dept_id INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(15,2) DEFAULT 0;
    DECLARE emp INT DEFAULT 101;
    DECLARE max_emp INT;
    SET max_emp = (SELECT MAX(emp_id) FROM employee);
    salary_loop: LOOP
        IF emp > max_emp THEN
            LEAVE salary_loop;
        END IF;
        IF (SELECT dept_id FROM employee WHERE emp_id = emp) = p_dept_id THEN
            SET total = total + (SELECT salary FROM employee WHERE emp_id = emp);
        END IF;
        SET emp = emp + 1;
    END LOOP;
    RETURN total;
END $$

CREATE FUNCTION CountHighEarners(p_salary_limit DECIMAL(10,2))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE count_high INT DEFAULT 0;
    DECLARE emp INT DEFAULT 101;
    DECLARE max_emp INT;
    SET max_emp = (SELECT MAX(emp_id) FROM employee);
    WHILE emp <= max_emp DO
        IF (SELECT salary FROM employee WHERE emp_id = emp) > p_salary_limit THEN
            SET count_high = count_high + 1;
        END IF;
        SET emp = emp + 1;
    END WHILE;
    RETURN count_high;
END $$

DELIMITER ;
