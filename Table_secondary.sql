CREATE TABLE t_katerina_pokorna_project_SQL_secondary_final AS
	SELECT
		c.country,
		e.year,
		e.gdp,
		e.gini,
		e.population
	FROM countries AS c
	JOIN economies AS e
		ON c.country = e.country
	WHERE e.year BETWEEN 2006 AND 2018
		AND c.continent = 'Europe';