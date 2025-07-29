library(httr2)

#' Fetch All Countries
#'
#' Retrieve all countries for which DTM data is publicly available through the API.
#'
#' @return A data frame containing the list of all countries.
#' @export
#' @examples
#' countries_df <- get_all_countries()
#' head(countries_df)
#' @importFrom httr2 request req_perform resp_status resp_body_json

get_all_countries <- function() {

  tryCatch({
    api_url <- "https://dtmapi.iom.int/api/Common/GetAllCountryList"

    response <- request(api_url) |> req_perform()

    # Check if the request was successful
    if (resp_status(response) != 200) {
      stop("Failed to fetch data. Status code: ", resp_status(response))
    }

    json_data <- resp_body_json(response, simplifyVector = TRUE)
    df <- as.data.frame(json_data$result) # as.data.frame() for consistency's sake.

    return(df)

  }, error = function(e) {
    # Handle and report errors
    stop("API request failed: ", e$message)
  })
}
