select count(*) as customers_count from customers
-- top 10 total income
select concat(first_name,' ', last_name) as name,
count(sales_id) as operations,
sum(quantity*price) as income 
from sales
inner join products on sales.product_id = products.product_id
inner join employees on sales.sales_person_id = employees.employee_id 
group by concat(first_name,' ', last_name)
order by (3) desc limit 10

--lowest average ncome
with tab as(
select distinct concat(first_name, ' ', last_name) as name,
avg(quantity*price) over (order by concat(first_name, ' ', last_name)) as personal_avg
from sales
inner join products on sales.product_id = products.product_id
inner join employees on sales.sales_person_id = employees.employee_id)

select name, round(personal_avg) as average_income
from tab where (select avg(personal_avg) from tab)>personal_avg
order by (2)

--day of the week ncome
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
