USE sakila;
-- 1. Enumera cada par de actores que han trabajado juntos.
SELECT 
    CONCAT(a1.first_name, ' ', a1.last_name) AS actor1,
    CONCAT(a2.first_name, ' ', a2.last_name) AS actor2
FROM 
    film_actor fa1
JOIN 
    film_actor fa2 ON fa1.film_id = fa2.film_id
JOIN 
    actor a1 ON fa1.actor_id = a1.actor_id
JOIN 
    actor a2 ON fa2.actor_id = a2.actor_id
WHERE 
    a1.actor_id < a2.actor_id
ORDER BY 
    actor1, actor2;
    
-- 2. Para cada película, enumera los actores que han actuado en más películas.
SELECT 
    f.title AS pelicula,
    CONCAT(a.first_name, ' ', a.last_name) AS actor,
    fa.num_peliculas_actuadas
FROM (
    SELECT 
        fa.film_id,
        fa.actor_id,
        COUNT(*) AS num_peliculas_actuadas,
        ROW_NUMBER() OVER (PARTITION BY fa.film_id ORDER BY COUNT(*) DESC) AS row_num
    FROM 
        film_actor fa
    GROUP BY 
        fa.film_id,
        fa.actor_id
) AS fa
JOIN actor a ON fa.actor_id = a.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE fa.row_num = 1
ORDER BY f.title;

-- Total de peliculas en las que ha aactuado cada actor.
SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actor,
    SUM(num_peliculas_actuadas) AS total_peliculas_actuadas
FROM 
    (SELECT 
        fa.actor_id,
        COUNT(*) AS num_peliculas_actuadas
    FROM 
        film_actor fa
    GROUP BY 
        fa.actor_id) AS peliculas_por_actor
JOIN 
    actor a ON peliculas_por_actor.actor_id = a.actor_id
GROUP BY 
    a.actor_id
ORDER BY 
    total_peliculas_actuadas DESC;

