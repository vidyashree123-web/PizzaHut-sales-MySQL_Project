create database pizzahut;

create table orders (
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id));

create table orders_details (
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id));




-- 1.Retrive the total number of order placed.

select count(order_id) as total_oeder from orders;

-- 2. Calculate the toatal revenue generated from pizza sales. 

select round((orders_details.quantity*pizzas.price),2) as total_sales 
from orders_details join pizzas on pizzas.pizza_id= order_details.pizza_id;

-- 3. Identify the highest-priced pizza.

select pizza_types.name,pizzas.price 
from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc ;

-- 4.Identyfies the most common pizza size order.

select pizzas.size,count(orders_details.order_details_id) order_count
from pizzas 
join orders_details on pizzas.pizza_id=orders_details.pizza_id
group by pizzas.size
order by order_count desc ;

-- 5.list the top 5 most ordered pizza types along with their quatities.

select pizza_types.name,sum(orders_details.quantity) as quantity 
from pizza_types
join pizzas on	pizza_types.pizza_type_id=pizzas.pizza_type_id
join orders_details on orders_details.pizza_id=pizzas.pizza_id
group by pizza_types.name 
order by quantity desc
limit 5;

-- 6.Join the neccessary table ti find total quantity of each pizza category order.

select pizza_types.category, sum(orders_details.quantity) as quantity
from pizza_types
join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join orders_details on orders_details.pizza_id=pizzas.pizza_id
group by pizza_types.category
order by quantity desc;

-- 7. Determine the distibution of orders by  hours of the day.

select hour(order_time), count(order_id) as order_count 
from orders
group by hour(order_time);

-- 8.Join relevent table ti find the category-wise distrubution of pizzas.

select category,count(name) 
from pizza_types
group by category;

-- 9.Group the orders by date and calculate average number of pizzas ordered per day.

select round(avg(quantity),0) as avg_perday 
from 
( select orders.order_date,sum(orders_details.quantity) as quantity
from orders
join orders_details on orders.order_id=orders_details.order_id
group by orders.order_date) as order_quantity;

-- 10. Determine the top 3 most ordered pizza based on the revenue.

select pizza_types.category,round(sum(orders_details.quantity*pizzas.price),2) as revenue
from pizza_types 
join pizzas on pizzas.pizza_type_id=pizza_types.pizza_type_id
join orders_details on orders_details.pizza_id=pizzas.pizza_id
group by pizza_types.category
order by revenue;

-- 11.calculate the percentage contributon of each pizzatype total revenue.

select pizza_types.category, 
round(sum(orders_details.quantity* pizzas.price)/ 
(select round(sum(orders_details.quantity*pizzas.price),2) as total_sales
from orders_details
join pizzas on pizzas.pizza_id=orders_details.pizza_id)*100,0) as revenue
from pizza_types
join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join orders_details on orders_details.pizza_id=pizzas.pizza_id
group by pizza_types.category 
order by revenue desc;

-- 12. Analyze the cumulative revenue generated over time.

select order_date, sum(revenue) over(order by order_date) as cum_revenue
from
(select orders.order_date,sum(orders_details.quantity*pizzas.price) as revenue 
from orders_details
join pizzas on orders_details.pizza_id=pizzas.pizza_id
join orders on orders.order_id=orders_details.order_id
group by orders.order_date) as sales;

-- 13. Determine the top 3 most order pizza type based on the revenue for each pizza category.

select name, revenue from
(select category, name, revenue, rank() over(partition by category order by revenue desc) as rn from
(select pizza_types.category,pizza_types.name,sum(orders_details.quantity*pizzas.price) as revenue
from pizza_types
join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join orders_details on orders_details.pizza_id=pizzas.pizza_id
group by pizza_types.category,pizza_types.name) as a) as b
where rn<=3;




 


























 




























