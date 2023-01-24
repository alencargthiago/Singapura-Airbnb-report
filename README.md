# Singapura Airbnb report
Análise de negócio apresentada ao [Datascy](https://www.datascy.com)
como requisito necessário para obtenção do certificado de análise de dados do curso Master of Data Science and Analytics.

O objetivo deste trabalho é responder a seguinte problemática:

Um investidor pessoal contratou seus serviços. Ele está planejando comprar 10 imóveis de férias para investimento no Airbnb. Com base no desempenho dos imóveis que você analisou, esse é um bom investimento? Quais as recomendações de investimentos?

## datasource

Os dados são provenientes do site [Airbnb inside]( http://insideairbnb.com) e a análise foi elaborada no seguinte conjunto de dados disponíveis:

- **lISTING.CSV.GZ** : Apresenta dados detalhados referentes à listagens em Singapura referente ao período de 22/09/2022 a 22/09/2023

- **Calendar.csv.gz** :  Apresenta dados detalhados do calendário das propriedades listadas em Singapura no período de 22/09/2022 a 22/09/2023.

- **REVIEWS.CSV.GZ** : Apresenta dados detalhados sobre avaliações dos usuários das propriedades listadas em Singapura de 04/05/2011 a 22/09/2023

## segmentação dos dados:
Devido ao grande volume de dados, diferentes tipos de propriedade e de acomodações, a análise foi feita segmentando os dados de acordo com sua distribuição, a fim de analisar as características mais comuns das propriedades listadas em Singapura. Sendo assim, os dados foram segmentados da seguinte forma: 
- **Property type** : Entire condo, entire rental unit, entire serviced apartament, private room in rental unit, private room in condo. 
- **Room type**: Propriedades Entire home/ apt, shared room, private room e hotel
- **Bedrooms**: de 1 a 4 quartos

O [dicionário](https://docs.google.com/spreadsheets/d/1iWCNJcSutYqpULSQHlNyGInUvHg2BoUGoNRIGa6Szc4/edit#gid=1322284596) contendo as descrições das variáveis também pode ser acessados através do site do Airbnb inside.
## Como executar o projeto:
-  baixar o conjunto de dados de Singapore no site do Airbnb inside.
-  hospedar o conjunto de dados em um DBMS de sua preferência.
-  copiar as consultas de sql.
-  Por fim, para visualização de dados, integrar seu banco de dados no [Tableau](https://www.tableau.com/pt-br/academic/students).
## Principais tópicos de aprendizagem
* **SQL**
  * Comandos de seleção
  * Operadores (Aritméticos, Lógicos, Comparação, "is")
  * Apelidos
  * Comandos de restrição
  * Comandos condicionais
  * Comandos de agrupamento e ordenação
  * Relacionamento de tabelas
  * Funções de Datas
  * Join ou inner join
  * SubQuery como tabela
  * SubQuery como coluna
  * SubQuery como filtro
* **Git & Git workflow**
  * git clone
  * git add
  * git commit
  * git branch
  * git push
  * git pull
* **GitHub**
  * Create a repository
  * Deploy to personal pages




