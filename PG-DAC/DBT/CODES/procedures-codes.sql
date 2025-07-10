DELIMITER //
CREATE PROCEDURE enroll_student(IN sid INT, IN cid INT)
BEGIN
 INSERT INTO enrollments (student_id, course_id)
 SELECT sid, cid
 FROM students s, courses c
 WHERE s.student_id = sid AND c.course_id = cid
 AND s.department = c.department
 AND NOT EXISTS (
 SELECT 1 FROM enrollments
 WHERE student_id = sid AND course_id = cid
 );
END;
//
DELIMITER ;

CALL enroll_student(3, 103);

DELIMITER //
CREATE PROCEDURE student_avg_marks(IN sid INT, OUT avg_marks DECIMAL(5,2))
BEGIN
 SELECT AVG(m.marks_obtained) INTO avg_marks
 FROM marks m WHERE m.student_id = sid;
END;
//
DELIMITER ;

CALL student_avg_marks(1, @avg);
SELECT @avg;

DELIMITER //
CREATE PROCEDURE course_attempt_tracker(IN sid INT, INOUT attempt_count INT)
BEGIN
 DECLARE new_count INT;
 SELECT COUNT(*) INTO new_count FROM marks WHERE student_id = sid;
 SET attempt_count = attempt_count + new_count;
END;
//
DELIMITER ;

SET @attempt = 0;
CALL course_attempt_tracker(1, @attempt);
SELECT @attempt;

DELIMITER //
CREATE PROCEDURE assign_grades()
BEGIN
 DELETE FROM grades;
 INSERT INTO grades (student_id, course_id, grade)
 SELECT student_id, course_id,
 CASE
 WHEN marks_obtained >= 90 THEN 'A'
 WHEN marks_obtained >= 75 THEN 'B'
 WHEN marks_obtained >= 60 THEN 'C'
 WHEN marks_obtained >= 40 THEN 'D'
 ELSE 'F'
 END
 FROM marks;
END;
//
DELIMITER ;

CALL assign_grades();

DELIMITER //
CREATE PROCEDURE course_topper(IN cid INT, OUT topper_name VARCHAR(100), OUT top_marks INT)
BEGIN
 SELECT s.name, m.marks_obtained
 INTO topper_name, top_marks
 FROM marks m
 JOIN students s ON m.student_id = s.student_id
 WHERE m.course_id = cid
 ORDER BY m.marks_obtained DESC LIMIT 1;
END;
//
DELIMITER ;

CALL course_topper(101, @name, @marks);
SELECT @name, @marks;

DELIMITER //
CREATE PROCEDURE scholarship_list()
BEGIN
 SELECT student_id, AVG(marks_obtained) AS avg_marks
 FROM marks
 GROUP BY student_id
 HAVING AVG(marks_obtained) > 85 AND SUM(marks_obtained < 40) = 0;
END;
//
DELIMITER ;

CALL scholarship_list(); 

DELIMITER //
CREATE PROCEDURE student_backlogs(IN sid INT)
BEGIN
 SELECT c.course_name, m.marks_obtained
 FROM marks m
 JOIN courses c ON m.course_id = c.course_id
 WHERE m.student_id = sid AND m.marks_obtained < 40;
END;
//
DELIMITER ;

CALL student_backlogs(2);

DELIMITER //
CREATE PROCEDURE check_duplicate_enrollment(IN sid INT, IN cid INT, OUT status VARCHAR(20))
BEGIN
 IF EXISTS (SELECT 1 FROM enrollments WHERE student_id = sid AND course_id = cid) THEN
 SET status = 'Duplicate';
 ELSE
 INSERT INTO enrollments (student_id, course_id) VALUES (sid, cid);
 SET status = 'Inserted';
 END IF;
END;
//
DELIMITER ;

CALL check_duplicate_enrollment(1, 102, @status);
SELECT @status;