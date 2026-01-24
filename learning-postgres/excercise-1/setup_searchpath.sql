-- check the current path
SHOW search_path;

-- Add sales to the serach path
SET search_path TO sales, public;

-- Verify it works now.
SELECT 'Query after setting search_path:' AS label;
EXPLAIN ANALYSE SELECT * FROM orders;