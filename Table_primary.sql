CREATE TABLE t_katerina_pokorna_project_SQL_primary_final AS
	WITH prices AS (
		SELECT
			date_part('year', date_from) AS year,
			category_code,
			AVG(value) AS avg_price
		FROM czechia_price
		WHERE region_code IS NULL
		GROUP BY
			category_code,
			date_part('year', date_from)
	),
	payroll AS (
		SELECT
			payroll_year AS year,
			industry_branch_code,
			AVG(value) AS avg_wage	
		FROM czechia_payroll
		WHERE calculation_code = 200
			AND value_type_code = 5958
			AND payroll_year BETWEEN 2006 AND 2018
		GROUP BY
			industry_branch_code,
			payroll_year
	)
	SELECT 
		'price' AS value_type,
		p.year AS year,
		cpc.name AS category,
		p.avg_price AS value,
		cpc.price_value,
		cpc.price_unit
	FROM prices AS p
	JOIN czechia_price_category AS cpc
		ON p.category_code = cpc.code
	UNION
	SELECT
		'payroll' AS value_type,
		pay.year AS year,
		cpib.name AS category,
		pay.avg_wage AS value,
		NULL AS price_value,
		NULL AS price_unit
	FROM payroll AS pay
	LEFT JOIN czechia_payroll_industry_branch as cpib
		ON pay.industry_branch_code = cpib.code;
