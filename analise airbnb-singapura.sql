# Quantas listagens de propriedades tivemos em 2022, qual o preço médio da diária e qual a quantidade de bairros em Singapura?
    SELECT
        count(distinct(lis.id)) as count_properties,
        count(distinct(lis.neighbourhood_cleansed)) as neighbourhood,
        avg(cal.price) as avg_price
    FROM listings as lis
        JOIN calendar as cal ON listings.id=calendar.listing_id
    WHERE lis.id is not null
        and lis.neighbourhood_cleansed is not null
        and cal.price is not null
#=============================================================================================================================
 #Quantas listagens cada bairro possui?
    SELECT
        count (DISTINCT(id)) as listings,
        neighbourhood_cleansed
    from 
        listings
    group by neighbourhood_cleansed
    order by listings DESC
#=============================================================================================================================
#Qual tipo de acomodações são mais populares? espaços inteiros, espaços compartilhados, propriedades com quantos quartos?
#quantidade de listagem por número de quartos
    SELECT
        count (DISTINCT(id)) as listings,
        bedrooms
    from 
        listings
    Where bedrooms is not NULL
        and id is not null
    group by 
        bedrooms
    order by listings DESC

#TIPO DE PROPRIEDADE MAIS POPULAR
#número de listagens por room_type
    SELECT
        count (DISTINCT(id)) as listings,
        room_type
    from 
        listings
    WHERE id is not null
        and room_type is not null
    GROUP BY  
        room_type
    ORDER BY listings DESC
#=================================================================================================================================
#4Quais bairros possuem a maior taxa de ocupação? isto é, que possuem, na média, um maior tempo com suas propriedades sendo alugadas.
#taxa de ocupação isto é, em 365 dias, quanto tempo elas NÃO estavam disponíveis para lugar. Quando mais próximo de 100% melhor.
    SELECT
        id, 
        neighbourhood_cleansed,
        availability_365,
        (availability_365/365) *100 as vacancy_rate,
        (100-((availability_365/365) *100 )) as ocupation_rate
    FROM listings
    order by ocupation_rate DESC

#Nesse caso, não é interessante saber necessariamente quanto cada propriedade, individualmente, estave ocupada, por isso, é melhor agruparmos por bairro, 
#para avergiuar qual possui Bairro possui a maior taxa, para isso, tiramos a média que as propriedades passam disponíveis para locação durante os 365 dias do ano

    #MÉDIA QUE AS PROPRIEDADES QUE DISPONÍVEIS PARA VENDA DURANTE O PERÍODO DE 365 DIAS POR BAIRRO
    SELECT
        neighbourhood_cleansed,
        avg(availability_365), #na media, quantos dias do ano as propriedades desse Bairro passam disponíveis?
        (100-(AVG (availability_365)/365)*100) as ocupation_rate
        from listings
    group by neighbourhood_cleansed
    order by ocupation_rate DESC
#===================================================================================================================================
#Mas qual a distribuição de propriedades ao longo desses bairros com maior taxa de ocupação?
#MÉDIA QUE AS PROPRIEDADES PASSAM DISPONÍVEIS PARA VENDA DURANTE O PERÍODO DE 365 DIAS POR BAIRRO
SELECT
        neighbourhood_cleansed as neighbourhood,
        count(DISTINCT(id)) as count_properties,
        avg(availability_365) as avg_vacancy_days, #na media, quantos dias do ano as propriedades desse Bairro 
        #passam desocupadas e disponíveis para alugar?
        (100-(AVG (availability_365)/365)*100) as ocupation_rate
        from listings
    group by neighbourhood_cleansed
    order by ocupation_rate DESC

 #=====================================================================================================================================
 #Qual tipo de propriedade possui mais listagens
    SELECT
        count(distinct(id)) as listings,
        room_type
    from listings
    group by room_type
    order by listings DESC
#========================================================================================================================================
#Preço médio por bairro, seria interessante também saber quantas propriedades tem cada umn deses bairros
    SELECT 
        l.neighbourhood_cleansed,
        AVG(c.price) as average_price,
        COUNT(DISTINCT(l.id))
    FROM listings as l
        JOIN calendar as c ON l.id=c.listing_id
    GROUP BY neighbourhood_cleansed
    ORDER BY average_price DESC
#=========================================================================================================================================
#vamos assumir como receita o somatório dos preços em cada bairro, pois a taxa de ocupação não é confiável considerando que pegou
#calendário de um ano para frente e alguns anuncios podem está apenas desativados e não ocupados.

    SELECT
        count(distinct(l.id)) as number_of_properties,
        l.neighbourhood_cleansed as neighbourhood,
        avg(c.price) as avg_price,
        SUM(c.price) as revenue
    FROM listings as l
        JOIN calendar as c ON l.id=c.listing_id
    WHERE l.id is not NULL
        and l.neighbourhood_cleansed is not NULL
        and c.price is not null
    group by neighbourhood_cleansed
    order by revenue DESC
# SUM dos preços da região e dividir pela quantidade de propriedades no Bairro para saber, quanto, em média, cada propriedade gera de receita média.

#============================================================================================================================================
# Quais tipos de propriedades possui as maiores receitas ou qual tipos de propriedades possui os maiores preços.
#Agora que já sabemos quais os preços médios e as receitas, seria interessante a gente investigar qual o tipo de propriedade possui 
#as maiores receitas ou qual tipo de propriedade possui os maiores preços.
# O número de quartos que está correlacionado a maior quantidade de preços e receitas também.
    SELECT
                count(distinct(l.id)) as number_of_properties,
                l.neighbourhood_cleansed as neighbourhood,
                avg(c.price) as avg_price,
                SUM(c.price) as revenue,
                SUM(c.price)/ count(distinct(l.id)) as avg_revenue_per_properties

            FROM listings as l
                JOIN calendar as c ON l.id=c.listing_id
            WHERE l.id is not NULL
                and l.neighbourhood_cleansed is not NULL
                and c.price is not null
            group by neighbourhood_cleansed
            order by revenue DESC

#===================================================================================================================================================
#Room_type e Bedrooms com mais receitas
    SELECT
        room_type,
        count(distinct(listings)) as number_of_properties,
        SUM(revenue) as revenue,
        AVG(avg_price) as avg_price
    FROM

                (
                SELECT
                    l.id as listings,
                    l.neighbourhood_cleansed as neighbourhood,
                    l.room_type as room_type,
                    c.price,
                    SUM(c.price) as revenue,
                    avg(c.price) as avg_price,
                    SUM(c.price)/ COUNT (DISTINCT(l.id)) as avg_revenue_per_properties
                FROM listings as l
                JOIN calendar as c           ON l.id=c.listing_id
                WHERE l.room_type IS NOT NULL
                    and c.price is not NULL
                    and neighbourhood_cleansed is not null
                GROUP BY 
                    l.id,
                l.neighbourhood_cleansed,
                    l.room_type,
                    c.price
            Order by revenue DESC 
                                    ) as subselect1
    Group by room_type
    order by revenue DESC
#===========================================================================================================================================================
#Bedrooms
SELECT
        bedrooms,
        count(distinct(listings)) as number_of_properties,
        SUM(revenue) as revenue,
        AVG(avg_price) as avg_price
    FROM

                (
                SELECT
                    l.id as listings,
                    l.neighbourhood_cleansed as neighbourhood,
                    l.bedrooms as bedrooms,
                    c.price,
                    SUM(c.price) as revenue,
                    avg(c.price) as avg_price,
                    SUM(c.price)/ COUNT (DISTINCT(l.id)) as avg_revenue_per_properties
                FROM listings as l
                JOIN calendar as c           ON l.id=c.listing_id
                WHERE l.bedrooms IS NOT NULL
                    and c.price is not NULL
                    and neighbourhood_cleansed is not null
                GROUP BY 
                    l.id,
                l.neighbourhood_cleansed,
                    l.bedrooms,
                    c.price
            Order by revenue DESC 
                                    ) as subselect1
    Group by bedrooms
    order by revenue DESC
#================================================================================================================================================================
#Esse seria os tipos de propriedade com maiores receitas e quantos quartos eles possuem
SELECT
    count(distinct(listings)) as number_of_properties,
    bedrooms,
    room_type,
    SUM(revenue) as revenue,
        avg(price) AS avg_price
    FROM
        ( SELECT
                l.id as listings,
                l.neighbourhood_cleansed as neighbourhood,
                l.room_type as room_type,
                l.bedrooms as bedrooms,
                c.price as price,
                avg(c.price) as avg_price,
            SUM(c.price) as revenue
            FROM listings as l 
                JOIN calendar as c ON l.id=c.listing_id
            WHERE l.bedrooms IS NOT NULL
            and l.room_type is not NULL AND
            c.price is not null
            GROUP BY 
                l.id,
                l.neighbourhood_cleansed,
                l.room_type,
                l.bedrooms,
                c.price
                                ) as subselect
    Group by
        bedrooms,
        room_type
    ORDER BY revenue DESC

#======================================================================================================================================================================
# que podemos aprender com os hots que tem mais receita?
#quais são os hots com maiores receitas, imóveis eles possuem?

    #Host com mais receitas
    SELECT
        l.host_id,
        l.host_name,
        count(distinct(l.id)) as n_prop,
        SUM(C.price) as revenue,
        avg(c.price) as avg_price #preço medio de todas suas propriedades

    FROM listings as l
        JOIN calendar as c                     ON l.id=c.listing_id
    GROUP BY host_name, host_id
    order by revenue DESC

#Onde o host está concentrando suas propriedades? 
# listagens por bairro e qual o preço desses imoveis

##host_name="fiona" É só ir mudando o nome dos hots para todos os top 10
    SELECT
        count(distinct (l.id)) as number_of_properties,
        l.host_id ,
        l.host_name,
        l.neighbourhood_cleansed as neighbourhood,
        avg(c.price) as avg_price,
        SUM(c.price) as revenue
    from listings as l
    JOIN calendar as c ON l.id=c.listing_id
    where
        host_name = "Fiona" 
        and c.price is not null 
    group by 
        l.host_id,
        l.host_name,
        l.neighbourhood_cleansed
    order by number_of_properties DESC

#Onde fiona mais tem listagens por bairro e qual o preço desses imoveis
#É só ir mudando o nome dos hots para todos os top 10
    SELECT
        count(distinct (l.id)) as number_of_properties,
        l.host_id ,
        l.host_name,
        l.room_type as room_type,
        avg(c.price) as avg_price,
        SUM(c.price) as revenue
    from listings as l
    JOIN calendar as c ON l.id=c.listing_id
    where
        host_name = "Fiona" 
        and c.price is not null AND
        l.room_type is not null
    group by 
        l.host_id,
        l.host_name,
        l.room_type
    order by revenue DESC

#=========================================================================================================================================================================
#Juntando os dois, fica mais fácil de visualizar, então desse código é mais fácil visualizar os outros top 5 hots.

    SELECT
        count(distinct (l.id)) as number_of_properties,
        l.host_id ,
        l.host_name,
        l.bedrooms as bedrooms,
        l.room_type,
        avg(c.price) as avg_price,
        SUM(c.price) as revenue
    from listings as l
    JOIN calendar as c ON l.id=c.listing_id
    where
        host_name = "Fiona" 
        and c.price is not null AND
        l.bedrooms is not null AND
        l.room_type is not null
    group by 
        l.host_id,
        l.host_name,
        l.bedrooms,
        l.room_type
    order by revenue DESC

#=============================================================================================================================================================================
#Onde os hots com mais receitas investem?
#Host com mais receitas
    SELECT
        l.host_id,
        l.host_name,
        l.neighbourhood_group_cleansed as group_neighbourhood,
        count(distinct(l.id)) as number_of_propirties,
        SUM(C.price) as revenue,
        avg(c.price) as avg_price #preço medio de todas suas propriedades

    FROM listings as l
        JOIN calendar as c                     ON l.id=c.listing_id
    GROUP BY host_name, host_id, group_neighbourhood
    order by revenue DESC
#=============================================================================================================================================================================
#Certo, as propriedades que possuem mais receita, onde estão e quais são as regiões mais caras?
#Propriedades com mais revenue
    SELECT
        l.id,
        l.host_id,
        l.host_name,
        SUM(c.price) as revenue,
        AVG(c.price) as avg_price,
        l.neighbourhood_group_cleansed as group_neighbourhood,
        l.room_type
    FROM listings as l
    JOIN calendar as c   ON l.id=c.listing_id
    GROUP BY l.id, 
    l.host_id,
    l.host_name,
    l.neighbourhood_group_cleansed,
    l.room_type
    order by revenue DESC
#=============================================================================================================================================================================
#Propriedades com mais revenue
SELECT
    count(distinct(id)) as number_of_properties,
    SUM(c.price) as revenue,
    AVG(c.price) as avg_price,
    l.neighbourhood_group_cleansed as group_neighbourhood
FROM listings as l
 JOIN calendar as c   ON l.id=c.listing_id
GROUP BY
l.neighbourhood_group_cleansed
order by revenue DESC
#=============================================================================================================================================================================

#SAZONALIDADE

    SELECT
    listing_id,
    year,
    month,
    CASE
            WHEN day_of_week=1 THEN "Sunday"
            WHEN day_of_week=2 THEN "Monday"
            WHEN day_of_week=3 THEN "Tuesday"
            WHEN day_of_week=4 THEN "Wednesday"
            WHEN day_of_week=5 THEN "Thursday"
            WHEN day_of_week=6 THEN "Friday"
            WHEN day_of_week=7 THEN "Saturday"
            ELSE "0"
            END as weekday,
        price
    FROM
            (
            SELECT 
                listing_id,
                year(date),
                MONTH(date),
                DATE_PART("dayofweek", date) as day_of_week,
                price
            FROM 
            calendar
            ) as subselect
#===================================================================================================================================================================================
    #meses do ano onde o preço médio é maior
        SELECT
            AVG(price) as avg_price,
            month_of_year
    FROM
            (
            SELECT
                listing_id,
                year,
                CASE
                    WHEN month =1 THEN "January"
                    WHEN month =2 THEN "February"
                    WHEN month =3 THEN "March"
                    WHEN month =4 THEN "April"
                    WHEN month =5 THEN "May"
                    WHEN month =6 THEN "June"
                    WHEN month =7 THEN "July"
                    WHEN month =8 THEN "August"
                    WHEN month =9 THEN "September"
                    WHEN month =10 THEN "October"
                    WHEN month =11 THEN "November"
                    WHEN month =12 THEN "December"
                    ELSE "0"
                    END as month_of_year,
                CASE
                    WHEN day_of_week=1 THEN "Sunday"
                    WHEN day_of_week=2 THEN "Monday"
                    WHEN day_of_week=3 THEN "Tuesday"
                    WHEN day_of_week=4 THEN "Wednesday"
                    WHEN day_of_week=5 THEN "Thursday"
                    WHEN day_of_week=6 THEN "Friday"
                    WHEN day_of_week=7 THEN "Saturday"
                    ELSE "0"
                    END as weekday,
                price
            FROM
                    (
                    SELECT 
                        listing_id,
                        year(date),
                        MONTH(date) as month,
                        DATE_PART("dayofweek", date) as day_of_week,
                        price
                    FROM 
                    calendar
                    ) as subselect
            ) as subselect2
    group by month_of_year
    order by avg_price DESC

#========================================================================================================================================================================================
#dias da semana onde o preço é maior
        SELECT
            AVG(price) as avg_price,
            weekday
    FROM
            (
            SELECT
                listing_id,
                year,
                month,
                CASE
                    WHEN day_of_week=1 THEN "Sunday"
                    WHEN day_of_week=2 THEN "Monday"
                    WHEN day_of_week=3 THEN "Tuesday"
                    WHEN day_of_week=4 THEN "Wednesday"
                    WHEN day_of_week=5 THEN "Thursday"
                    WHEN day_of_week=6 THEN "Friday"
                    WHEN day_of_week=7 THEN "Saturday"
                    ELSE "0"
                    END as weekday,
                price
            FROM
                    (
                    SELECT 
                        listing_id,
                        year(date),
                        MONTH(date),
                        DATE_PART("dayofweek", date) as day_of_week,
                        price
                    FROM 
                    calendar
                    ) as subselect
            ) as subselect2
    group by weekday
    order by avg_price DESC
#================================================================================================================================================================================================
#Booking ao longo do ano para saber se a demanda é maior em algum mês do ano
    SELECT
        SUM(number_of_reviews) total_review,
        CASE
                    WHEN month =1 THEN "January"
                    WHEN month =2 THEN "February"
                    WHEN month =3 THEN "March"
                    WHEN month =4 THEN "April"
                    WHEN month =5 THEN "May"
                    WHEN month =6 THEN "June"
                    WHEN month =7 THEN "July"
                    WHEN month =8 THEN "August"
                    WHEN month =9 THEN "September"
                    WHEN month =10 THEN "October"
                    WHEN month =11 THEN "November"
                    WHEN month =12 THEN "December"
                    ELSE "0"
                    END as month_of_year
    FROM

    (
            SELECT 
                l.id,
                l.availability_365,
                l.number_of_reviews,
                c.date,
                YEAR(c.date),
                month(c.date)
            from listings as l
            JOIN calendar as c on l.id=c.listing_id
            ) as subselect1
    GROUP BY month_of_year

#======================================================================================================================================================================================================
#contando o número de reviws que is imoveis listados em singapore recebeu ao longo do ano de 2022
    SELECT
        SUM(number_of_reviews) as number_of_review,
        CASE
        WHEN month =1 THEN "January"
                    WHEN month =2 THEN "February"
                    WHEN month =3 THEN "March"
                    WHEN month =4 THEN "April"
                    WHEN month =5 THEN "May"
                    WHEN month =6 THEN "June"
                    WHEN month =7 THEN "July"
                    WHEN month =8 THEN "August"
                    WHEN month =9 THEN "September"
                    WHEN month =10 THEN "October"
                    WHEN month =11 THEN "November"
                    WHEN month =12 THEN "December"
                    ELSE "0"
                    END as month_of_year
    FROM
                (SELECT 
                    count(distinct(id)) as number_of_reviews,
                    MONTH(date)
                from reviews
                WHERE year(date) BETWEEN 2021 and 2022
                group by month
                order by number_of_reviews DESC
                ) as subselect1
    GROUP BY month_of_year
    order by number_of_reviews DESC
#===========================================================================================================================================================================================================
SELECT 
        SUM(
            CASE
                    WHEN  available = TRUE THEN 0
                    WHEN available = FALSE THEN 1
                    ELSE 10000
        END ) as booking,
        CASE 
            WHEN month =1 THEN "January"
            WHEN month =2 THEN "February"
            WHEN month =3 THEN "March"
            WHEN month =4 THEN "April"
            WHEN month =5 THEN "May"
            WHEN month =6 THEN "June"
            WHEN month =7 THEN "July"
            WHEN month =8 THEN "August"
            WHEN month =9 THEN "September"
            WHEN month =10 THEN "October"
            WHEN month =11 THEN "November"
            WHEN month =12 THEN "December"
            ELSE "0"
        END as month_of_year
        FROM
        (
                    SELECT 
            available,
            date,
            YEAR(date),
            MONTH(date)
        from calendar 
            ) as subselect
    group by month_of_year
    order by booking DESC

#================================================================================================================================================================================================================
