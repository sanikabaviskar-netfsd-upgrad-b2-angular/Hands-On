use Ecommdb;

CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100)
);

CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    list_price DECIMAL(10,2)
);

CREATE TABLE order1 (
    order_id INT PRIMARY KEY,
    store_id INT,
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

INSERT INTO stores (store_id, store_name) VALUES
(1, 'Mumbai Store'),
(2, 'Pune Store'),
(3, 'Delhi Store');

INSERT INTO product (product_id, product_name, list_price) VALUES
(101, 'Laptop', 50000),
(102, 'Mobile', 20000),
(103, 'Tablet', 15000),
(104, 'Headphones', 5000),
(105, 'Smartwatch', 10000);

INSERT INTO order1 (order_id, store_id) VALUES
(1, 1),   -- Mumbai Store
(2, 1),   -- Mumbai Store
(3, 2),   -- Pune Store
(4, 3);   -- Delhi Store

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    discount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES order1(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

INSERT INTO order_items VALUES
(1, 1, 101, 2, 1000),
(2, 1, 102, 3, 500),
(3, 2, 103, 1, 200),
(4, 3, 101, 1, 0);

SELECT 
    s.store_name,
    p.product_name,
    (SELECT SUM(oi.quantity)
     FROM order_items oi
     JOIN order1 o ON oi.order_id = o.order_id
     WHERE o.store_id = s.store_id
       AND oi.product_id = p.product_id
    ) AS total_quantity_sold
FROM stores s
CROSS JOIN product p
WHERE EXISTS (
    SELECT 1
    FROM order_items oi
    JOIN order1 o ON oi.order_id = o.order_id
    WHERE o.store_id = s.store_id
      AND oi.product_id = p.product_id
);

CREATE TABLE stocks (
    store_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

INSERT INTO stocks VALUES
(1, 101, 10),
(1, 102, 0),   -- zero stock
(2, 101, 5),
(2, 103, 0);   -- zero stock


SELECT o.store_id, oi.product_id
FROM order_items oi
JOIN order1 o ON oi.order_id = o.order_id

EXCEPT

SELECT store_id, product_id
FROM stocks
WHERE quantity > 0;

SELECT 
    s.store_name,
    p.product_name,
    sales.total_quantity_sold
FROM
(
    -- Subquery: calculate total quantity sold per store & product
    SELECT 
        o.store_id,
        oi.product_id,
        SUM(oi.quantity) AS total_quantity_sold
    FROM order_items oi
    JOIN order1 o 
        ON oi.order_id = o.order_id
    GROUP BY o.store_id, oi.product_id
) AS sales

JOIN stores s 
    ON sales.store_id = s.store_id

JOIN product p 
    ON sales.product_id = p.product_id;

	SELECT 
    p.product_name,
    SUM(oi.quantity * p.list_price - oi.discount) AS total_revenue
FROM order_items oi
JOIN product p 
    ON oi.product_id = p.product_id
GROUP BY p.product_name;

UPDATE stocks
SET quantity = 0
WHERE product_id IN (
    SELECT product_id
    FROM product
    WHERE discontinued = 1
);