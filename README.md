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

### Creating the Database
I used the DrawSQL app to design the database and generate the Data Definition Language (DDL) to be run in MySQL workbench. The database was saved as “pizzeria”.
![](database_diagram.png)

