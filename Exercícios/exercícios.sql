#===============================================================================
#Vamos fazer alguns exercícios usando a tabela san_francisco_salaries, gere:
#1. tabela com a média de totalpay  por jobtitle
#2. Uma tabela com a soma de totalpay por jobtitle
#3. uma tabela com o maior e o menor salário com o nome do funcionário
#4. uma tabela com a média do totalpaybenefits por ano.
#5. uma tabela com o número de funcionários por jobtitle
#===============================================================================
#exercício 1
    SELECT 
        jobtitle,
        AVG(totalpaybenefits) AS media_salarial
    FROM san_francisco_salaries
    GROUP BY jobtitle
    LIMIT 1000
#===============================================================================
#exercício 2
    SELECT
        jobtitle,
        SUM(totalpay)
    FROM san_francisco_salaries
    GROUP BY jobtitle
    ORDER SUM(totalpay) DESC
    LIMIT 1000
#===============================================================================
#exercício 3
    SELECT 
        jobtitle,
    MAX(totalpay),
    MIN(totalpay)
    FROM san_francisco_salaries
    GROUP BY jobtitle
    LIMIT 1000
#===============================================================================
#exercício 4
    SELECT 
        employeename,
        jobtitle,
        MIN(totalpaybenefits),
        MAX(totalpaybenefits)
    FROM san_francisco_salaries
    GROUP BY employeename, jobtitle
    LIMIT 1000
#===============================================================================
#exercício 5
    SELECT 
    AVG(san_francisco_salaries.totalpaybenefits),
    year
    FROM san_francisco_salaries
    GROUP BY year
#===============================================================================
    SELECT
        jobtitle,
        COUNT(id) AS n_func
    FROM san_francisco_salaries
    GROUP BY jobtitle
    ORDER BY n_func DESC
#===============================================================================
#Usando a tabela  SAN FRANCISCO SALARIES, gere uma tabela com todos os campos e cast os os valores que estão como stringers para decimal. 
#os campos são basepay, otherpay e benefits. Limite o resultado para 1000 linhas
    SELECT
        id,
        employeename,
        jobtitle,
        CAST(basepay AS DECIMAL),
        CAST(overtimepay AS DECIMAL),
        CAST(otherpay AS DECIMAL),
        CAST(benefits AS DECIMAL),
        totalpay,
        totalpaybenefits,
    year,
        agency,
        status
    FROM san_francisco_salaries
    LIMIT 1000
#===============================================================================
#exercício de sql para dias da semana
    SELECT 
        date_2,
        (SUM(available_impressions) - SUM(impressions)) AS impressions_not_sales
    FROM 
        clean_ads_data
    GROUP BY 
        date_2
    ORDER BY date_2
#===============================================================================
#Agora usando a mesma Query, apresente o mesmo resultado mas apenas para as campanhas 
#que foram rodadas entre as 10 da manhã e 5 da tarde.
    SELECT 
        date_2,
        (SUM(available_impressions) - SUM(impressions)) AS impressions_not_sales
    FROM 
        clean_ads_data
    WHERE hour_of_day BETWEEN 10 AND 17
    GROUP BY 
        date_2
    ORDER BY date_2
===============================================================================
#Escreva uma Query que gere uma tabela com o bonus por Status
#em seguida, usando a emsma query gere uma tabela com a média total + bonus por status

    select 
        employee_id,
        status,
        (salary * bonus) as bonus_pago
    from employee_status
    group by status
    order by bonus_pago DESC ;

    Select 
    employee_id,
    status,
    avg (salary) * avg(bonus) + avg(salary) as bonus_pago
    from employee_status
    group by status
    order by bonus_pago DESC
===============================================================================
##selecionando apenas bairros com mais de 50 propriedades
    SELECT
        neighbourhood,
        avg_price
    FROM 
            (SELECT 
            neighbourhood,
            COUNT(id) as number_properties,
            avg (price) as avg_price
            FROM boston_airbnb_listings
            WHERE neighbourhood IS NOT NULL
            AND price >= 150
            AND room_type = "Entire home/apt"
            GROUP BY neighbourhood
            ORDER BY COUNT(id) DESC ) as x
    WHERE number_properties >=50