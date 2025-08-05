-- 1. A. CREATE DATABASE
    -- B. IMPORT CSV FILES


CREATE DATABASE LSM;
USE LSM;

-- 2. CRUD Operations
-- A. CREATE - Inserted sample records into the books table.

SELECT * FROM BOOKS;

INSERT INTO books VALUES (
978-552-85954-8, 'The Ironman', 'Comic', 12.3, 'yes', 'stanlee', 'prakash prajapat'
);

-- B. Update an Existing Member's Address

SELECT * FROM members;


UPDATE members
SET member_address = '23 gali no-2'
WHERE member_id = 'C102';

-- C. Delete a Record from the Issued Status Table 

SELECT * FROM issued_status;

DELETE FROM issued_status
WHERE issued_id = 'IS136';

-- D. Retrieve All Books Issued by a Specific Employee

SELECT * FROM branch;

SELECT * FROM branch
WHERE branch_id = 'B004';

-- 3. The following SQL queries were used to address specific questions:

-- Retrieve All Books in a Specific Category:


SELECT * FROM books
WHERE category = 'classic';


-- Find Total Rental Income by Category:

SELECT category, SUM(rental_price) AS total_rental
FROM books
GROUP BY category
ORDER BY total_rental DESC;

-- 	List Members Who Registered in the Last 180 Days:

SELECT * 
FROM members 
WHERE reg_date >= CURDATE() - INTERVAL 180 DAY;

-- List Employees with Their Branch Manager's Name and their branch details:


SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager_name
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id  
JOIN
employees as e2
ON e2.emp_id = b.manager_id;

-- Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE VIEW
expensive_books
as
select * from books
where rental_price > 7;

select * from expensive_books;

-- Retrieve the List of Books Not Yet Returned

select * from 
issued_status as is_
left join return_status as r
on is_.issued_id = r.issued_id
where return_id is null;

/* Write a query to identify members who have overdue books (assume a 30-day return period).
 Display the member's_id, member's name, book title, issue date, and days overdue*/
 
 SELECT m.member_id, m.member_name, b.book_title, i.issued_date, return_date
 FROM members AS m
 JOIN issued_status AS i ON m.member_id = i.issued_member_id
 JOIN books AS b ON i.issued_book_isbn = b.isbn
 LEFT JOIN return_status as rs ON b.isbn = rs.return_book_isbn
 WHERE Return_date IS NULL
 AND CURDATE() - i.issued_date > 30;
 
-- Retrieve All Books and Their Authors:

SELECT book_title, author 
FROM books;

-- Find Members Registered in the Last Year:

SELECT member_id, member_name, member_address,
 reg_date AS last_year
 FROM MEMBERS
WHERE reg_date BETWEEN '2024-01-01' AND '2024-12-31';

-- Count Books per Category:


SELECT category, COUNT(*) as No_of_books
FROM books
GROUP BY category
ORDER BY NO_of_books;


-- Find Employees Earning Above Average Salary:

SELECT * FROM employees 
WHERE salary >
(SELECT ROUND(AVG(salary),2) AS avg_salary
FROM employees)
;


-- Identify Branches with More Than 50,000 Books Issued (Total):

select b.branch_id, count(issued_id) as issued_books
from employees as e
join branch as b
on e.branch_id = b.branch_id
join issued_status as si on si.issued_emp_id = e.emp_id
group by branch_id
having count(issued_id) > 50000;


-- List Members Who Have Issued More Than 3 Books and Not Yet Returned Any:

WITH book_data AS (
  SELECT 
    m.member_id,
    m.member_name,
    si.issued_id,
    rs.return_date
  FROM members AS m
  JOIN issue_status AS si ON m.member_id = si.issued_member_id
  LEFT JOIN return_status AS rs ON si.issued_id = rs.issued_id
)

SELECT 
  member_id, 
  COUNT(issued_id) AS issued_books
FROM book_data
WHERE return_date IS NULL
GROUP BY member_id
HAVING COUNT(issued_id) > 3;










