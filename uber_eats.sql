START TRANSACTION;

-- Drop tables in order considering dependencies
DROP TABLE IF EXISTS OrderInvoice;
DROP TABLE IF EXISTS BranchMenu;
DROP TABLE IF EXISTS GeneralMenu;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Location;

-- Create Location table
CREATE TABLE Location (
    zip_code VARCHAR(10) NOT NULL PRIMARY KEY,
    branch_name VARCHAR(100),
    branch_address VARCHAR(255),
    branch_phone VARCHAR(20)
);

-- Create GeneralMenu table
CREATE TABLE GeneralMenu (
    item_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    item_description VARCHAR(255),
    is_vegetarian BOOLEAN NOT NULL DEFAULT 0
);

-- Create Customer table
CREATE TABLE Customer (
    customer_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    zip_code VARCHAR(10),
    FOREIGN KEY (zip_code)
        REFERENCES Location (zip_code)
);

-- Create BranchMenu table
CREATE TABLE BranchMenu (
    branch_menu_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    zip_code VARCHAR(10) NOT NULL,
    item_id INT NOT NULL,
    price DECIMAL(10 , 2 ) NOT NULL,
    available_status BOOLEAN NOT NULL DEFAULT 1,
    FOREIGN KEY (zip_code)
        REFERENCES Location (zip_code),
    FOREIGN KEY (item_id)
        REFERENCES GeneralMenu (item_id)
);

-- Create OrderInvoice table
CREATE TABLE OrderInvoice (
    order_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10 , 2 ) NOT NULL,
    status VARCHAR(50),
    FOREIGN KEY (customer_id)
        REFERENCES Customer (customer_id),
    FOREIGN KEY (zip_code)
        REFERENCES Location (zip_code)
);
-- Insert 3 locations in St. Louis
INSERT INTO Location (zip_code, branch_name, branch_address, branch_phone) VALUES
('63101', 'Central St. Louis Branch', '100 Market St, St. Louis, MO', '314-555-0101'),
('63103', 'Downtown St. Louis Branch', '200 Broadway St, St. Louis, MO', '314-555-0202'),
('63110', 'Forest Park Branch', '300 Kingshighway Blvd, St. Louis, MO', '314-555-0303');

-- Insert some GeneralMenu items
INSERT INTO GeneralMenu (item_name, item_description, is_vegetarian) VALUES
('Veggie Burger', 'Delicious plant-based burger', 1),
('Cheese Pizza', 'Classic cheese pizza with tomato sauce', 1),
('BBQ Chicken Sandwich', 'Grilled chicken sandwich with BBQ sauce', 0);

-- Insert some customers linked to locations
INSERT INTO Customer (name, email, phone, zip_code) VALUES
('Alice Smith', 'alice@example.com', '314-555-1001', '63101'),
('Bob Johnson', 'bob@example.com', '314-555-1002', '63103'),
('Carol Davis', 'carol@example.com', '314-555-1003', '63110');

-- Insert branch menus — prices and availability
INSERT INTO BranchMenu (zip_code, item_id, price, available_status) VALUES
('63101', 1, 8.99, 1),
('63101', 2, 12.50, 1),
('63103', 2, 13.00, 1),
('63103', 3, 10.00, 1),
('63110', 1, 9.50, 1),
('63110', 3, 11.00, 0);  -- unavailable currently

-- Insert sample orders
INSERT INTO OrderInvoice (customer_id, zip_code, order_date, total_amount, status) VALUES
(1, '63101', '2025-06-28', 17.98, 'completed'),
(2, '63103', '2025-06-27', 13.00, 'pending'),
(3, '63110', '2025-06-26', 9.50, 'completed');

SELECT 
    o.order_id,
    c.name AS customer_name,
    l.branch_name,
    o.order_date,
    o.total_amount,
    o.status
FROM
    OrderInvoice o
        JOIN
    Customer c ON o.customer_id = c.customer_id
        JOIN
    Location l ON o.zip_code = l.zip_code;

COMMIT;
