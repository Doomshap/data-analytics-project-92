-- top 10 total income
select concat(first_name,' ', last_name) as name,
count(sales_id) as operations,
sum(quantity*price) as income 
from sales
inner join products on sales.product_id = products.product_id
inner join employees on sales.sales_person_id = employees.employee_id 
group by concat(first_name,' ', last_name)
order by (3) desc limit 10


--lowest average income
with tab as(
select distinct concat(first_name, ' ', last_name) as name,
avg(quantity*price) over (order by concat(first_name, ' ', last_name)) as personal_avg
from sales
inner join products on sales.product_id = products.product_id
inner join employees on sales.sales_person_id = employees.employee_id)

select name, round(personal_avg) as average_income
from tab where (select avg(personal_avg) from tab)>personal_avg
order by (2)


--day of the week income
with tab as(
select
concat(first_name, ' ', last_name) as name,
EXTRACT(DOW from sale_date) as week_day_num,
to_char(sale_date, 'DAY') as week_day_char,
sum(quantity*price) as income
from sales
inner join products on sales.product_id = products.product_id
inner join employees on sales.sales_person_id = employees.employee_id
group by(week_day_char,week_day_num,concat(first_name, ' ', last_name)))

select
name, week_day_char as weekday, income
from tab
order by week_day_num


--age groups
select distinct
case when age between 16 and 25 then '16-25'
     when age between 26 and 45 then '26-40'
     when age>40 then '40+' end as age_category,
     count(customer_id) as count
from customers
group by (age_category)


--customers by month
SELECT to_char(sale_date, 'YYYY-MM') as date,
count(customer_id) as total_customers,
sum(quantity*price) as income
FROM sales
inner join products on sales.product_id = products.product_id
group by to_char(sale_date, 'YYYY-MM')
order by date


--special offer
with tab as(
select
sales.customer_id as id,
concat(customers.first_name, ' ', customers.last_name) as customer,
products.price as price,
concat(employees.first_name, ' ', employees.last_name) as seller,
sale_date,
ROW_NUMBER() over (partition by concat(customers.first_name, ' ', customers.last_name) order by (1), sale_date)
from sales
inner join products on sales.product_id = products.product_id
inner join customers on sales.customer_id = customers.customer_id 
inner join employees on sales.sales_person_id = employees.employee_id
order by (1), sale_date
)

select customer, sale_date, seller
from tab
where row_number=1 and price=0
order by id
