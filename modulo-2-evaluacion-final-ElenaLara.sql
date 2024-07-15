-- EVALUACION MODULO 2 - ELENA LARA

USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title
FROM film
WHERE rating = "PG-13";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description
FROM film
WHERE description LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title
FROM film
WHERE length > 120;

-- 5. Recupera los nombres de todos los actores.

SELECT first_name As Nombre, last_name AS Apellido
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name As Nombre, last_name AS Apellido
FROM actor
WHERE last_name LIKE '%gibson%';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
/* QUERY DE COMPROBACIÓN
SELECT  actor_id, first_name As Nombre
FROM actor
WHERE actor_id BETWEEN 10 and 20;*/

SELECT first_name As Nombre
FROM actor
WHERE actor_id BETWEEN 10 and 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
/* QUERY DE COMPROBACIÓN
SELECT title, rating
FROM film
WHERE rating NOT IN ('R', 'PG-13');*/

SELECT title
FROM film
WHERE rating NOT IN ('R', 'PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT COUNT(film_id) AS Cantidad_total_peliculas, rating AS Clasificación
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
-- uso left join ya que indica cantidad TOTAL de peliculas.

SELECT COUNT(r.rental_id) AS Cantidad_peliculas_alquiladas, c.customer_id, c.first_name AS Nombre, c.last_name AS Apellido
FROM rental AS r
LEFT JOIN customer AS c
USING (customer_id)
GROUP BY customer_id;


-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT COUNT(r.rental_id) AS Cantidad_peliculas_alquiladas, f.category_id, catg.name AS Nombre
FROM rental AS r
INNER JOIN inventory AS i
USING (inventory_id)
INNER JOIN film_category As f
USING (film_id)
INNER JOIN category AS catg
USING (category_id)
GROUP BY f.category_id;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
-- uso Round para redondear los decimales y salga resultado más limpio.

SELECT rating AS Clasificación, ROUND(AVG(length), 2) AS Duracion_promedio
FROM film
GROUP BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
/* QUERY COMPROBACIÓN
SELECT a.first_name AS Nombre, a.last_name AS Apellido, f.title
FROM film as f
INNER JOIN film_actor as fa
USING (film_id)
INNER JOIN actor as a
USING (actor_id)
WHERE f.title = 'Indian Love';*/

SELECT a.first_name AS Nombre, a.last_name AS Apellido
FROM film AS f
INNER JOIN film_actor AS fa
USING (film_id)
INNER JOIN actor AS a
USING (actor_id)
WHERE f.title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
-- uso left join para ver todos los registros de la tabla actores para que si uno es nulo y no aparezca en pelicula, nos de el resultado.
SELECT fi.actor_id, a.first_name, a.last_name
FROM actor AS a
LEFT JOIN film_actor AS fi
USING (actor_id)
WHERE fi.actor_id IS NULL;

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
/* QUERY DE COMPROBACION
SELECT title, release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;*/

SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010;


-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT f.title AS Titulo_peli
FROM film AS f
INNER JOIN film_category AS fi
USING (film_id)
INNER JOIN category AS cat
USING (category_id)
WHERE cat.name = 'Family';

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT a.first_name AS Nombre , a.last_name AS Apellido, COUNT(fi.film_id) AS Numero_pelis_hechas
FROM actor AS a
INNER JOIN film_actor AS fi
USING (actor_id)
GROUP BY fi.actor_id
HAVING Numero_pelis_hechas > 10;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title AS Titulo
FROM film
WHERE rating = 'R' AND length > 120;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT name AS Nombre_categoria, ROUND(AVG(f.length), 2) AS Promedio_duracion
FROM category AS catg
INNER JOIN film_category AS fc
USING (category_id)
INNER JOIN film AS f
USING (film_id)
GROUP BY Nombre_categoria
HAVING AVG(f.length) >120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
SELECT a.first_name AS Nombre ,  COUNT(fi.film_id) AS Numero_pelis_actuado
FROM actor AS a
INNER JOIN film_actor AS fi
USING (actor_id)
GROUP BY fi.actor_id
HAVING Numero_pelis_actuado >= 5;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

-- 1º busco la información para hacer la subconsulta, he utilizado DATEDIFF mirando documentación SQL para encontrar la fórmula de diferencia de dias.
(SELECT r.rental_id
							FROM rental AS r
							WHERE DATEDIFF(return_date, rental_date) > 5)
                            
-- 2º monto el resto de la consulta

SELECT DISTINCT f.title
FROM film AS f
LEFT JOIN inventory AS i USING(film_id)
LEFT JOIN rental AS r USING (inventory_id)
WHERE r.rental_id IN (SELECT r.rental_id
							FROM rental AS r
							WHERE DATEDIFF(return_date, rental_date) > 5);


/*23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta
para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores */

-- 1º busco la información y las relaciones para hacer la subconsulta
(SELECT a.actor_id
FROM actor AS a
INNER JOIN film_actor AS fi USING (actor_id)
INNER JOIN film_category AS fc USING (film_id)
INNER JOIN category AS c USING (category_id)
WHERE c.name = 'Horror')

-- 2º monto el resto de la consulta EXCLUYENDO a los de Horror

SELECT a.first_name AS Nombre, a.last_name AS Apellido
FROM actor AS a
WHERE a.actor_id NOT IN (SELECT DISTINCT a.actor_id
						FROM actor AS a
							INNER JOIN film_actor AS fi USING (actor_id)
							INNER JOIN film_category AS fc USING (film_id)
							INNER JOIN category AS c USING (category_id)
								WHERE c.name = 'Horror')

/*OTRA MANERA DE HACERLO ES MEDIANTE LA CATEGORIA 11 QUE ES HORROR EN LA TABLA CATEGORY QUE SE CRUZA CON FILM CATEGORY A TRAVÉS 
DE FILM_ID A SU VEZ CON FILM_ACTOR PARA ACCEDER CON ACTOR_ID A ACTOR*/

SELECT a.first_name AS nombre, a.last_name AS apellido
FROM actor AS a
WHERE a.actor_id NOT IN (SELECT fi.actor_id
							FROM film_actor AS fi
							INNER JOIN film AS f USING (film_id)
							INNER JOIN film_category AS fc USING (film_id)
                            INNER JOIN category AS c USING (category_id)
							WHERE c.category_id =11);

-- BONUS
-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.


/*25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido 
de los actores y el número de películas en las que han actuado juntos.*/

