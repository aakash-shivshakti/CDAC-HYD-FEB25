CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    price DECIMAL(8,2),
    stock INT
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    quantity INT,
    order_date DATETIME,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE price_change_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    old_price DECIMAL(8,2),
    new_price DECIMAL(8,2),
    changed_on DATETIME
);

CREATE TABLE deleted_books_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    title VARCHAR(100),
    deleted_on DATETIME
);

INSERT INTO books (title, price, stock) VALUES
('Learn SQL in 24 Hours', 350.00, 12),
('MySQL Performance Tuning', 750.00, 3),
('Database Management Essentials', 650.00, 7),
('Advanced SQL Queries', 520.00, 5),
('SQL Optimization Techniques', 450.00, 10),
('Introduction to SQL', 400.00, 20),
('SQL for Data Science', 550.00, 8),
('Mastering SQL Joins', 600.00, 4);

INSERT INTO orders (book_id, quantity, order_date) VALUES
(1, 2, NOW()),
(2, 1, NOW()),
(3, 3, NOW()),
(4, 1, NOW()),
(5, 4, NOW()),
(6, 5, NOW()),
(7, 2, NOW()),
(8, 1, NOW());

UPDATE books SET price = 560.00 WHERE book_id = 2;
UPDATE books SET price = 480.00 WHERE book_id = 5;

UPDATE books SET stock = 0 WHERE book_id = 4;
UPDATE books SET stock = 0 WHERE book_id = 8;

DELETE FROM books WHERE book_id = 6;

INSERT INTO orders (book_id, quantity, order_date) VALUES
(1, 15, NOW());

INSERT INTO orders (book_id, quantity, order_date) VALUES
(2, 7, NOW());

