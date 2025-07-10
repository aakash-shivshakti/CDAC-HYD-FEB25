INSERT INTO books (title, price, stock) VALUES ('MySQL Guide', 500.00, 3);

INSERT INTO orders (book_id, quantity, order_date) VALUES (1, 2, NOW());

SELECT * FROM books;

UPDATE books SET price = 550.00 WHERE book_id = 1;
SELECT * FROM price_change_log;

DELETE FROM books WHERE book_id = 1;

UPDATE books SET stock = 0 WHERE book_id = 1;
DELETE FROM books WHERE book_id = 1;
SELECT * FROM deleted_books_log;