#' Fetch IDP Admin1 Data
#'
#' Retrieve IDP data at Admin 1 level based on specified parameters.
#' At least one of the following parameters must be provided: Operation, CountryName, or Admin0Pcode.
#'
#' @param Operation Optional; Name of the DTM operation for which the data was collected.
#' @param CountryName Optional; Name of the country where the data was collected.
#' @param Admin0Pcode Optional; Country code (ISO 3166-1 alpha-3).
#' @param Admin1Name Optional; Name of level 1 administrative boundaries.
#' @param Admin1Pcode Optional; Place code of level 1 administrative boundaries.
#' @param FromReportingDate Optional; Start date for the reporting period (format: 'YYYY-MM-DD').
#' @param ToReportingDate Optional; End date for the reporting period (format: 'YYYY-MM-DD').
#' @param FromRoundNumber Optional; Starting round number for the data collection range.
#' @param ToRoundNumber Optional; Ending round number for the data collection range.
#' @return A data frame containing the IDP Admin1 data matching the specified criteria.
#' @export
#' @examples
#' \dontrun{
#' # Fetch IDP data at Admin Level 1
#' idp_admin1_df <- get_idp_admin1_data(CountryName = "Sudan", Admin1Name = "Blue Nile")
#' head(idp_admin1_df)
#' }
#' @importFrom httr2 request req_perform req_url_query resp_status resp_body_json req_headers_redacted

get_idp_admin1_data <- function(
    Operation = NULL,
    CountryName = NULL,
    Admin0Pcode = NULL,
    Admin1Name = NULL,
    Admin1Pcode = NULL,
    FromReportingDate = NULL,
    ToReportingDate = NULL,
    FromRoundNumber = 0,
    ToRoundNumber = 0
) {
  api_url <- "https://dtm-apim.iom.int/v3/IdpAdmin1Data"

  query_params <- list(
    Operation = Operation,
    CountryName = CountryName,
    Admin0Pcode = Admin0Pcode,
    Admin1Name = Admin1Name,
    Admin1Pcode = Admin1Pcode,
    FromReportingDate = FromReportingDate,
    ToReportingDate = ToReportingDate,
    FromRoundNumber = FromRoundNumber,
    ToRoundNumber = ToRoundNumber
  )

  tryCatch({
    response <- 
      request(api_url) |>
      req_headers_redacted("Cache-Control" = "no-cache",
                           "Ocp-Apim-Subscription-Key" = get_subscription_key()
                          ) |>
      req_url_query(!!!query_params) |>
      req_perform()

    if (resp_status(response) != 200) {
      stop("Failed to fetch data. Status code: ", resp_status(response))
    }

    # Retrieve content as parsed JSON: simplifyVector helps to later return a dataframe.
    json_data <- resp_body_json(response, simplifyVector = TRUE)

    if (json_data$isSuccess) {
      return(as.data.frame(json_data$result))
    } else {
      # Handle API-specific errors
      stop("API error: ", json_data$errorMessages[1])
    }

  }, error = function(e) {
    # Handle and report errors
    stop("API request failed: ", e$message)
  })
}
