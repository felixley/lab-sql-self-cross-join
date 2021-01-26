use sakila; 

-- Get all pairs of actors that worked together.
select a.actor_id as ActorID, b.actor_id as PartnerID, a.film_id as Film
from sakila.film_actor as a
join sakila.film_actor as b
on a.actor_id <> b.actor_id
and a.film_id = b.film_id
group by Film, ActorID, PartnerID
order by ActorID;

-- Get all pairs of customers that have rented the same film more than 3 times.

-- missunderstanding the question
select count(a.film_id), a.film_id, b.customer_id, c. customer_id
from sakila.inventory as a
join sakila.rental as b
using(inventory_id)
join sakila.rental as c
on b.inventory_id = c.inventory_id
and b.customer_id <> c.customer_id
group by  b.customer_id, c.customer_id
having count(a.film_id) > 3;

-- second try
select count(b.film_id) as NoRentals, a.customer_id as Customer1, a2.customer_id as Customer2
from sakila.rental as a
join sakila.inventory as b
using (inventory_id)
join sakila.inventory as c
on b.film_id = c.film_id
-- ========================
join sakila.inventory as c2
on c.film_id = c2.film_id
join sakila.inventory as b2
on b2.inventory_id = b.inventory_id
join sakila.rental as a2
on a2.inventory_id = a.inventory_id
group by Customer1, Customer2;


-- right solution from Anna...:
select count(f1.title) as n_movies,
	c1.customer_id as customer_1, c1.first_name, c1.last_name,
	c2.customer_id as customer_2, c2.first_name, c2.last_name
from sakila.customer as c1
	join sakila.rental as r1 on c1.customer_id = r1.customer_id
	join sakila.inventory as i1 on r1.inventory_id=i1.inventory_id
	join sakila.film as f1 on i1.film_id=f1.film_id
    #going the path backwards to find customer with the same rented movies
    join sakila.inventory as i2 on i2.film_id=f1.film_id
    join sakila.rental as r2 on i2.inventory_id =r2.inventory_id
    join sakila.customer as c2 on r2.customer_id=c2.customer_id
#using greater than to drop duplicates
where c1.customer_id>c2.customer_id
group by c1.customer_id, c1.first_name, c1.last_name, c2.customer_id, c2.first_name, c2.last_name
Having n_movies>3
order by n_movies desc;

-- Get all possible pairs of actors and films.
select film_id, actor_id
from (select distinct actor_id from sakila.film_actor) as sub1
cross join(select distinct film_id from sakila.film_actor) as sub2;

select * from (select distinct actor_id from actor) as sub1
cross join (select distinct title from film) as sub2
order by actor_id;

select * from (select distinct title from film) as sub2
cross join (select distinct concat(first_name," ",last_name) from actor) as sub1
order by title;