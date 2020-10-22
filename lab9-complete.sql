# Lab | SQL Queries 9

### Instructions
use sakila;

#We will be trying to predict if a customer will be renting a film this month based on their previous activity and other details. We will first construct a table with:

-- 1. Customer ID
-- 2. City
-- 3. Most rented film category
-- 4. Total films rented
-- 5. Total money spent
-- 6. How many films rented last month

#and try to predict if he will be renting this month.
#Use date range (`15/05/2005` - `30/05/2005`) for last month and (`15/06/2005` - `30/06/2005`) for this month.

-- From this query we get Customer ID, City, Total Films Rented and Total Money Spent
select c.customer_id as "Customer ID", ci.city as "City", count(p.rental_id) as "Total Films Rented",sum(p.amount) as "Total Money Spent" from sakila.customer as c
left join sakila.address as a
on c.address_id=a.address_id
left join sakila.city as ci
on a.city_id=ci.city_id
left join sakila.payment as p
on c.customer_id=p.customer_id
group by c.customer_id
order by c.customer_id;

-- Most rented Film Category
Drop view ranked_categories;

with cte_ranked_categories as (select r.customer_id, c.name, count(r.rental_id) as rented_movies, row_number() over (partition by customer_id order by count(r.rental_id) desc) as Position from sakila.rental as r
join sakila.inventory as i
on r.inventory_id=i.inventory_id
join sakila.film_category as fc
on i.film_id=fc.film_id
join sakila.category as c
on fc.category_id=c.category_id
group by customer_id, name
order by customer_id, count(r.rental_id) desc)
select*from cte_ranked_categories 
where Position=1;

-- Films rented last month
select c.customer_id as "Customer ID", count(r.rental_id) as "Last month rentals" from sakila.customer as c
left outer join sakila.rental as r
on c.customer_id=r.customer_id and (r.rental_date >= '2005-05-15') and (r.rental_date <= '2005-05-30')
group by c.customer_id
order by c.customer_id;

-- Films rented this month
select c.customer_id as "Customer ID", count(r.rental_id) as "Last month rentals" from sakila.customer as c
left outer join sakila.rental as r
on c.customer_id=r.customer_id and (r.rental_date >= '2005-06-15') and (r.rental_date <= '2005-06-30')
group by c.customer_id
order by c.customer_id;




