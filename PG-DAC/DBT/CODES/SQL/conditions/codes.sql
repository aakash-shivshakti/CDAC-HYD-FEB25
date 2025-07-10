DELIMITER //

CREATE PROCEDURE insert_employee(
    IN p_emp_id INT,
    IN p_emp_name VARCHAR(50),
    IN p_salary DECIMAL(10,2),
    IN p_dept_id INT
)
BEGIN
    INSERT INTO employee(emp_id, emp_name, salary, dept_id)
    VALUES (p_emp_id, p_emp_name, p_salary, p_dept_id);
END //

CREATE PROCEDURE update_salary(p_emp_id INT)
BEGIN
    DECLARE current_salary DECIMAL(10,2);
    SELECT salary INTO current_salary FROM employee WHERE emp_id = p_emp_id;
    IF current_salary < 20000 THEN
        UPDATE employee SET salary = salary * 1.10 WHERE emp_id = p_emp_id;
    END IF;
END //

CREATE PROCEDURE delete_employee(p_emp_id INT)
BEGIN
    DELETE FROM employee WHERE emp_id = p_emp_id;
END //

CREATE FUNCTION get_employee_name(p_emp_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE empname VARCHAR(50);
    SELECT emp_name INTO empname FROM employee WHERE emp_id = p_emp_id;
    RETURN empname;
END //

CREATE FUNCTION get_department_name(p_emp_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE deptname VARCHAR(50);
    SELECT d.dept_name INTO deptname
    FROM employee e
    JOIN department d ON e.dept_id = d.dept_id
    WHERE e.emp_id = p_emp_id;
    RETURN deptname;
END //

DELIMITER ;
