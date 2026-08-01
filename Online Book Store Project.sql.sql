--Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;



--Import Data Into Books Table
COPY Books(Book_ID ,Title ,Author ,Genre ,Published_Year ,Price ,Stock )
FROM 'C:\Books.csv'
DELIMITER ',' 
CSV HEADER;


COPY Customers(Customer_ID ,Name ,Email ,Phone ,City ,Country )
FROM 'C:\Customers.csv'
DELIMITER ','
CSV HEADER;

COPY Orders(Order_ID ,Customer_ID ,Book_ID ,Order_Date ,Quantity ,Total_Amount )
FROM 'C:\Orders.csv'
DELIMITER ','
CSV HEADER;




--1) Retrieve all books in the "Fiction" genre
SELECT * FROM Books
WHERE Genre = 'Fiction';

--2)Find Books Published after the year 1950
SELECT * FROM Books
WHERE published_year>1950;

--3)List all customers from the canada
SELECT * FROM Customers
WHERE country='Canada';

--4)Show orders placed in November 2023
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available
SELECT SUM(Stock) AS Total_Stock 
FROM Books;

-- 6) Find the details of the most expensive book
SELECT * 
FROM Books 
ORDER BY Price DESC 
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
SELECT DISTINCT c.* 
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20
SELECT * 
FROM Orders 
WHERE Total_Amount > 20;

-- 9) List all genres available in the Books table
SELECT DISTINCT Genre 
FROM Books;

-- 10) Find the book with the lowest stock
SELECT * 
FROM Books 
ORDER BY Stock ASC 
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders
SELECT SUM(Total_Amount) AS Total_Revenue 
FROM Orders;

--12)Retrive the total number of books sold for each genre
-- SELECT * FROM Books;
-- SELECT * FROM Orders;
SELECT b.genre,SUM(o.quantity)
FROM Books b
JOIN
Orders o ON b.book_id=o.book_id
GROUP BY genre;

--13) Find the average price of books in the each genre.
SELECT genre,avg(price) FROM Books
GROUP BY genre;

--14)List customers who have placed at least 2 order
-- SELECT * FROM Books;
-- SELECT * FROM Customers;
-- SELECT * FROM Orders;
SELECT c.name,COUNT(o.order_id) AS TOTAL_Orders
FROM Customers c
JOIN
Orders o ON c.customer_id=o.customer_id
GROUP BY c.name
HAVING COUNT(o.order_id)>=2;

--15)Find the most frequent order book
-- SELECT * FROM Books;
-- SELECT * FROM Customers;
-- SELECT * FROM Orders;
SELECT b.book_id,COUNT(o.order_id)
FROM Books b
JOIN
Orders o ON b.book_id=o.book_id
GROUP BY b.book_id
ORDER BY COUNT(o.order_id) DESC LIMIT 1;

--16)Show the top 3 most expensive books of "fantasy" genre
SELECT * FROM Books
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

--17)Retrieve the total quantity of books sold by each author
SELECT b.author,SUM(o.quantity) AS total_quantity_sold
FROM Books b
JOIN
Orders o ON b.book_id=o.book_id
GROUP BY b.author;

--18)List the cities where customers who spent over $30 are located
-- SELECT * FROM orders;
-- select * FROM customers;
SELECT c.city,SUM(o.total_amount) AS total_spend
FROM customers c
JOIN
orders o ON c.customer_id=o.customer_id
GROUP BY c.city
HAVING SUM(o.total_amount)>30;

--19)Find the customer who spend most on orders
-- SELECT * FROM orders;
-- select * FROM customers;
SELECT c.name,SUM(o.total_amount)
FROM Customers c
JOIN
Orders o ON c.customer_id=o.customer_id
GROUP BY c.name
ORDER BY SUM(o.total_amount) DESC LIMIT 1;

--20)Calculate the stock remaining after fulfilling all orders
-- SELECT * FROM Books;
-- SELECT * FROM Orders;
SELECT b.book_id, b.stock,COALESCE(SUM(o.quantity),0) AS total_ordered, 
       b.stock - COALESCE(SUM(o.quantity),0) AS remaining_stock
FROM Books b
JOIN Orders o ON b.book_id = o.book_id
GROUP BY b.book_id, b.stock;