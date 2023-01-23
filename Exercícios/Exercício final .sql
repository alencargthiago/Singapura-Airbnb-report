#===========================================================================================================
#1) Na query que criamos para as tabelas employees nós coletamos vários dados sobre os empregados. 
#Agora, crie uma query (usando a anterior) trazendo o name, last_name, salary e bonus de cada funcionário, 
#mas apenas para funcionários do Texas, California e Florida. 
#Além disso, mude o nome name para name, last_name para surname, salary para salary e bonus para bonus_pay
    SELECT
        x.first_name as name,
        x.last_name as surname,
        z.state,
        y.salary as salary,
        y.bonus as bonus_pay
        
    FROM 
        employee_names as x
    JOIN 
        employee_status as y            on x.employee_id = y.employee_id
    JOIN
        employee_state_manager as z     on x.employee_id = z.employee_id
    WHERE 
        z.state in ("Texas","California","Florida")
#===============================================================================================================
Exercício 2: Agora me dê todos os funcionários deste estados que tiveram um bônus maior ou igual a $4,000. 
#Lembre-se que o bônus em $ é calculado pelo valor do salário multiplicado pelo bônus. 
#Chame esta coluna com o valor em $ do bônus como bonus_total.
    SELECT 
        name,
        bonus_total
    FROM
        (
            SELECT
            x.first_name as name,
            x.last_name as surname,
            z.state,
            y.salary as salary,
            y.bonus as bonus_pay,
            sum(y.salary) * sum (y.bonus) as bonus_total
            
        FROM  employee_names as x
            JOIN employee_status as y            on x.employee_id = y.employee_id
            JOIN employee_state_manager as z     on x.employee_id = z.employee_id
        WHERE z.state in ("Texas","California","Florida")
        GROUP BY  
            name,
            surname,
            z.state,
            salary,
            bonus_pay
        HAVING 
            bonus_total >=4000
        ORDER BY name 
            ) as t1
    WHERE bonus_total >=4000
#=========================================================================================================
#LOGICA POR TRÁS DA resposta
#Primeiro passo, vamos ir atrás de compreender o primeiro select da Query do código resposta.
#Precisamos selecionar os campos nessas diferentes planilhas, para isso devemos utilziar o JOIN
    SELECT
        X.employee_id,
        X.client,
        X.revenue,
        X.sales,
        Y.first_name,
        Y.last_name,
        U.salary,
        U.status,
        U.bonus,
        Z.state
    FROM employee_clients as X             
        JOIN employee_names AS Y                ON X.employee_id = Y.employee_id
        JOIN employee_state_manager AS Z        ON X.employee_id= Z.employee_id
        JOIN employee_status AS U               ON X.employee_id = U.employee_id

#Em seguida iremos renomear alguns campos para facilitar quando utilizarmos como uma subquery.
    SELECT
        X.employee_id,
        X.client,
        X.revenue,
        X.sales,
        Y.first_name AS name ,
        Y.last_name AS surname,
        U.salary AS salary,
        U.status,
        U.bonus AS bonus_pay,
        Z.state
    FROM employee_clients AS X             
        JOIN employee_names AS Y                ON X.employee_id = Y.employee_id
        JOIN employee_state_manager AS Z        ON X.employee_id= Z.employee_id
        JOIN employee_status AS U               ON X.employee_id = U.employee_id

#Dessa forma, iremos criar uma nova seleção para filtrar dessa subquery  somente  os campos: name, surname, salary and bonus_pay. 
#Para isso devemos colocar a query anterior em parenteses e indicar que a nova consulta será feita a partir dessa subseleção. Então temos:
    SELECT
        name,
        surname,
        salary,
        bonus_pay
    FROM
        (SELECT
            X.employee_id,
            X.client,
            X.revenue,
            X.sales,
            Y.first_name AS name ,
            Y.last_name AS surname,
            U.salary AS salary,
            U.status,
            U.bonus AS bonus_pay,
            Z.state
        FROM employee_clients AS X             
            JOIN employee_names AS Y                ON X.employee_id = Y.employee_id
            JOIN employee_state_manager AS Z        ON X.employee_id= Z.employee_id
            JOIN employee_status AS U               ON X.employee_id = U.employee_id) t1
#Em seguida, iremos filtrar essa nova seleção apenas os dados   dos estados da california, texas e florida; para este fim,  usa-se a função IN
	SELECT
        name,
        surname,
        salary,
        bonus_pay
   FROM
        (SELECT
            X.employee_id,
            X.client,
            X.revenue,
            X.sales,
            Y.first_name AS name ,
            Y.last_name AS surname,
            U.salary AS salary,
            U.status,
            U.bonus AS bonus_pay,
            Z.state
            FROM employee_clients AS X             
            JOIN employee_names AS Y                ON X.employee_id = Y.employee_id
            JOIN employee_state_manager AS Z        ON X.employee_id= Z.employee_id
            JOIN employee_status AS U               ON X.employee_id = U.employee_id) t1
    WHERE state in ( "California", "Texas", "Florida")

#Finalmente, iremos criar uma nova seleção somente com o campo de name e uma nova agregação nomeada de bônus total. 
#Desta forma, precisamos transformar a seleção anterior novamente em uma subseleção, colocando () e indicando que a 
#nova seleção utilizará esta query anterior  como base, através do **FROM**.
#Por fim, iremos filtrar apenas aqueles funcionários no qual possuem um bônus salarial ≥4000.
    SELECT
        name,
        (salary*bonus_pay) as bonus_total
    FROM
        (SELECT
            name,
            surname,
            salary,
            bonus_pay
        FROM
            (SELECT
                X.employee_id,
                X.client,
                X.revenue,
                X.sales,
                Y.first_name AS name ,
                Y.last_name AS surname,
                U.salary AS salary,
                U.status,
                U.bonus AS bonus_pay,
                Z.state
                FROM employee_clients AS X             
                JOIN employee_names AS Y                ON X.employee_id = Y.employee_id
                JOIN employee_state_manager AS Z        ON X.employee_id= Z.employee_id
                JOIN employee_status AS U               ON X.employee_id = U.employee_id) t1
        WHERE state in ( "California", "Texas", "Florida")) as temp1
    WHERE salary*bonus_pay >=4000