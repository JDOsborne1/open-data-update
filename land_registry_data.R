library(SPARQL)
library(tidyverse)

# Define the data.gov endpoint
endpoint <- "http://landregistry.data.gov.uk/landregistry/query"

query <-
  "
  prefix lrppi: <http://landregistry.data.gov.uk/def/ppi/>
  prefix lrcommon: <http://landregistry.data.gov.uk/def/common/>
  prefix skos: <http://www.w3.org/2004/02/skos/core#>
  prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
  SELECT ?trans_id_str ?price_paid ?date ?postcode ?property_type ?new_build ?estate_type ?saon ?paon ?street ?locality ?town ?district ?county ?transaction_category ?Record_status
    WHERE {
     ?transx lrppi:transactionId ?trans_id .
     ?transx lrppi:pricePaid ?price_paid .
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
     OPTIONAL {?addr lrcommon:locality ?locality}
     OPTIONAL {?addr lrcommon:district ?district}
     OPTIONAL {?addr lrcommon:town ?town}
     bind( str(?trans_id) as ?trans_idr )
    }
  LIMIT 10"

# Step 2 - Use SPARQL package to submit query and save results to a data frame
qd <- SPARQL(endpoint, query)
price_paid <- qd$results

clean_field <- function(field) str_match(field, '^"?([\\w-]+)"?')[, 2]

price_paid <- price_paid %>%
  mutate_at(vars(property_type, estate_type, transaction_category, Record_status), clean_field) %>%
  mutate(date = as.POSIXct(date, origin = "1970-01-01"))
