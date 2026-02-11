DROP TABLE IF EXISTS vehicles CASCADE;

-- Create the parent (Base Class)
CREATE TABLE vehicles(
    vin serial PRIMARY KEY,
    manufacturer text
);

-- Create the child (Subclass)
CREATE TABLE electric_cars(
    -- pull the next value from counter vehicles_vin_seq ([table_name]_[column_name]_seq)
    -- "serial" link a counter to each database. 
    vin int DEFAULT nextval('vehicles_vin_seq'),
    battery_capacity int 
) INHERITS (vehicles);

-- by default the postgres inherit constraints and indexes.
ALTER TABLE electric_cars ADD PRIMARY KEY (vin);

-- Insert data into the child.
INSERT INTO electric_cars (manufacturer, battery_capacity)
VALUES ('Tesla', 100);

SELECT 'Query Parent (Vehicles)' AS label;
SELECT * FROM vehicles;

SELECT 'Query Child (electric_cars)' AS label;
SELECT * FROM electric_cars; 