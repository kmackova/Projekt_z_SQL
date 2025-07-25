-- 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce,
-- projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

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
),
base_for_corr AS (
	SELECT
		year,
		category,
		(value - previous_value)/previous_value AS value_change,
		LEAD((value - previous_value)/previous_value) OVER (PARTITION BY category ORDER BY year) AS lead_value_change
	FROM price_chng
	UNION
	SELECT
		year,
		'Mzdy' AS category,
		(value - previous_value)/previous_value AS value_change,
		LEAD((value - previous_value)/previous_value) OVER (ORDER BY year) AS lead_value_change
	FROM payroll_chng
),
gdp AS (
	SELECT
		year,
		(gdp - LAG(gdp) OVER (ORDER BY year))/LAG(gdp) OVER (ORDER BY year) AS gdp_change
	FROM t_katerina_pokorna_project_SQL_secondary_final
	WHERE country = 'Czech Republic'
)
SELECT
	bc.category,
	ROUND(CORR(bc.value_change, gdp.gdp_change)::NUMERIC, 2) AS correlation,
	ROUND(CORR(bc.lead_value_change, gdp.gdp_change)::NUMERIC, 2) AS correlation_next_year
FROM base_for_corr AS bc
JOIN gdp
	ON bc.year = gdp.year
GROUP BY bc.category
ORDER BY correlation_next_year DESC;
