-- 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

-- min, max a avg za percentuální změny, abychom viděli, že meziroční změny se chovají hodně různě
WITH price_chng AS (
	SELECT
		year,
		category,
		value,
		LAG(value) OVER (PARTITION BY category ORDER BY year) AS previous_value
	FROM t_katerina_pokorna_project_SQL_primary_final
	WHERE value_type = 'price'
)
SELECT
	category,
	MIN((value - previous_value)/previous_value) AS min_change,
	MAX((value - previous_value)/previous_value) AS max_change,
	AVG((value - previous_value)/previous_value) AS avg_change
FROM price_chng
GROUP BY category;


-- dlouhodobý pohled, spočítáme interpolovanou percentuální míru růstu mezi lety 2006 a 2018
-- (cena v roce 2018/cena v roce 2006)^(1/(2020 – 2006))

WITH price_chng AS (
	SELECT DISTINCT
		category,
		FIRST_VALUE(value) OVER (PARTITION BY category ORDER BY year) AS first_price,
		LAST_VALUE(value) OVER (PARTITION BY category ORDER BY year ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
			AS last_price,
		MIN(year) OVER (PARTITION BY category) AS min_year,
    		MAX(year) OVER (PARTITION BY category) AS max_year
	FROM t_katerina_pokorna_project_SQL_primary_final
	WHERE value_type = 'price'
)
SELECT
	category,
	POWER(last_price/first_price, 1.0/(max_year - min_year)) - 1 AS avg_change_rate,
	ROUND(((POWER(last_price/first_price, (1.0/(max_year - min_year))) - 1)*100)::numeric, 2)  || '%'
		AS rate_as_percent
FROM price_chng
ORDER BY avg_change_rate;
