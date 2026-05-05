use project;




-- Q1: What are the different payment methods, and how many transactions and items were sold with each method?
select
	payment_method,
    count(*) As transactions,
    sum(quantity) as item_sold
from walmart_sales
group by payment_method;

-- Q2: Which category received the highest average rating in each branch?
select * from (
select
	branch,
    category,
    round(avg(rating),2) As avg_rating,
    row_number() over(partition by branch order by avg(rating) desc) as rnk
from walmart_sales
group by branch, category ) t where rnk = 1;

-- Q3: What is the busiest day of the week for each branch based on transaction volume?

with cte1 as (
select
	branch,
    dayname(date) As day_name,
    count(*) as transaction,
    row_number() over(partition by branch order by branch) as day_rnk
from walmart_sales
group by branch, dayname(date)
)
select * from cte1
where day_rnk = 1;

-- Q4: What are the average, minimum, and maximum ratings for each category in each city?
select
	city,
    category,
    round(avg(rating),2) As avg_rating,
    max(rating) As max_rating,
    min(rating) as min_rating
from walmart_sales
group by city,
    category;

-- Q5: What is the total profit for each category, ranked from highest to lowest?

select 
	category,
    round(sum(quantity * unit_price),2) As revenue,
    round(sum( quantity * unit_price * profit_margin),2) as profit
from walmart_sales
group by category;

-- Q6: What is the most frequently used payment method in each branch?
with cte2 as (
select
	branch,
    payment_method,
    row_number() over(partition by branch order by branch) as rnk
from walmart_sales
group by branch,payment_method
)
select * from cte2
where rnk = 1;


-- Q7: How many transactions occur in each shift (Morning, Afternoon, Evening, and Night) across branches?
-- Morning	6 – 11
-- Afternoon	12 – 16
-- Evening	17 – 20
-- Night	21 – 23 and 0 – 5

select
	branch,
    count(*) As transaction,
    case
		when hour(time) between 6 and 11 then 'Morning'
        when hour(time) between 12 and 16 then 'Afternoon'
        when hour(time) between 17 and 20 then 'Evening'
        else 'Night' end as day_type
from walmart_sales
group by branch, day_type
order by branch;

   
-- Q8: What is the average unit price for each product category, and how does it correlate with customer ratings?
select
	category,
    round(avg(unit_price),2) As avg_unit_price,
    round(avg(rating),2) as avg_rating
from walmart_sales
group by category
order by avg_rating desc;

-- Q9: How does customer rating vary by time of day (Morning, Afternoon, Evening) across all branches?
select * from walmart_sales;
select
	branch,
    round(avg(rating),2) as avg_rating,
    case
		when hour(time) between 6 and 11 then 'Morning'
        when hour(time) between 12 and 16 then 'Afternoon'
        when hour(time) between 17 and 20 then 'Evening'
        else 'Night' end as day_type
from walmart_sales
group by branch, day_type
order by branch;
