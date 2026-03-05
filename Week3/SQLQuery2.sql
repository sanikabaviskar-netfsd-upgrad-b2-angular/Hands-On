use Ecommdb

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_value DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers VALUES
(1, 'Sanika', 'Patil'),
(2, 'Rahul', 'Shah'),
(3, 'Priya', 'Mehta'),
(4, 'Amit', 'Joshi'),
(5, 'Neha', 'Kulkarni');

INSERT INTO orders VALUES
(101, 1, 6000),
(102, 1, 5000),
(103, 2, 3000),
(104, 3, 8000),
(105, 3, 4000);


      ...............................................................................................................................

   SELECT c.customer_id, (SELECT SUM(order_value)
   FROM orders o
   WHERE o.customer_id = c.customer_id) AS Total_Order_Value
   FROM customers c;
   .............................................................................................................................................


 -- Customers WITH orders
SELECT 
   c.customer_id,
    c.first_name + ' ' + c.last_name AS Full_Name,
    SUM(o.order_value) AS Total_Order_Value
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
UNION
SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS Full_Name,
    0 AS Total_Order_Value
FROM customers c
WHERE c.customer_id NOT IN 
      (SELECT customer_id FROM orders);


	  ..................................................................................................................................

	  SELECT first_name + ' ' + last_name AS Full_Name FROM customers;

	  .............................................................................................................................................

	