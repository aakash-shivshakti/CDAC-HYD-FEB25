CREATE TABLE low_salary_employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50)
);

DELIMITER //

CREATE PROCEDURE insert_low_salary_employees()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE eid INT;
    DECLARE ename VARCHAR(50);
    DECLARE cur CURSOR FOR SELECT emp_id, emp_name FROM employee WHERE salary < 20000;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    loop_label: LOOP
        FETCH cur INTO eid, ename;
        IF done = 1 THEN 
            LEAVE loop_label;
        END IF;
        INSERT INTO low_salary_employees VALUES (eid, ename);
        ITERATE loop_label;
    END LOOP;
    CLOSE cur;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE delete_hr_employees()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE eid INT;
    DECLARE cur CURSOR FOR SELECT emp_id FROM employee WHERE dept_id = 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    del_loop: LOOP
        FETCH cur INTO eid;
        IF done = 1 THEN 
            LEAVE del_loop;
        END IF;
        DELETE FROM employee WHERE emp_id = eid;
    END LOOP;
    CLOSE cur;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE update_marketing_salary()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE eid INT;
    DECLARE curs CURSOR FOR SELECT emp_id FROM employee WHERE dept_id = 4;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN curs;
    upd_loop: LOOP
        FETCH curs INTO eid;
        IF done = 1 THEN 
            LEAVE upd_loop;
        END IF;
        UPDATE employee SET salary = salary * 1.10 WHERE emp_id = eid;
    END LOOP;
    CLOSE curs;
END//

DELIMITER ;

DELIMITER //

CREATE FUNCTION count_high_salary_employees()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE cnt INT DEFAULT 0;
    DECLARE eid INT;
    DECLARE curs CURSOR FOR SELECT emp_id FROM employee WHERE salary > 15000;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN curs;
    count_loop: LOOP
        FETCH curs INTO eid;
        IF done = 1 THEN 
            LEAVE count_loop;
        END IF;
        SET cnt = cnt + 1;
    END LOOP;
    CLOSE curs;
    RETURN cnt;
END//

DELIMITER ;

DELIMITER //

CREATE FUNCTION total_salary_finance()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE sal DECIMAL(10,2);
    DECLARE total DECIMAL(10,2) DEFAULT 0;
    DECLARE curs CURSOR FOR SELECT salary FROM employee WHERE dept_id = 2;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN curs;
    sum_loop: LOOP
        FETCH curs INTO sal;
        IF done = 1 THEN 
            LEAVE sum_loop;
        END IF;
        SET total = total + sal;
    END LOOP;
    CLOSE curs;
    RETURN total;
END//

DELIMITER ;
