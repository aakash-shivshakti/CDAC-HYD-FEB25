DELIMITER //
CREATE PROCEDURE make_names_upper()
BEGIN
    DECLARE sid INT DEFAULT 1;

    name_loop: LOOP
        IF sid > 3 THEN
            LEAVE name_loop;
        END IF;

        UPDATE students SET name = UPPER(name) WHERE student_id = sid;
        SET sid = sid + 1;
    END LOOP;
END;
//
DELIMITER ;

call make_names_upper();

DELIMITER //
CREATE PROCEDURE DayMessage(IN dayNum INT)
BEGIN
 SELECT CASE dayNum
 WHEN 1 THEN 'Monday Blues!'
 WHEN 2 THEN 'Tuesday Tasks'
 WHEN 3 THEN 'Midweek Hustle'
 WHEN 4 THEN 'Thursday Grind'
 WHEN 5 THEN 'Finally Friday!'
 ELSE 'Weekend Mode'
 END AS Message;
END //
DELIMITER ;

CALL DayMessage(3);

DELIMITER //
CREATE PROCEDURE CheckPassStatus(IN sid INT, IN cid INT)
BEGIN
 DECLARE score INT;
 SELECT marks_obtained INTO score FROM marks WHERE student_id = sid AND course_id = cid;
 IF score > 40 THEN
 SELECT 'Passed' AS Result;
 END IF;
END //
DELIMITER ;

CALL CheckPassStatus(1, 101);

DELIMITER //
CREATE PROCEDURE assign_grades()
BEGIN
    DECLARE sid INT;
    DECLARE cid INT;
    DECLARE m INT;
    
    SET sid = 1;
    
    WHILE sid <= 3 DO
        SET cid = 101;
        WHILE cid <= 103 DO
            SELECT marks_obtained INTO m
            FROM marks
            WHERE student_id = sid AND course_id = cid;
            
            IF m IS NOT NULL THEN
                INSERT INTO grades VALUES (
                    sid, cid,
                    CASE
                        WHEN m >= 90 THEN 'A'
                        WHEN m >= 75 THEN 'B'
                        WHEN m >= 60 THEN 'C'
                        ELSE 'D'
                    END
                );
            END IF;
            SET cid = cid + 1;
        END WHILE;
        SET sid = sid + 1;
    END WHILE;
END;
//
DELIMITER ;

CALL assign_grades();

DELIMITER //
CREATE PROCEDURE IsMultiCourseStudent(IN sid INT)
BEGIN
 DECLARE total INT;
 SELECT COUNT(*) INTO total FROM enrollments WHERE student_id = sid;
 IF total > 1 THEN
 SELECT 'Multi-course Student' AS Info;
 END IF;
END //
DELIMITER ;

CALL IsMultiCourseStudent(1);

DELIMITER //
CREATE PROCEDURE add_dummy_students()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE sid INT DEFAULT 100;

    REPEAT
        INSERT INTO students VALUES (sid, CONCAT('Dummy', i), 'Misc', 2025);
        SET i = i + 1;
        SET sid = sid + 1;
    UNTIL i > 5
    END REPEAT;
END;
//
DELIMITER ;

CALL add_dummy_students();

DELIMITER //
CREATE PROCEDURE AttendanceStatus(IN sid INT)
BEGIN
 DECLARE total INT;
 DECLARE present INT;

 SELECT COUNT(*) INTO total FROM attendance WHERE student_id = sid;
 SELECT COUNT(*) INTO present FROM attendance WHERE student_id = sid AND status = 'Present';
 IF total = 0 THEN
 SELECT 'No Data' AS Attendance;
 ELSEIF present / total >= 0.75 THEN
 SELECT 'Good Attendance' AS Attendance;
 ELSE
 SELECT 'Needs Improvement' AS Attendance;
 END IF;
END //
DELIMITER ;

CALL AttendanceStatus(3);

DELIMITER //
CREATE PROCEDURE delete_frequent_absentees()
BEGIN
    DECLARE sid INT default 1;
    declare temp int;
    DECLARE absent_count INT;
    select count(*) into temp from students;
    my_loop: LOOP
        IF sid > temp THEN
            LEAVE my_loop;
        END IF;

        SELECT COUNT(*) INTO absent_count
        FROM attendance
        WHERE student_id = sid AND status = 'Absent';

        IF absent_count > 1 THEN
            select* FROM students WHERE student_id = sid;
        END IF;
        
        SET sid = sid + 1;
    END LOOP;
END;
//
DELIMITER ;

call delete_frequent_absentees();