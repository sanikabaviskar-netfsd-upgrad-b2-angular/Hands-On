create database stocks;

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE order_s (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    order_status INT,  -- 1=Completed, 2=Processing, 3=Rejected
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE archived_orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    order_status INT
);

INSERT INTO customer VALUES
(1, 'Rahul'),
(2, 'Sneha'),
(3, 'Amit'),
(4, 'Priya');

INSERT INTO order_s VALUES
-- Completed orders
(101, 1, '2024-01-10', '2024-01-15', '2024-01-14', 1),
(102, 2, '2024-02-01', '2024-02-05', '2024-02-04', 1),

-- Processing order
(103, 3, '2025-01-01', '2025-01-05', NULL, 2),

-- Rejected old order (older than 1 year)
(104, 1, '2023-01-01', '2023-01-05', NULL, 3),

-- Rejected recent order
(105, 4, '2025-01-10', '2025-01-15', NULL, 3);

INSERT INTO archived_orders
SELECT *
FROM order_s
WHERE order_status = 3
AND order_date < DATEADD(YEAR, -1, GETDATE());

SELECT * FROM archived_orders;

DELETE FROM order_s
WHERE order_status = 3
AND order_date < DATEADD(YEAR, -1, GETDATE());


SELECT c.customer_id, c.customer_name
FROM customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM order_s o
    WHERE o.customer_id = c.customer_id
    AND o.order_status <> 1
);

SELECT 
    order_id,
    order_date,
    shipped_date,
    DATEDIFF(DAY, order_date, shipped_date) AS processing_delay_days
FROM order_s;

SELECT 
    order_id,
    order_date,
    required_date,
    shipped_date,
    CASE 
        WHEN shipped_date IS NULL THEN 'Not Shipped'
        WHEN shipped_date > required_date THEN 'Delayed'
        ELSE 'On Time'
    END AS delivery_status
FROM order_s;