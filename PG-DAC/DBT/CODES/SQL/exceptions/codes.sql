DELIMITER $$

CREATE PROCEDURE GetEmployeeSalary(IN emp_id INT)
BEGIN
    DECLARE emp_salary DECIMAL(10,2);
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET emp_salary = NULL;
    
    SELECT salary INTO emp_salary
    FROM employee
    WHERE emp_id = emp_id;

    IF emp_salary IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee not found';
    ELSE
        SELECT emp_salary;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE CalculateDeptAvgSalary(IN dept_id INT)
BEGIN
    DECLARE avg_salary DECIMAL(10,2);
    DECLARE CONTINUE HANDLER FOR SQLSTATE '22012'
        SET avg_salary = 0;

    SELECT AVG(salary) INTO avg_salary
    FROM employee
    WHERE dept_id = dept_id;

    IF avg_salary = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No employees in department';
    ELSE
        SELECT avg_salary;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE DeleteEmployee(IN emp_id INT)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete employee with dependent records';

    DELETE FROM employee WHERE emp_id = emp_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE InsertEmployee(IN emp_id INT, IN emp_name VARCHAR(50), IN salary DECIMAL(10,2), IN dept_id INT)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee already exists';
    
    INSERT INTO employee (emp_id, emp_name, salary, dept_id)
    VALUES (emp_id, emp_name, salary, dept_id);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE InsertDepartment(IN dept_id INT, IN dept_name VARCHAR(50))
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid department name';
    
    IF dept_name IS NULL OR dept_name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid department name';
    ELSE
        INSERT INTO department (dept_id, dept_name)
        VALUES (dept_id, dept_name);
    END IF;
END$$

DELIMITER ;
