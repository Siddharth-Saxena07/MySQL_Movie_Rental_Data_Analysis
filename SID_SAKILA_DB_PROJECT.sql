-- Capstone Project - Movie Rental Data Analysis (Sakila Database)

USE Sakila;
SHOW TABLES;


-- Task1 - Display the full names of actors available in the database.
SELECT * FROM actor;
SELECT actor_id, CONCAT(first_name, ' ', last_name) AS 'ACTORS FULL NAME' FROM actor;









/* 	Task2 - 	Management wants to know if there are any names of the actors appearing frequently.
	Task2a -	Display the number of times each first name appears in the database. */
    
SELECT first_name, COUNT(*) AS frequency
FROM actor
GROUP BY first_name
ORDER BY frequency DESC;







/* Task2b -	What is the count of actors that have unique first names in the database? 
			Display the first names of all these actors.  */

SELECT COUNT(*) AS unique_actors_count
FROM (
    SELECT COUNT(*) AS name_count
    FROM actor
    GROUP BY first_name
    HAVING name_count = 1
) AS unique_actors;

SELECT COUNT(*) AS Count, first_name FROM actor GROUP BY first_name HAVING COUNT(*) = 1;










/* 	Task3 - 	The Management is interested to analyze the similarity in the last names of the actors.
	Task3a -	Display the number of times each last name appears in the database. */
    
SELECT last_name, COUNT(*) AS frequency
FROM actor
GROUP BY last_name
ORDER BY frequency DESC;









/* Task3b -		Display all unique last names in the database. */
Select * from actor;
Select count(*) as Count, last_name from actor Group By last_name Having count(*) = 1;

SELECT DISTINCT last_name
FROM sakila.customer;













/* 	Task4 - 	The Management wants to analyze the movies based on their ratings to determine if they are suitable for kids
				or some parental assistance is required. Perform the following tasks to perform the required analysis.
	Task4a -	Display the list of records for the movies with the rating "R"
				(The movies with the rating "R" are not suitable for the audience under 17 years of age). */
    

SELECT film_id, title, rating
FROM film
WHERE rating = 'R';



/* Task4b -		Display the list of records for the movies that are not rated "R" */

SELECT * FROM film;
SELECT film_id, title, rating
FROM film
WHERE rating != 'R';

select f.film_id, title, rating, c.name from film as f inner join film_category as fc inner join category c on 
f.film_id = fc.film_id and c.category_id = fc.category_id where rating != 'R';


/* Task4c -		Display the list of records for the movies that are suitable for audience below 13 years of age.  */
SELECT film_id, title, rating  FROM film
WHERE rating = 'G' OR rating = 'PG' ORDER BY title;


SELECT film_id, title, rating  FROM film
WHERE rating = 'PG-13' ORDER BY title;


select f.film_id, title, rating from film as f inner join film_category as fc inner join category c on 
f.film_id = fc.film_id and c.category_id = fc.category_id where c.name = 'Children';



/* 	Task5 - 	The board members wants to understand the replacement cost of movie copy(disc - DVD/Blue Ray). The replacement cost 
				refers to the amount charged to the customer if the movie disc is not returned or is returned in a damage stage.
	Task5a -	Display the list of records for the movies where the replacement cost is up to $11. */
	
SELECT title AS 'Movie Titles', replacement_cost FROM film WHERE replacement_cost < 11;
SELECT * FROM film 
WHERE replacement_cost <= 11.00;


  
/* Task5b -		Display the list of records for the movies where the replacement cost is between $11 and $20.  */

SELECT title AS 'Movie Titles', replacement_cost FROM film WHERE replacement_cost BETWEEN 11 AND 20;
SELECT * FROM film WHERE replacement_cost BETWEEN 11 AND 20;


/* Task5c -		Display the list of records for the all movies in descending order of their replacement costs.  */

SELECT * FROM film;
SELECT film_id, title, rating, replacement_cost from film  ORDER BY replacement_cost DESC;


/* Task6 -		Display the names of the top 3 movies with the greatest number of actors.  */

SELECT f.title, COUNT(a.actor_id) AS actor_count
FROM film AS f
JOIN film_actor AS fa ON f.film_id = fa.film_id
JOIN actor AS a ON fa.actor_id = a.actor_id
GROUP BY f.film_id
ORDER BY actor_count DESC
LIMIT 3;




/* Task7 -		'Music of Queen' & 'Kris Kristofferson' have seen an unlikely resurgence. As an unintended consequence, films starting with
				the letters 'K' & 'Q' have also soared in popularity. Display the  titles of the movies starting with the letters 'K' & 'Q'.  */


SELECT title FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%'
ORDER BY title;


/* Task8 -		The film 'Agent Trumen' has been a great success. Display the names of all actors who appeared in this film.  */

SELECT f.title, a.first_name, a.last_name
FROM film AS f
JOIN film_actor AS fa ON f.film_id = fa.film_id 
JOIN actor AS a ON a.actor_id = fa.actor_id WHERE title = 'Agent Truman';




/* Task9 -		Sales have been lagging among young families, so the management wants to promote family movies. 
				Identify all the movies categorized as family films.  */
                
SELECT film_id, title FROM film
WHERE film_id IN (SELECT film_id FROM film_category
					WHERE category_id = (SELECT category_id FROM category
					WHERE name = 'Family'));


SELECT f.title as 'Movies', c.name as 'Genre', f.rating  
FROM film as f
Inner Join film_category as fc
using (film_id) join category as c using (category_id) where c.name in ('children' , 'family');

SELECT film.film_id, film.title FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';



/* 	Task10 - 	The management wants to observe the rental rates and the rental frequencies(Number of time the movie disc is rented).
	Task10a -	Display the maximum, minimum, and average rental rates of movies based on their ratings. The output must be stored
				in descending order of the average rental rates.  */

SELECT * FROM film;
SELECT rating, MAX(rental_rate) AS max_rental_rate, MIN(rental_rate) AS min_rental_rate, AVG(rental_rate) AS avg_rental_rate
FROM film GROUP BY rating ORDER BY avg_rental_rate DESC;
    

/* Task10b -	Display the movies in descending order of their rental frequencies, so the management can maintain more copies of 
				those movies.  */
                
SELECT * FROM rental;    
  
SELECT film_id, title, COUNT(rental_id) AS rental_frequency
FROM film
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
GROUP BY film_id, title
ORDER BY rental_frequency DESC;



/* Task11 -		In how many film categories, the difference between the average film replacement cost (disc - DVD/Blue Ray) and the 
				average film rental rate is greater than $15.  */
                
SELECT * FROM film;
SELECT * FROM film_category;

SELECT COUNT(*) AS category_count
FROM (
    SELECT c.category_id
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY c.category_id
    HAVING (AVG(f.replacement_cost) - AVG(f.rental_rate)) > 15
) AS categories;


/*  Display the list of all film categories identified above, along with the corresponding average film replacement cost and 
	average film rental rate.  */

SELECT c.name AS category_name, AVG(f.replacement_cost) AS avg_replacement_cost, AVG(f.rental_rate) AS avg_rental_rate
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.category_id
HAVING (AVG(f.replacement_cost) - AVG(f.rental_rate)) > 15;



Select category.name, count(category.name) as 'movie_cateogry', (avg(replacement_cost)-avg(rental_rate)) as 'difference_cost'
from film inner join film_category inner join category on film.film_id = film_category.film_id and
film_category.category_id = category.category_id group by category.name having 'difference_cost' > '15'
order by count(category.name) desc;


/* Task12 -		Display the film categories in which the number of movies is greater than 70.  */

SELECT c.name, COUNT(*) AS movie_count
FROM category AS c
JOIN film_category AS fc ON c.category_id = fc.category_id
JOIN film AS f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING COUNT(*) > 70;







 