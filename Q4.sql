-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin
-- výrazně vyšší než růst mezd (větší než 10 %)?


-- roky, ve kterých aspoň jedna kategorie potravin zdražuje více, než růst mezd + 10 %
WITH price_chng AS (
	SELECT
		year,
		category,
		value,
		LAG(value) OVER (PARTITION BY category ORDER BY year) AS previous_value
	FROM t_katerina_pokorna_project_SQL_primary_final
	WHERE value_type = 'price'
),
payroll_chng AS (
	SELECT
		year,
		value,
		LAG(value) OVER (PARTITION BY category ORDER BY year) AS previous_value
	FROM t_katerina_pokorna_project_SQL_primary_final
	WHERE value_type = 'payroll'
		AND category IS NULL
)
SELECT DISTINCT
	pc.year
FROM price_chng AS pc
JOIN payroll_chng AS pay
	ON pc.year = pay.year
WHERE (pc.value - pc.previous_value)/pc.previous_value - (pay.value - pay.previous_value)/pay.previous_value > 0.1
ORDER BY pc.year;

-- pro doplnění - seznam případů, kdy byla změna ceny nějaké kategorie potravin vyšší o víc než 10 % než růst mezd
WITH price_chng AS (
	SELECT
		year,
		category,
		value,
		LAG(value) OVER (PARTITION BY category ORDER BY year) AS previous_value
	FROM t_katerina_pokorna_project_SQL_primary_final
	WHERE value_type = 'price'
),
payroll_chng AS (
	SELECT
		year,
		value,
		LAG(value) OVER (PARTITION BY category ORDER BY year) AS previous_value
	FROM t_katerina_pokorna_project_SQL_primary_final
	WHERE value_type = 'payroll'
		AND category IS NULL
)
SELECT
	pc.year,
	pc.category,
	(pc.value - pc.previous_value)/pc.previous_value AS price_change,
	(pay.value - pay.previous_value)/pay.previous_value AS salary_change,
	(pc.value - pc.previous_value)/pc.previous_value - (pay.value - pay.previous_value)/pay.previous_value
		AS change_diff
FROM price_chng AS pc
JOIN payroll_chng AS pay
	ON pc.year = pay.year
WHERE (pc.value - pc.previous_value)/pc.previous_value - (pay.value - pay.previous_value)/pay.previous_value > 0.1
ORDER BY change_diff DESC;