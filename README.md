# Projekt z SQL

## ZADÁNÍ PROJEKTU

Úkolem projektu je připravit podklady pro oblast dostupnosti základních potravin široké veřejnosti a odpovědět na zadané otázky týkající se tohoto tématu.

### Datové sady, které je možné požít pro získání vhodného datového podkladu:

**Primární tabulky:**
1. *czechia_payroll* – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
2. *czechia_payroll_calculation* – Číselník kalkulací v tabulce mezd.
3. *czechia_payroll_industry_branch* – Číselník odvětví v tabulce mezd.
4. *czechia_payroll_unit* – Číselník jednotek hodnot v tabulce mezd.
5. *czechia_payroll_value_type* – Číselník typů hodnot v tabulce mezd.
6. *czechia_price* – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
7. *czechia_price_category* – Číselník kategorií potravin, které se vyskytují v našem přehledu.

**Číselníky sdílených informací o ČR:**
1. czechia_region – Číselník krajů České republiky dle normy CZ-NUTS
2. 2.czechia_district – Číselník okresů České republiky dle normy LAU.

**Dodatečné tabulky:**
1. countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
2. economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.

### Výzkumné otázky
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

### Výstupy z projektu
1. Dvě tabulky v databázi, ze kterých se požadovaná data dají získat:
- *t_katerina_pokorna_project_SQL_primary_final* (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky)
- *t_katerina_pokorna_project_SQL_secondary_final* (pro dodatečná data o dalších evropských státech)
2. Sada SQL, které z připravených tabulek získají datový podklad k odpovězení na vytyčené výzkumné otázky
3. Popis mezivýsledků (průvodní listina) a informace o výstupních datech

## ŘEŠENÍ PROJEKTU

### Tvorba primary podkladové tabulky
**Data za mzdy**
- základní data za mzdy jsou z tabulky *czechia_payroll*
- použila jsem přepočtené hodnoty mezd (calculation_code = 200, podle číselníku *czechia_payroll_calculation*)
- použila jsem jenom data za mzdy (value_type_code = 5958, podle číselníku *czechia_payroll_value_type*), data za počty zaměstnanců jsem nezahrnovala, protože jsou neúplná
- i když jsou data za mzdy dostupná po kvartálech, do podkladové tabulky jsem zahrnula pouze roční průměry, protože otázky jsou směřovány spíše na meziroční vývoj
- industry_branch_code NULL znamená průměrné mzdy za všechna odvětví
- do tabulky jsou namapovány názvy odvětví z číselníku *czechia_payroll_industry_branch*
- číselník *czechia_payroll_unit* má pravděpodobně přehozené položky, brala jsem ho tedy v opačném pořadí
- do podkladové tabulky jsou zahrnuta pouze data za roky 2006 - 2018 (společné období pro dostupná data za mzdy a ceny)

**Data za ceny**
- základní data za ceny pocházejí z tabulky *czechia_price*
- mapování názvů jednotlivých kategorií potravin pochází z číselníku *czechia_price_category*
- do podkladové tabulky jsem zahrnula pouze roční průměry, stejně jako u mezd
- data jsou dostupná pro roky 2006 - 2018 (kategorie Jakostní víno bílé se v datech objevuje až od roku 2015)
- data v detailu po regionech nejsou pro zodpovězení otázek potřeba, do podkladové tabulky jsem je tedy ani nezahrnovala (vzala jsem pouze data odpovídající region_code = NULL za celou republiku)


















