# Functions to get the various sources



#' getSalesData
#'
#' @return
#' @export
#'
#' @examples
getSales <- function(Limited = TRUE){

        limiter_string <- if_else(Limited, "LIMIT 10", "")

        query <- paste0(
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
                        bind( str(?trans_id) as ?trans_idr_str )
                        }
                        "
        , limiter_string
        )

        price_paid <- landRegistryQuery(query)

        price_paid <- price_paid %>%
                mutate_at(vars(property_type, estate_type, transaction_category, Record_status), cleanFieldType) %>%
                mutate(date = as.POSIXct(date, origin = "1970-01-01"))

        return(price_paid)
}


#' House Price Index Getter
#'
#' @return
#' @export
#'
#' @examples
getHPI <- function(Limited = TRUE){

        limiter_string <- dplyr::if_else(Limited, "LIMIT 10", "")

        query <- paste0(
        '
        prefix lrppi: <http://landregistry.data.gov.uk/def/ppi/>
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
        '
        , limiter_string
        )


        hpi <- landRegistryQuery(query)

        hpi <- hpi %>%
                dplyr::mutate(date = as.POSIXct(date, origin = "1970-01-01")) %>%
                dplyr::mutate(regionname = cleanRegionName(regionname))

        return(hpi)
}

landRegistryQuery <- function(Query, Endpoint = "http://landregistry.data.gov.uk/landregistry/query"){
        returnedObj <- SPARQL::SPARQL(Endpoint, Query)
        output <- returnedObj$results
        return(output)
}


apiGetterWrapper <- function(.input_ds, .processor_endpoint){


        # create example body
        body <- list(
           indat = toJSON(head(.input_ds))
        )
        # send POST Request to API
        raw.result <- httr::POST(url = .processor_endpoint, query = body, encode = 'json')

        # check status code
        if (raw.result$status_code != 200){
                stop(paste0("Unsuccessful Status code", raw.result$status_code))
        }

        jsonlite::fromJSON(rawToChar(raw.result$content))
}
