#' Clean date fields
#'
#' @param field
#'
#' @return
#' @export
#'
#' @examples
cleanFieldType <- function(field){
        output <- stringr::str_match(field, '^"?([\\w-]+)"?')[, 2]
        return(output)
}

cleanRegionName <- function(field){
        output <- stringr::str_match(field, '.*region/(\\S+)>$')[, 2]
        return(output)
        }
        
