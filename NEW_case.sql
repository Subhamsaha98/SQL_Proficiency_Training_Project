create database new_case;
use new_case;

-- /EXERCISE 1: COMPARISON OPERATOR QUERIES/

/*1. From the TransactionMaster table, select a list of all items purchased for Customer_Number 296053. Display the Customer_Number,
Product_Number, and Sales_Amount for this customer.*/

select customer_number, Product_number, Sales_Amount
from transactionmaster
where customer_number = '296053';

-- /2. Select all columns from the LocationMaster table for transactions made in the Region = NORTH./

Select * from locationmaster
where region = "NORTH";

/*3. Select the distinct products in the TransactionMaster table. In other words, display a listing of each of the unique products from the
TransactionMaster table.*/

select distinct Product_number
from transactionmaster;

-- /4. List all the Customers without duplication./

select distinct customer_number, FirstOfCustomer_Name
from Customermaster;

-- /EXERCISE 2: AGGREGATE FUCNTION QUERIES/

-- /1. Find the average Sales Amount for Product Number 30300 in Sales Period P03./

select product_number, Sales_period, avg(sales_amount)
from transactionmaster
where product_number = '30300' and sales_period = 'P03';

-- /2. Find the maximum Sales Amount amongst all the transactions./

select max(sales_amount) from transactionmaster;

-- /3. Count the total number of transactions for each Product Number and display in descending order/

select Product_number, count(product_number) as Total
from transactionmaster
group by product_number 
Order by Total desc;

-- /4. List the total number of transactions in Sales Period P02 and P03/

select sales_period, count(Sales_period) as Total
from transactionmaster
where Sales_period = "P02" or sales_period = "P03"
group by sales_period;

-- /5. What is the total number of rows in the TransactionMaster table?/

select count(*)
from transactionmaster;

-- /6. Look into the PriceMaster table to find the price of the cheapest product that was ordered./

select product_number, min(Price)
from pricemaster
Group by Product_number;

/*EXERCISE 3: LIKE FUNCTION QUERIES/

/1. Select all Employees where Employee-Status = “A”*/

select * from employee_master
where employee_status like "A";

-- /2. Select all Employees where Job Description is “TEAMLEAD 1”./

select * from employee_master
where job_title like "TEAMLEAD 1";

-- /3. List the Last name, Employee Status and Job Title of all employees whose names contain the letter "o" as the second letter./

select last_name, Employee_status, Job_title from employee_master
where regexp_like(last_name, '^.o');

select last_name, Employee_status, Job_title from employee_master
where last_name like '_o%';

/*4. List the Last name, Employee Status and Job Title of all employees whose First names start with the letter "A" and 
does not contain the letter "i".*/

select last_name, First_name, Employee_status, Job_title from employee_master
where first_name like 'A%' and first_name not like '%I%';

-- /5. List the First name and Last names of employees with Employee Status “I” whose Job Code is not SR2 and SR3./

select first_name, last_name, Employee_status
from employee_master
where employee_status = "I" and job_code not like 'SR2' and job_code not like 'SR3';

-- /6. Find out details of employees whose last name ends with “N” and first name begins with “A” or “D”./

select * from employee_master
where last_name like "%N" and first_name like "A%" or first_name like "D%";

-- /7. Find the list of products with the word “Maintenance” in their product description./

select * from productmaster
where product_description like "%MAINTENANCE%";

-- /EXERCISE 4: DATE FUNCTION QUERIES/

alter table employee_master 
add Column NewHireDate date;

SET SQL_SAFE_UPDATES = 0;

Update employee_master
SET NewHireDate = Str_To_Date(Hire_date, "%Y-%m-%D %H-%i-%s");

select NewHireDate from employee_master;

alter table employee_master 
add Column NewLastDayWorked date;

Update employee_master
SET NewLastDayWorked = Str_To_Date(Last_Date_Worked, "%Y-%m-%d %H-%i-%s");

-- /1. List the employees who were hired before 01/01/2000 (hint: use # for date values)./

select * from employee_master
where Hire_date < '2000/01/01';

-- /2. Find the total number years of employment for all the employees who have retired./

select datediff(Last_date_worked, hire_date) from employee_master;  -- PROBLEM

-- /3. List the transactions, which were performed on Wednesday or Saturdays./

alter table transactionmaster 
add Column NewServiceDate date;

Update transactionmaster
SET NewServiceDate = Str_To_Date(Service_date, "%Y-%m-%d %H-%i-%s");

alter table transactionmaster 
add Column NewInvoiceDate date;

Update transactionmaster
SET NewInvoiceDate = Str_To_Date(Invoice_date, "%Y-%m-%d %H-%i-%s");

select *, weekday(NewServiceDate) from transactionmaster
Where weekday(NewServiceDate) in (2,5);  -- PROBLEM

select *
from transactionmaster
where weekday(NewServiceDate) in (2) or weekday(NewServiceDate) in (5);  -- PROBLEM

SELECT *
FROM TransactionMaster
WHERE DAYOFWEEK(Invoice_Date) IN (4, 7); -- PROBLEM

-- /4. Find the list of employees who are still working at the present./

select * from employee_master
where Employee_Status = "A";

/*EXERCISE 5: GROUP BY CLAUSE QUERIES/

/1. List the number of Customers from each City and State.*/

select FirstOfCity, FirstOfState, COUNT(*) as customer_count
from customermaster
group by FirstOfCity, FirstOfState;

-- /2. For each Sales Period find the average Sales Amount./

select sales_period, AVG(sales_amount) as average_sales_amount
FROM transactionmaster
GROUP BY sales_period;

-- /3. Find the total number of customers in each Market./

select market, COUNT(*) as customer_count
from locationmaster
group by market;

-- /4. List the number of customers and the average Sales Amount in each Region./


/*5. From the TransactionMaster table, select the Product number, maximum price, and minimum price for each specific item in the table. Hint: The
products will need to be broken up into separate groups.*/

select product_number, max(Sales_amount), min(Sales_amount)
from transactionmaster
group by Product_number;

-- /EXERCISE 6: ORDER BY CLAUSE QUERIES/

/*1. Select the Name of customer companies, city, and state for all customers in the CustomerMaster table. Display the results in Ascending Order
based on the Customer Name (company name).*/

select * from customermaster
order by FirstOfcustomer_name asc;

-- /2. Same thing as question #1, but display the results in descending order./

select * from customermaster
order by FirstOfcustomer_name desc;

/*3. Select the product number and sales amount for all of the items in the TransactionMaster table that the sales amount is greater than 100.00.
Display the results in descending order based on the price.*/

select Product_number, Sales_amount
from transactionmaster
where sales_amount > 100.000
Order by sales_amount desc;

-- /EXERCISE 7: HAVING CLAUSE QUERIES/
/*1. How many branches are in each unique region in the LocationMaster
table that has more than one branch in the region? Select the region and
display the number of branches are in each if it's greater than 1.*/

select region, count(Branch_number) as branch_count
from locationmaster
group by region
having count(Branch_number) > 1;

/*2. From the TransactionMaster table, select the item, maximum sales
amount, and minimum sales amount for each product number in the
table. Only display the results if the maximum price for one of the items is
greater than 390.00.*/

select Product_number, max(sales_amount) as maximum_sales_amount, min(sales_amount) as minimum_sales_amount
from TransactionMaster
group by product_number
having max(sales_amount) > 390.00;

/*3. How many orders did each customer company make? Use the
TransactionMaster table. Select the Customer_Number, count the number
of orders they made, and the sum of their orders if they purchased more
than 1 item.*/

select Customer_Number, count(*) as Order_Count, sum(Sales_Amount) as Total_Sales
from TransactionMaster
group by Customer_Number
having count(*) > 1;


/*EXERCISE 8: IN AND BETWEEN FUNCTION QUERIES

1. List all the employees who have worked between 22 March 2004 and 21
April 2004.*/

select employee_number, hire_date, last_date_worked 
from employee_master
where hire_date <= '2004-04-21' and (last_date_worked >= '2004-03-22'or
last_date_worked  is null  );

/*2. List the names of Employees whose Job Code is in SR1,SR2 or SR3.*/

select First_Name, Last_Name, job_code
from employee_master
where job_code in ('SR1' 'SR2' or 'SR3' );

/*Select the Invoice date, Product number and Branch number of all
transactions, which have Sales amount ranging from 150.00 to 200.00.*/

select Invoice_date, Product_number, Branch_Number,Sales_Amount
from transactionmaster
where Sales_Amount >= 150.00 and Sales_Amount<= 200.00;


/*4. Select the Branch Number, Market and Region from the LocationMaster
table for all of the rows where the Market value is either: Dallas, Denver,
Tulsa, or Canada.*/

select Branch_Number, Market , region 
from locationmaster
where market  in ('Dallas', 'Denver','Tulsa',' Canada');


-- /EXERCISE 10: TABLE JOINS/

/*1. Write a query using a join to determine which products were ordered by
each of the customers in the CustomerMaster table. Select the
Customer_Number, FirstOfCustomer_Name, FirstOfCity, Product_Number,
Invoice_Number, Invoice_date, and Sales_Amount for everything each
customer purchased in the TransactionsMaster table.*/

select cm.Customer_Number, cm.FirstOfCustomer_Name, cm.FirstOfCity, tm.Product_Number, tm.Invoice_Number, tm.Invoice_date, tm.Sales_Amount
FROM CustomerMaster cm
JOIN TransactionMaster tm ON cm.Customer_Number = tm.Customer_Number;

/*2. Repeat question #1, however display the results sorted by City in
descending order.*/

select cm.Customer_Number, cm.FirstOfCustomer_Name, cm.FirstOfCity, tm.Product_Number, tm.Invoice_Number, tm.Invoice_date, tm.Sales_Amount
FROM CustomerMaster cm
JOIN TransactionMaster tm ON cm.Customer_Number = tm.Customer_Number
order by cm.FirstOfCity desc;



