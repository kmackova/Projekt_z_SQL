# Projekt z SQL

## ZADÁNÍ PROJEKTU

Úkolem projektu je připravit podklady pro oblast dostupnosti základních potravin široké veřejnosti a odpovědět na zadané otázky týkající se tohoto tématu.

### Datové sady, které je možné použít pro získání vhodného datového podkladu:

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
- *t_katerina_pokorna_project_SQL_secondary_final* (tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR)
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

### Tvorba secondary podkladové tabulky

- data pocházejí z tabulky *economies*
- zahrnuté jsou pouze roky 2006 - 2018 jako u primary tabulky
- k filtrování pouze evropských států je použita tabulka *countries*, která zahrnuje i mapování zemí na jednotlivé kontinenty 

### Odpovědi na výzkumné otázky

**1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**

Pokud se díváme na meziroční změny, mzdy většinou rostou. Až na výjimky - největší pokles zaznamenala oblast Peněžnictví a pojišťovnictví a to v roce 2013.
V dlouhodobém horizontu (pokud porovnáme data za poslední a první dostupné období), mzdy rostou ve všech odvětvích.

**2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**

- první období (rok 2006): 1 212 kg chleba a 1 353 l mléka za průměrnou měsíční mzdu
- poslední období (rok 2018): 1 322 kg chleba a 1 617 l mléka za průměrnou měsíční mzdu

**3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)**

Ceny potravin se vyvýjely hodně nerovnoměrně. Ve sledovaném období zaznamenala každá kategorie potravin jak různě vysoký meziroční nárůst, tak pokles ceny. Pokud se podíváme pouze na percentuální meziroční změny, nelze jednoznačně určit, která kategorie potravin zdražuje nejpomaleji.

Dívala jsem se tedy na vývoj cen i dlouhodobě a pro každou kategorii se snažila spočítat nějakou "průměrnou" míru meziroční změny - interpolovala jsem ji z dat za první a poslední dostupné období (roky 2006 a 2018) tak, aby vycházelo, že pokud se bude cena kategorie zboží měnit každý rok touto mírou, z ceny v roce 2006 se dostane na pozorovanou cenu v roce 2018. Tuto konstantní meziroční míru změny ceny jsem pro každou kategorii spočítala jako:

(cena v roce 2018 / cena v roce 2006)^(1/(2018 – 2006))

Pro kategorii “Jakostní víno bílé” je změna počítána od roku 2015, od kdy je její cena sledována.

Tato interpolovaná percentuální meziroční změna ukazuje pokles cen pro kategorie potravin "Cukr krystalový" a "Rajská jablka červená kulatá". Ostatní kategorie pak zdražují, nejpomaleji zdražují "Banány žluté".

**4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**

Pokud porovnáváme meziroční změnu cen jednotlivých kategorií potravin s meziroční změnou průměrných mezd, pak téměř v každém roce za sledované období existuje kategorie potravin, u které je nárůst ceny vyšší o více než 10% než růst mezd.

**5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?**

Máme k dispozici velice krátkou časovou řadu, z které nemůžeme odvodit nějaké silné závěry, spíše domněnky. Z předchozích výsledků víme, že ceny potravin se vyvíjejí velice nerovnoměrně a dá se očekávat, že jejich změny budou souviset i s jinými faktory než HDP, např. dostupností konkrétní potraviny, kvalitou úrody v aktuálním roce, situací v zahraničí u dovážených surovin atd. Z vizuální analýzy závislosti vývoje cen potravin a HDP toho tedy moc nevyčteme, závislost mezd a HDP by se podle grafického znázornění mohla jevit s ročním zpožděním.

Pokud si spočítáme korelační koeficienty, nejzajímavější se zdá právě korelace mezi HDP a mzdami zpožděnými o 1 rok (korelační koeficient asi 0.70).


















