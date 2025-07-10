DELIMITER //
CREATE FUNCTION count_enrollments(stud_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE counter INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;

    label1: LOOP
        IF i >= (SELECT COUNT(*) FROM enrollments WHERE student_id = stud_id) THEN
            LEAVE label1;
        END IF;
        SET counter = counter + 1;
        SET i = i + 1;
        ITERATE label1;
    END LOOP label1;

    RETURN counter;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION count_present_days2(stud_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE n INT;

    SELECT COUNT(*) INTO n FROM attendance WHERE student_id = stud_id AND status = 'Present';

    loop_present: LOOP
        IF i >= n THEN
            LEAVE loop_present;
        END IF;
        SET total = total + 1;
        SET i = i + 1;
        ITERATE loop_present;
    END LOOP loop_present;

    RETURN total;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION total_marks(stud_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT DEFAULT 0;
    DECLARE countrows INT DEFAULT (SELECT COUNT(*) FROM marks WHERE student_id = stud_id);
    DECLARE i INT DEFAULT 0;

    loop_marks: LOOP
        IF i >= countrows THEN
            LEAVE loop_marks;
        END IF;
        SET total = total + (SELECT marks_obtained FROM marks WHERE student_id = stud_id LIMIT 1 OFFSET i);
        SET i = i + 1;
        ITERATE loop_marks;
    END LOOP;

    RETURN total;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION count_high_scores(stud_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE counter INT DEFAULT 0;
    DECLARE totalrows INT DEFAULT (SELECT COUNT(*) FROM marks WHERE student_id = stud_id);
    DECLARE i INT DEFAULT 0;
    DECLARE mark INT;

    label_loop: LOOP
        IF i >= totalrows THEN
            LEAVE label_loop;
        END IF;
        SELECT marks_obtained INTO mark FROM marks WHERE student_id = stud_id LIMIT 1 OFFSET i;
        IF mark > 75 THEN
            SET counter = counter + 1;
        END IF;
        SET i = i + 1;
        ITERATE label_loop;
    END LOOP;

    RETURN counter;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION count_students_in_course(cid INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE maxrow INT;

    SELECT COUNT(*) INTO maxrow FROM enrollments WHERE course_id = cid;

    loop1: LOOP
        IF i >= maxrow THEN
            LEAVE loop1;
        END IF;
        SET total = total + 1;
        SET i = i + 1;
        ITERATE loop1;
    END LOOP;

    RETURN total;
END;
//
DELIMITER ;
