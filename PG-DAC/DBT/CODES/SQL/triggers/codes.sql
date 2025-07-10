DELIMITER $$

CREATE TRIGGER before_insert_orders
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;

    SELECT stock INTO available_stock FROM books WHERE book_id = NEW.book_id;

    IF available_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock available';
    END IF;
END$$

CREATE TRIGGER after_insert_orders
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    UPDATE books
    SET stock = stock - NEW.quantity
    WHERE book_id = NEW.book_id;
END$$

CREATE TRIGGER before_update_books
BEFORE UPDATE ON books
FOR EACH ROW
BEGIN
    IF NEW.stock < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock cannot be negative';
    END IF;
END$$

CREATE TRIGGER after_update_books
AFTER UPDATE ON books
FOR EACH ROW
BEGIN
    IF OLD.price != NEW.price THEN
        INSERT INTO price_change_log (book_id, old_price, new_price, changed_on)
        VALUES (OLD.book_id, OLD.price, NEW.price, NOW());
    END IF;
END$$

CREATE TRIGGER before_delete_books
BEFORE DELETE ON books
FOR EACH ROW
BEGIN
    IF OLD.stock > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete book with remaining stock';
    END IF;
END$$

CREATE TRIGGER after_delete_books
AFTER DELETE ON books
FOR EACH ROW
BEGIN
    INSERT INTO deleted_books_log (book_id, title, deleted_on)
    VALUES (OLD.book_id, OLD.title, NOW());
END$$

DELIMITER ;
