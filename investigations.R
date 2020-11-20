library(RCurl)
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

endpoint2 <- "http://landregistry.data.gov.uk/landregistry/query"

query2 <- 'prefix lrppi: <http://landregistry.data.gov.uk/def/ppi/>
prefix lrcommon: <http://landregistry.data.gov.uk/def/common/>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?region ?date ?hpi ?regionname
{
        ?region ukhpi:refPeriodStart ?date ;
                ukhpi:housePriceIndex ?hpi ;
                ukhpi:refRegion ?regionname
FILTER (
        ?date > "2019-04-01"^^xsd:date
)
}

LIMIT 10
'

lrqueryres <- SPARQL(endpoint2,query2)

lrquerydf <- lrqueryres$results

head(lrquerydf)
