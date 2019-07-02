library(SPARQL)
library(ggplot2)

# Define the data.gov endpoint
endpoint <- "http://landregistry.data.gov.uk/landregistry/query"

query <-
  "PREFIX lrppi: <http://landregistry.data.gov.uk/def/ppi/>
  SELECT ?postcode ?amount ?date
    WHERE {
     ?transx a <http://landregistry.data.gov.uk/def/ppi/TransactionRecord> .
     ?transx <http://landregistry.data.gov.uk/def/ppi/pricePaid> ?amount .
     ?transx <http://landregistry.data.gov.uk/def/ppi/transactionDate> ?date .
     ?transx <http://landregistry.data.gov.uk/def/ppi/propertyAddress> ?addr.
     ?transx <http://landregistry.data.gov.uk/def/ppi/recordStatus> ?status.
     ?addr <http://landregistry.data.gov.uk/def/common/postcode> ?postcode .
    }
  LIMIT 10"

# Step 2 - Use SPARQL package to submit query and save results to a data frame
qd <- SPARQL(endpoint, query)
df <- qd$results

as.POSIXct(1417737600, origin = "1970-01-01")
