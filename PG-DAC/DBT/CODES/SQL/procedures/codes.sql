DELIMITER //
CREATE PROCEDURE AddBook(
    IN p_title VARCHAR(100),
    IN p_author_id INT
)
BEGIN
    INSERT INTO Books (title, author_id)
    VALUES (p_title, p_author_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAuthorByBook(
    IN p_book_id INT,
    OUT p_author_name VARCHAR(100)
)
BEGIN
    SELECT a.author_name
    INTO p_author_name
    FROM Books b
    JOIN Authors a ON b.author_id = a.author_id
    WHERE b.book_id = p_book_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateBookTitle(
    IN p_book_id INT,
    INOUT p_new_title VARCHAR(100)
)
BEGIN
    UPDATE Books
    SET title = p_new_title
    WHERE book_id = p_book_id;

    SET p_new_title = CHAR_LENGTH(p_new_title);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteBookById(
    IN p_book_id INT
)
BEGIN
    DELETE FROM Books
    WHERE book_id = p_book_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ListBooksByAuthor(
    IN p_author_name VARCHAR(100)
)
BEGIN
    SELECT b.book_id, b.title
    FROM Books b
    JOIN Authors a ON b.author_id = a.author_id
    WHERE a.author_name = p_author_name;
END //
DELIMITER ;
