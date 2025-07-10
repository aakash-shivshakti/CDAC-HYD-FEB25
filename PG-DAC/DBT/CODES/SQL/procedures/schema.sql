CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100)
);

CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

INSERT INTO Authors (author_name) VALUES
('J.K. Rowling'),
('George R.R. Martin'),
('J.R.R. Tolkien');

INSERT INTO Books (title, author_id) VALUES
('Harry Potter and the Philosopher''s Stone', 1),
('Harry Potter and the Chamber of Secrets', 1),
('A Game of Thrones', 2),
('A Clash of Kings', 2),
('The Hobbit', 3),
('The Lord of the Rings', 3);
