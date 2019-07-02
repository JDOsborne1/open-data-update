library(SPARQL)

# Define the data.gov endpoint
endpoint <- "http://landregistry.data.gov.uk/landregistry/query"

query <-
  "
  prefix lrppi: <http://landregistry.data.gov.uk/def/ppi/>
  prefix lrcommon: <http://landregistry.data.gov.uk/def/common/>
  prefix skos: <http://www.w3.org/2004/02/skos/core#>
  prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
  SELECT *
    WHERE {
     ?transx lrppi:transactionId ?trans_id .
     ?transx lrppi:pricePaid ?amount .
     ?transx lrppi:transactionDate ?date .
     ?transx lrppi:propertyAddress ?addr .
     ?transx lrppi:recordStatus/skos:prefLabel ?Record_status .
     ?transx lrppi:transactionCategory/rdfs:label ?transaction_category .
     ?transx lrppi:estateType/skos:prefLabel ?estate_type .
     ?transx lrppi:propertyType/skos:prefLabel ?property_type .
     ?transx lrppi:newBuild ?new_build .
     ?addr lrcommon:postcode ?postcode .
     OPTIONAL {?addr lrcommon:county ?county}
     OPTIONAL {?addr lrcommon:paon ?paon}
     OPTIONAL {?addr lrcommon:saon ?saon}
     OPTIONAL {?addr lrcommon:street ?street}
     OPTIONAL {?addr lrcommon:town ?town}
    }
  LIMIT 10"

# Step 2 - Use SPARQL package to submit query and save results to a data frame
qd <- SPARQL(endpoint, query)$results
qd

df <- qd$results

as.POSIXct(1417737600, origin = "1970-01-01")
