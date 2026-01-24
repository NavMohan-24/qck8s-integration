-- Clean table from our last test
DROP TABLE IF EXISTS test_table;
DROP SCHEMA IF EXISTS training CASCADE;

-- Create structured organization
CREATE SCHEMA sales;
CREATE SCHEMA hr;

CREATE TABLE sales.orders (id serial PRIMARY KEY, item text);
CREATE TABLE hr.employess (id serial PRIMARY KEY, name text);