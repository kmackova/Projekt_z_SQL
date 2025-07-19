-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- porovnání meziroční
SELECT
	year,
	category,
	value - LAG(value) OVER (PARTITION BY category ORDER BY year) AS salary_change
FROM t_katerina_pokorna_project_SQL_primary_final
WHERE value_type = 'payroll'
ORDER BY salary_change;

-- porovnání první a poslední období
SELECT DISTINCT
	category,
	LAST_VALUE(value) OVER (PARTITION BY category ORDER BY year ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
		- FIRST_VALUE(value) OVER (PARTITION BY category ORDER BY year)		
			AS salary_change
FROM t_katerina_pokorna_project_SQL_primary_final
WHERE value_type = 'payroll'
ORDER BY salary_change;


