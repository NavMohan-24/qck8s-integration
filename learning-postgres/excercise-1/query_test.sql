-- This will work because we gave the full address
SELECT 'Querying with schema name:' AS label;
SELECT * FROM sales.orders;

-- This will FAIL (initially) because 'orders' isn't in the default path
SELECT 'Querying without schema name:' AS label;
SELECT * FROM orders;  -- search only default path

