DELIMITER //
CREATE FUNCTION count_low_scores(studentId INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  DECLARE i INT DEFAULT 0;
  DECLARE low_count INT DEFAULT 0;

  SELECT COUNT(*) INTO total FROM marks WHERE student_id = studentId;

  WHILE i < total DO
    IF (SELECT marks_obtained FROM marks WHERE student_id = studentId LIMIT i,1) < 50 THEN
      SET low_count = low_count + 1;
    END IF;
    SET i = i + 1;
  END WHILE;

  RETURN low_count;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION count_present_days(studentId INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE total INT;
  DECLARE present_count INT DEFAULT 0;

  SELECT COUNT(*) INTO total FROM attendance WHERE student_id = studentId;

  REPEAT
    IF (SELECT status FROM attendance WHERE student_id = studentId LIMIT i,1) = 'Present' THEN
      SET present_count = present_count + 1;
    END IF;
    SET i = i + 1;
  UNTIL i >= total
  END REPEAT;

  RETURN present_count;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION passed_courses(studentId INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE total INT;
  DECLARE count_pass INT DEFAULT 0;

  SELECT COUNT(*) INTO total FROM marks WHERE student_id = studentId;

  loop_label: LOOP
    IF i >= total THEN
      LEAVE loop_label;
    END IF;

    IF (SELECT marks_obtained FROM marks WHERE student_id = studentId LIMIT i,1) >= 40 THEN
      SET count_pass = count_pass + 1;
    END IF;

    SET i = i + 1;
  END LOOP;

  RETURN count_pass;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION performance_level(studentId INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
  DECLARE avgMark DOUBLE;
  SELECT IFNULL(AVG(marks_obtained), 0) INTO avgMark FROM marks WHERE student_id = studentId;

  RETURN CASE
    WHEN avgMark >= 85 THEN 'Excellent'
    WHEN avgMark >= 70 THEN 'Good'
    WHEN avgMark >= 50 THEN 'Average'
    ELSE 'Poor'
  END;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION attendance_status(studentId INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
  DECLARE p INT;
  SELECT COUNT(*) INTO p FROM attendance WHERE student_id = studentId AND status = 'Present';

  IF p >= 3 THEN
    RETURN 'Active';
  ELSEIF p > 0 THEN
    RETURN 'Inactive';
  ELSE
    RETURN 'No Data';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION total_even_indexed_marks(studentId INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  DECLARE i INT DEFAULT 0;
  DECLARE sumEven INT DEFAULT 0;

  SELECT COUNT(*) INTO total FROM marks WHERE student_id = studentId;

  WHILE i < total DO
    IF MOD(i, 2) = 0 THEN
      SET sumEven = sumEven + (SELECT marks_obtained FROM marks WHERE student_id = studentId LIMIT i,1);
    END IF;
    SET i = i + 1;
  END WHILE;

  RETURN sumEven;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION cross_dept_courses(studentId INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE dept VARCHAR(50);
  DECLARE i INT DEFAULT 0;
  DECLARE total INT;
  DECLARE countDiff INT DEFAULT 0;

  SELECT department INTO dept FROM students WHERE student_id = studentId;
  SELECT COUNT(*) INTO total FROM enrollments WHERE student_id = studentId;

  REPEAT
    IF (
      SELECT c.department 
      FROM enrollments e JOIN courses c ON e.course_id = c.course_id
      WHERE e.student_id = studentId LIMIT i,1
    ) != dept THEN
      SET countDiff = countDiff + 1;
    END IF;
    SET i = i + 1;
  UNTIL i >= total
  END REPEAT;

  RETURN countDiff;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION has_any_backlog(studentId INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  DECLARE i INT DEFAULT 0;
  DECLARE found INT DEFAULT 0;

  SELECT COUNT(*) INTO total FROM marks WHERE student_id = studentId;

  loop_label: LOOP
    IF i >= total THEN
      LEAVE loop_label;
    END IF;

    IF (SELECT marks_obtained FROM marks WHERE student_id = studentId LIMIT i,1) < 40 THEN
      SET found = 1;
      LEAVE loop_label;
    END IF;

    SET i = i + 1;
  END LOOP;

  RETURN found;
END;
//
DELIMITER ;


DELIMITER //
CREATE FUNCTION highest_subject(studentId INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  DECLARE total INT;
  DECLARE i INT DEFAULT 0;
  DECLARE maxMark INT DEFAULT -1;
  DECLARE subject VARCHAR(100);

  SELECT COUNT(*) INTO total FROM marks WHERE student_id = studentId;

  WHILE i < total DO
    IF (SELECT marks_obtained FROM marks WHERE student_id = studentId LIMIT i,1) > maxMark THEN
      SET maxMark = (SELECT marks_obtained FROM marks WHERE student_id = studentId LIMIT i,1);
      SET subject = (
        SELECT c.course_name 
        FROM marks m JOIN courses c ON m.course_id = c.course_id
        WHERE m.student_id = studentId LIMIT i,1
      );
    END IF;
    SET i = i + 1;
  END WHILE;

  RETURN subject;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION performance_trend(studentId INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
  DECLARE firstMark INT;
  DECLARE lastMark INT;
  DECLARE total INT;

  SELECT COUNT(*) INTO total FROM marks WHERE student_id = studentId;
  IF total = 0 THEN
    RETURN 'No Data';
  END IF;

  SELECT marks_obtained INTO firstMark FROM marks WHERE student_id = studentId ORDER BY course_id ASC LIMIT 1;
  SELECT marks_obtained INTO lastMark FROM marks WHERE student_id = studentId ORDER BY course_id DESC LIMIT 1;

  IF lastMark > firstMark THEN
    RETURN 'Improving';
  ELSE
    RETURN 'Declining';
  END IF;
END;
//
DELIMITER ;
