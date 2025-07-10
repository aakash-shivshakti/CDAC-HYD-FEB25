-- Create tables
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    price DECIMAL(10,2),
    quantity INT
);

CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(20),
    table_name VARCHAR(50),
    old_data TEXT,
    new_data TEXT,
    action_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO products (name, price, quantity)
VALUES 
('Pen', 5.00, 100),
('Notebook', 25.00, 50),
('Eraser', 3.00, 200);

-- Example 1: Duplicate Primary Key Insertion
DELIMITER $$

DROP PROCEDURE IF EXISTS test_duplicate_insertion$$
CREATE PROCEDURE test_duplicate_insertion()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error: Duplicate entry for product_id';
    END;

    INSERT INTO products (product_id, name, price, quantity)
    VALUES (1, 'Pencil', 2.00, 150);
END$$

DELIMITER ;

CALL test_duplicate_insertion();

-- Example 2: Foreign Key Violation
DELIMITER $$

DROP PROCEDURE IF EXISTS test_foreign_key_violation()
CREATE PROCEDURE test_foreign_key_violation()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error: Foreign key violation - invalid product_id';
    END;

    INSERT INTO sales (product_id, quantity_sold)
    VALUES (999, 10); -- Non-existent product_id
END$$

DELIMITER ;

CALL test_foreign_key_violation();

-- Example 3: Division by Zero

DELIMITER $$

DROP FUNCTION IF EXISTS safe_divide$$

CREATE FUNCTION safe_divide(a INT, b INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE result DECIMAL(10,2) DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    SET result = 0;
  END;

  IF b = 0 THEN
    SET result = 9999999;
  ELSE
    SET result = a / b;
  END IF;

  RETURN result;
END$$

DELIMITER ;

select safe_divide(10,0);


-- Example 4: Generic Error (Invalid Column)
DELIMITER $$

DROP PROCEDURE IF EXISTS test_generic_error_handling()
CREATE PROCEDURE test_generic_error_handling()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'An error occurred while performing the operation';
    END;

    -- This uses an invalid column name
    UPDATE products SET unknown_column = 123 WHERE product_id = 1;
END$$

DELIMITER ;

CALL test_generic_error_handling();

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS check_age;

DELIMITER //

CREATE PROCEDURE check_age(IN user_age INT)
BEGIN
    -- Step 1: Define a custom condition
    DECLARE age_too_low CONDITION FOR SQLSTATE '45000';

    -- Step 2: Declare a handler for the custom condition
    DECLARE EXIT HANDLER FOR age_too_low
    BEGIN
        SELECT 'User is too young. Must be at least 18.';
    END;

    -- Step 3: Raise the exception using SIGNAL if age < 18
    IF user_age < 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Age too low for registration';
    END IF;

    -- Step 4: If age is okay, proceed
    SELECT 'User is eligible!';
END;
//

DELIMITER ;

CALL check_age(16);

