# Creating and Analysing Pizza Joint Database
![](pizzaBoxes.png)

## Introduction
In this project, I used Microsoft Excel, DrawSQL, MySQL workbench, Power Query Editor and Microsoft Power BI to respectively normalize spreadsheet data, design a database and generate ‘CREATE statements’ for the actual database, join and analyze tables, and visualize certain patterns and insights from the tables.

## Data Sourcing and Description
The tables used were sourced from Kaggle.com in this page (https://www.kaggle.com/datasets/jaspearson/pizzeria-data-for-4-weeks) which contains seven CSV files; each containing information about a Pizzeria. They are not real-world datasets as the owner who published them stated that they are AI-generated. Initially, when opened in MS Excel, the CSV files were not suitable enough for this project as they were not well normalized for SQL querying. For one, their “id” values were not consistent with those in the other tables. Thankfully, using Microsoft Excel functions, the data was normalized and excess data in each file was deleted. The names and descriptions of the resulting normalized Excel files are in the scenario below.

## Scenario
A client, Samuel Roberts, is opening a new international Pizza delivery shop. It would not be a dining but just a delivery/pickup shop. He has asked me to make a database that would allow him to capture and store all the important information and data the business generates. This will help him monitor business performance in dashboards that I will be building using Microsoft Power BI. Robert’s major area of focus is in the Orders and Stock information. He wants to know the following.
1.	What are the ***Total Orders*** we’ve gotten so far?
2.	I need to know our ***Total Sales*** so far.
3.	I need a summary of the ***Total Items*** sold.
4.	What is our ***Average Order*** value.
5.	Give me info on our ***Sales by Category*** too (you know…how much money we’ve made from each Pizza category).
6.	What are our ***top selling items***?
7.	How many ***orders*** do we get each ***hour***?
8.	How much ***sales*** do we make each ***hour***?
9.	I want to know how much ***orders*** we get from each ***address***
10.	What are our ***orders by delivery/pick up***?
11.	What is the ***total quantity by ingredients*** sold?
12.	What is the ***total cost of each ingredients***?
13.	What is the ***calculated cost of each pizza***?
14.	What is the ***percentage of stock remaining by ingredients*** in inventory?

To this effect, I asked him for the following data below which he had stored in MS Excel sheets. The table below contains information on the spreadsheet names, the number of columns and the information they hold:

Excel tables | Col. No. | Content description
:-------------:|:------:|:----------------------------------
orders.xlsx | 8 | contains information on the time of orders, the quantity of items ordered by each customer, and whether the order was delivered
items.xlsx | 6 | contains information on pizza names, categories, sizes and prices
customers.xlsx | 3 | contains customers’ first and last names
address.xlsx | 3 | contains each customer’s delivery address and city
recipe.xlsx | 4 | contains information on the ingredients in each item/pizza and the quantity ordered
ingredients.xlsx | 5 | contains the name, weight, mass_measurement_unit, and price of each ingredient
inventory.xlsx | 3 | Contains the quantity of items that were in the inventory

Luckily for me, the Excel tables were perfectly normalized for querying in MySQL Workbench (i.e. after I normalized them in real life 😅), which I used to execute SQL queries on the database

## Methodology

---

### Creating the Database
<details>
  <summary>Expand</summary>

I used the DrawSQL app to design the database and generate the Data Definition Language (DDL) to be run in MySQL workbench. The database was saved as “pizzeria”.

![](database_diagram.png)

[View the database design from its source](https://drawsql.app/teams/eniifeoluwa/diagrams/pizza-db)

[View the DDL used to CREATE the database](DDL_for_Pizzeria.sql)
</details>

---

### Table JOINs and Column Calculations
<details>
  <summary>Expand</summary>

For the first Power Bi dashboard where I need to visualize the following below:
-	Total orders
-	Total sales
-	Total items
-	Average order value
-	Sales by Category
-	Top selling items
-	Orders by hour
-	Sales by hour
-	Order by address
-	Orders by delivery/pick up

I wrote the SQL query below in which I used table Aliases ‘o.’, ‘i.’ and ‘a.’ to represent the ***orders***, ***items*** and ***address*** tables respectively so that I can select the necessary columns from each of them and JOIN them to form the table I will be using for the first visualization

**The following, SQL query and resulting table are as follows:**

```SQL
USE Pizzeria;
SELECT
o.order_id,
i.item_price,
o.quantity,
i.item_cat,
i.item_name,
o.created_at,
a.delivery_address1,
a.delivery_city,
o.delivery
FROM orders o
LEFT JOIN items i ON o.item_id = i.item_id
LEFT JOIN address a ON o.add_id = a.add_id
```
![](query_and_table1.png)

---

For the second Power BI dashboard, I would be creating a new table that would make it easier to calculate how much of the inventory the Pizza shop has used, and then identify how much of the ingredients in the inventory needs reordering. But since the inventory table only has information on the different items, I would need to JOIN the items and ingredients tables with it so that I can calculate the total ingredients in the inventory by knowing how much of an ingredient is in an item. This would mean calculating how much each type of pizza/item costs to make based on the cost of the ingredients. I will therefore need a query to reveal the following:

1.	Total quantity by ingredient
2.	Total cost of ingredients
3.	Calculated cost of pizza
4.	Percentage stock remaining by ingredient

Firstly, to get the ***Total quantity by ingredient***, I needed to know how many orders there are, and then multiply the number of orders for each item by the quantity of each ingredient in each recipe ordered.

```SQL
SELECT
o.item_id,
i.sku,
i.item_name,
r.ing_id,
ing.ing_name,
r.quantity AS recipe_quantity,
SUM(o.quantity) AS order_quantity,
ing.ing_weight,
ing.ing_price
FROM orders o
LEFT JOIN items i ON o.item_id = i.item_id
LEFT JOIN recipe r ON i.sku = r.recipe_id
LEFT JOIN ingredients ing ON ing.ing_id = r.ing_id
GROUP BY 
o.item_id, 
i.sku, 
i.item_name, 
r.ing_id,
r.quantity,
ing.ing_name,
ing.ing_weight,
ing.ing_price
```

-	The “r.quantity AS recipe_quantity,” line in the query above returns the quantity of each ingredient in each recipe that has been ordered
-	The “SUM(o.quantity) AS order_quantity,” line in the query above returns the quantity of each recipe ordered

From this result, the next thing to do would be to calculate the total cost of ingredients ordered or used so far. To do this I would need to get the unit cost for each ingredient through the ingredient weight and price already in the table above. However, the summed order_quantity in the orders table will hinder this because is already an aggregated field (SUM (o.quantity) as order_quantity), so it cannot be used in the same select statement. The solution is to use sub_queries (a select statement in a select statement) and save it as “s1”
``` SQL
SELECT* FROM (SELECT
o.item_id,
i.sku,
i.item_name,
r.ing_id,
ing.ing_name,
r.quantity AS recipe_quantity,
SUM(o.quantity) AS order_quantity,
ing.ing_weight,
ing.ing_price
FROM orders o
LEFT JOIN items i ON o.item_id = i.item_id
LEFT JOIN recipe r ON i.sku = r.recipe_id
LEFT JOIN ingredients ing ON ing.ing_id = r.ing_id
GROUP BY 
o.item_id, 
i.sku, 
i.item_name, 
r.ing_id,
r.quantity,
ing.ing_name,
ing.ing_weight,
ing.ing_price) AS s1;
```
s1 returns the same table so now I can query s1 to calculate the total cost of ingredients ordered or used so far by calculating the unit cost for each ingredient through the ingredient weight and price.
```SQL
SELECT 
s1.item_name,
s1.ing_id,
s1.ing_name,
s1.ing_weight,
s1.ing_price,
s1.order_quantity,
s1.recipe_quantity,
s1.order_quantity * s1.recipe_quantity AS ordered_weight,
s1.ing_price / s1.ing_weight AS unit_cost,
(s1.order_quantity * s1.recipe_quantity) * (s1.ing_price / s1.ing_weight) as ingredient_cost
FROM (SELECT
o.item_id,
i.sku,
i.item_name,
r.ing_id,
ing.ing_name,
r.quantity AS recipe_quantity,
SUM(o.quantity) AS order_quantity,
ing.ing_weight,
ing.ing_price
FROM orders o
LEFT JOIN items i ON o.item_id = i.item_id
LEFT JOIN recipe r ON i.sku = r.recipe_id
LEFT JOIN ingredients ing ON ing.ing_id = r.ing_id
GROUP BY 
o.item_id, 
i.sku, 
i.item_name, 
r.ing_id,
r.quantity,
ing.ing_name,
ing.ing_weight,
ing.ing_price) AS s1
```
s1.order_quantity * s1.recipe_quantity AS ordered_weight,  >>> returns the multiplication of the quantity of items ordered by the quantity of ingredients in each item.
s1.ing_price / s1.ing_weight AS unit_cost >>> returns the unit cost of each ingredient
(s1.order_quantity * s1.recipe_quantity) * (s1.ing_price / s1.ing_weight) as ingredient_cost >>> returns the total cost of each ingredient used so far
By this, I have been able to calculate, not only the Total Quantity by ingredients ordered, and the unit cost of each ingredient, but also the calculated cost of making each variety of Pizza by their ingredient quantity.
But I still need to get the percentage stock remaining by ingredient in the inventory, and also the list of ingredients to re-order based on the remaining ingredients in the inventory. To do this, I made an entire view from the previous table using “CREATE VIEW” statement, saving the view as stock2 as seen in the query below:
```SQL
CREATE VIEW stock2 AS SELECT 
s1.item_name,
s1.ing_id,
s1.ing_name,
s1.ing_weight,
s1.ing_price,
s1.order_quantity,
s1.recipe_quantity,
s1.order_quantity * s1.recipe_quantity AS ordered_weight,
s1.ing_price / s1.ing_weight AS unit_cost,
(s1.order_quantity * s1.recipe_quantity) * (s1.ing_price / s1.ing_weight) as ingredient_cost
FROM (SELECT
o.item_id,
i.sku,
i.item_name,
r.ing_id,
ing.ing_name,
r.quantity AS recipe_quantity,
SUM(o.quantity) AS order_quantity,
ing.ing_weight,
ing.ing_price
FROM orders o
LEFT JOIN items i ON o.item_id = i.item_id
LEFT JOIN recipe r ON i.sku = r.recipe_id
LEFT JOIN ingredients ing ON ing.ing_id = r.ing_id
GROUP BY 
o.item_id, 
i.sku, 
i.item_name, 
r.ing_id,
r.quantity,
ing.ing_name,
ing.ing_weight,
ing.ing_price) AS s1
```
With this view, I would be calculating the following:
-	The total weight ordered
-	The amount of ingredients in the Inventory
-	The amount remaining per ingredient in the inventory

Ordered weight
To get the total weight of ingredients ordered, I used this query:
```SQL
SELECT
ing_name,
SUM(ordered_weight) AS ordered_weight 
FROM stock2 
GROUP BY ing_name
```
The output above shows the total weight of ingredients in the inventory that have been used/ordered
Amount of ingredients in the Inventory
To calculate the amount of ingredients in the inventory I had to convert the query above to a sub-query AS ‘s2’ and then JOIN the ingredients and inventory tables to it:
```SQL
SELECT * FROM (SELECT
ing_id,
ing_name,
SUM(ordered_weight) AS ordered_weight
FROM
stock2 GROUP BY ing_name, ing_id) AS s2
LEFT JOIN inventory inv ON inv.item_id = s2.ing_id
LEFT JOIN  ingredients ing ON ing.ing_id = s2.ing_id
```
Finally, I wrote the query below to calculate the total weight of ingredients in the inventory and subtract the ordered ingredient weight from it to get the remaining weight in the inventory
```SQL
SELECT 
s2.ing_name,
s2.ordered_weight,
ing.ing_weight,
inv.quantity,
(ing.ing_weight*inv.quantity) AS total_inv_weight,
(ing.ing_weight*inv.quantity) - s2.ordered_weight as remaining_weight
FROM (SELECT
ing_id,
ing_name,
SUM(ordered_weight) AS ordered_weight
FROM
stock2 GROUP BY ing_name, ing_id) AS s2
LEFT JOIN inventory inv ON inv.item_id = s2.ing_id
LEFT JOIN  ingredients ing ON ing.ing_id = s2.ing_id
```
- (ing.ing_weight * inv.quantity) AS total_inv_weight, >>> returns the total weight of ingredients in the inventory
- (ing.ing_weight * inv.quantity) - s2.ordered_weight as remaining_weight >>> subtracts the ordered ingredients’ weight from the total ingredient weight in the inventory to get what is left in the inventory.
