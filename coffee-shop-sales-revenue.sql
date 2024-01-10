
--/ in this analysis i'll analyize the sales of the coffee shop from jan 2023 till jun 2023

--/ from the first look i've noticed that there's more than one store location

select
	distinct(store_location) 	
from
		[Coffee Shop]..[coffee-shop-sales-revenue]

--/ So, I will use info in my analysis to always compare between the different store locations 

--/ my first part of the analysis will be about dates and times and the secound part will be about the products and sales

--/ Dates and Times

--1 busiest month
select	
		month,
		COUNT(transaction_id) as total_transaction
from
	(
		select
				case 
			when MONTH(transaction_date) = 1 then 'January'
			when MONTH(transaction_date) = 2 then 'February'
			when MONTH(transaction_date) = 3 then 'March'
			when MONTH(transaction_date) = 4 then 'April'
			when MONTH(transaction_date) = 5 then 'May'
			else 'June'
		end as month,
				transaction_id
		from
				[Coffee Shop]..[coffee-shop-sales-revenue]
	) as month_names
group by 
		month
order by
		2 desc

--# june is the month with the highest transactions which may be related to seasonal changes which will be clear when we analyze the product


--2 Busiest day of the month

select
		DAY(transaction_date) as weekday,
		COUNT(transaction_id) as total_transaction
from
		[Coffee Shop]..[coffee-shop-sales-revenue]
group by
		DAY(transaction_date)
order by
		2 desc
--# there's no clear trends about certain days of the month but we can use this analysis in out marketing plan

--3 Busiest weekday
select
		weekday,
		COUNT(transaction_id) as total_transaction
from
		[Coffee Shop]..[coffee-shop-sales-revenue]
group by
		weekday
order by
		2 desc
--# Again there's an equal spread of transactions amoung the week so maybe i will look into day periods

--4 Day periods
select
		day_periods,
		COUNT(transaction_id) as total_transaction
from
		[Coffee Shop]..[coffee-shop-sales-revenue]
group by
		day_periods
--# Jackpot!!  There's a clear trend that people mainly buy from the shop in the morning more than afternoon and night combined!!!!

--/ the secound part of the analysis

--1 sales per store locations
select
		store_location,
		COUNT(transaction_id) as total_transaction,
		round(sum(total_sales_per_transaction),2) as total_sales
from
(
select
		transaction_id,
		store_location,
		transaction_qty*unit_price as total_sales_per_transaction
from
		[Coffee Shop]..[coffee-shop-sales-revenue]
) as id
group by
		store_location
order by
		3 desc
--# there's no clear distinction in sales between the different stores

--2 product category
select
		product_category,
		COUNT(transaction_id) as total_transaction,
		round(sum(total_sales_per_transaction),2) as total_sales
from
(
select
		transaction_id,
		product_category,
		transaction_qty*unit_price as total_sales_per_transaction
from
		[Coffee Shop]..[coffee-shop-sales-revenue]
) as id
group by
		product_category
order by
		3 desc
--# we have 9 different product categiries with coffee being the highest sales and Packaged Chocolate with the lowest sales

--3 product type
select
		product_type,
		COUNT(transaction_id) as total_transaction,
		round(sum(total_sales_per_transaction),2) as total_sales
from
(
select
		transaction_id,
		product_type,
		transaction_qty*unit_price as total_sales_per_transaction
from
		[Coffee Shop]..[coffee-shop-sales-revenue]
) as id
group by
		product_type
order by
		3 desc
--# we have 29 type of product.
--# hot drinks is the main items that generate sales

--4 cup sizes
select
		cup_sizes,
		COUNT(cup_sizes) as total_cups,
		round(sum(total_sales_per_transaction),2) as total_sales
from
(
select
		case 
			when product_detail like '%lg%' then 'Large Cup'
			when product_detail like '%sm%' then 'Small Cup'
			when product_detail like '%rg%' then 'Regular Cup'
			else 'Others'
			end as cup_sizes,
			transaction_qty*unit_price as total_sales_per_transaction
from
		[Coffee Shop]..[coffee-shop-sales-revenue]
) as cup_size
group by
		cup_sizes
order by
		3 desc
--# we have 3 cup sizes and other ways of serving as (shots, scone...etc).
--# small cups generates the least sales and regular cups require the highest stock 