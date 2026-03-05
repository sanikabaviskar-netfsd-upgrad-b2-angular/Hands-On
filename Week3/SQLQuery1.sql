CREATE DATABASE Ecommdb1;

use Ecommdb1;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    model_year INT,
    list_price DECIMAL(10,2),
    category_id INT
);

INSERT INTO products VALUES
(1, 'Maruti Swift', 2019, 20000, 1),
(2, 'Tata Nexon', 2018, 18000, 1),
(3, 'Mahindra Scorpio', 2020, 60000, 2),
(4, 'Kia Seltos', 2021, 65000, 2),
(5, 'Skoda Octavia', 2017, 10000, 1);


 
SELECT product_name, model_year, list_price
FROM products;

............................................................................................................................

SELECT product_name, model_year, list_price
FROM products p
WHERE list_price > 
      (SELECT AVG(p2.list_price)
       FROM products p2
       WHERE p2.category_id = p.category_id);
	   .................................................................................................................................
 ................................................................................................................................................

	SELECT  p.product_name, p.model_year, p.list_price, p.list_price - 
    (SELECT AVG(p2.list_price)
    FROM products p2
    WHERE p2.category_id = p.category_id) 
    AS Price_Difference
    FROM products p
    WHERE p.list_price >
      (SELECT AVG(p2.list_price)
       FROM products p2
       WHERE p2.category_id = p.category_id);
	   ....................................................................................................................................................

	   SELECT product_name + ' (' + CAST(model_year AS VARCHAR(4)) + ')' AS Product_Details
       FROM products;