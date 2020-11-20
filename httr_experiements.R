## Investigating the option of using httr to generate the endpoint queries manually
# Assuming this is what the SPARQL package does under the hood, but this greater control should allow me to solve the auth issues

library(httr)

library(XML)
library(SPARQL)


endpoint <- "https://statistics.gov.scot/sparql"

query <- "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT ?areaname ?periodname ?value
WHERE {
  ?obs <http://purl.org/linked-data/cube#dataSet> <http://statistics.gov.scot/data/child-dental-health> .
  ?obs <http://purl.org/linked-data/sdmx/2009/dimension#refArea> ?areauri .
  ?obs <http://purl.org/linked-data/sdmx/2009/dimension#refPeriod> ?perioduri .
  ?obs <http://statistics.gov.scot/def/measure-properties/ratio> ?value .
  ?areauri rdfs:label ?areaname .
  ?perioduri rdfs:label ?periodname .
}"

scotqueryres <- SPARQL(endpoint,query)

scotdf <- scotqueryres$results

head(scotdf)

httr::GET()

test_response <- GET(
        "https://statistics.gov.scot"
        , headers = "Accept: application/sparql-results+json"
        , path = "sparql"
        , body = list(query = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        SELECT ?areaname ?periodname ?value
        WHERE {
                ?obs <http://purl.org/linked-data/cube#dataSet> <http://statistics.gov.scot/data/child-dental-health> .
                ?obs <http://purl.org/linked-data/sdmx/2009/dimension#refArea> ?areauri .
                ?obs <http://purl.org/linked-data/sdmx/2009/dimension#refPeriod> ?perioduri .
                ?obs <http://statistics.gov.scot/def/measure-properties/ratio> ?value .
                ?areauri rdfs:label ?areaname .
                ?perioduri rdfs:label ?periodname .
        }"))



rawToChar(test_response$content)



library(httr)
library(jsonlite)
options(stringsAsFactors = FALSE)

# url for local testing
url <- "http://127.0.0.1:8000"

# url for docker container
#url <- "http://0.0.0.0:8000"

# read example stock data
.data <- datasets::mtcars

# create example body
body <- list(
  msg = "Testing Testing 123"
  , spec = "versicolor"
  , indat = toJSON(head(.data))
  #,
   #.data = .data
  #, .cols = c("Car name", "MPG per Cylinder")
)
body2 <- toJSON(body)
# set API path
path <- 'testserv'

# send POST Request to API
raw.result <- GET(url = url, path = path,  encode = 'json')

# check status code
raw.result$status_code
# retrieve transformed example stock data
.t_data <- fromJSON(rawToChar(raw.result$content))
print(.t_data)
apiGetterWrapper(head(.data, 30), "http://127.0.0.1:8000/testpipe")


#Generate a wrapper which simply takes string form R code and evaluates it against supplied json data. as a cheap remote compute alternative.
