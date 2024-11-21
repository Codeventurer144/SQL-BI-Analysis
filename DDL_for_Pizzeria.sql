CREATE TABLE `recipe`(
    `row_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `recipe_id` VARCHAR(20) NOT NULL,
    `ing_id` VARCHAR(10) NOT NULL,
    `quantity` INT NOT NULL
);
CREATE TABLE `orders`(
    `row_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `order_id` VARCHAR(10) NOT NULL,
    `created_at` DATETIME NOT NULL,
    `item_id` VARCHAR(20) NOT NULL,
    `quantity` INT NOT NULL,
    `cust_id` INT NOT NULL,
    `delivery` BOOLEAN NOT NULL,
    `add_id` INT NOT NULL
);
CREATE TABLE `inventory`(
    `inv_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `item_id` VARCHAR(10) NOT NULL,
    `quantity` INT NOT NULL
);
CREATE TABLE `customers`(
    `cust_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `cust_firstname` VARCHAR(50) NOT NULL,
    `cust_lastname` VARCHAR(50) NOT NULL
);
CREATE TABLE `items`(
    `item_id` VARCHAR(10) NOT NULL,
    `sku` VARCHAR(20) NOT NULL,
    `item_name` VARCHAR(100) NOT NULL,
    `item_cat` VARCHAR(100) NOT NULL,
    `item_size` VARCHAR(10) NOT NULL,
    `item_price` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY(`item_id`)
);
CREATE TABLE `ingredients`(
    `ing_id varchar(10)` VARCHAR(10) NOT NULL,
    `ing_name` VARCHAR(200) NOT NULL,
    `ing_weight` INT NOT NULL,
    `ing_mass` VARCHAR(20) NOT NULL,
    `ing_price` DECIMAL(5, 2) NOT NULL,
    PRIMARY KEY(`ing_id varchar(10)`)
);
CREATE TABLE `address`(
    `add_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `delivery_address1` VARCHAR(200) NOT NULL,
    `delivery_city` VARCHAR(50) NOT NULL
);
ALTER TABLE
    `recipe` ADD CONSTRAINT `recipe_ing_id_foreign` FOREIGN KEY(`ing_id`) REFERENCES `inventory`(`inv_id`);
ALTER TABLE
    `orders` ADD CONSTRAINT `orders_cust_id_foreign` FOREIGN KEY(`cust_id`) REFERENCES `customers`(`cust_id`);
ALTER TABLE
    `recipe` ADD CONSTRAINT `recipe_ing_id_foreign` FOREIGN KEY(`ing_id`) REFERENCES `ingredients`(`ing_id varchar(10)`);
ALTER TABLE
    `items` ADD CONSTRAINT `items_sku_foreign` FOREIGN KEY(`sku`) REFERENCES `recipe`(`recipe_id`);
ALTER TABLE
    `orders` ADD CONSTRAINT `orders_item_id_foreign` FOREIGN KEY(`item_id`) REFERENCES `items`(`item_id`);
ALTER TABLE
    `orders` ADD CONSTRAINT `orders_add_id_foreign` FOREIGN KEY(`add_id`) REFERENCES `address`(`add_id`);