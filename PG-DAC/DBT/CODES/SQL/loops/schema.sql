CREATE TABLE department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

INSERT INTO department (dept_id, dept_name) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'Engineering'),
(4, 'Marketing');

INSERT INTO employee (emp_id, emp_name, salary, dept_id) VALUES
(101, 'Alice', 18000, 1),
(102, 'Bob', 25000, 2),
(103, 'Charlie', 12000, 3),
(104, 'Diana', 32000, 1),
(105, 'Evan', 15000, 4);
