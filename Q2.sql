--2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední
--srovnatelné období v dostupných datech cen a mezd?

WITH price_data AS (
	SELECT DISTINCT
		category,
		price_value,
		price_unit,
		FIRST_VALUE(value) OVER (PARTITION BY category ORDER BY year) AS first_price,
		LAST_VALUE(value) OVER (PARTITION BY category ORDER BY year ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
			AS last_price
	FROM t_katerina_pokorna_project_SQL_primary_final
	WHERE value_type = 'price'
		AND category IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
),
payroll_data AS (
	SELECT DISTINCT
		FIRST_VALUE(value) OVER (PARTITION BY category ORDER BY year) AS first_salary,
		LAST_VALUE(value) OVER (PARTITION BY category ORDER BY year ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
			AS last_salary
	FROM t_katerina_pokorna_project_SQL_primary_final
	WHERE value_type = 'payroll'
		AND category IS NULL
)
SELECT
	pd.category,
	ROUND(pay.first_salary/pd.first_price) AS affordable_volume_2006,
	ROUND(pay.last_salary/pd.last_price) AS affordable_volume_2018,
	pd.price_value,
	pd.price_unit
FROM price_data AS pd
CROSS JOIN payroll_data AS pay;
