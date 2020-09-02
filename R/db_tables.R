# ------------------------
# Phenomet database table functions
# ------------------------


#' Get site information
#'
#' @return data.frame of site information
#' @export
#'
#' @examples
#' get_site_list()
get_site_list <- function(){
  con <- db_connect()

  df <- tbl(src=con, 'site_info') %>%
    collect()

  DBI::dbDisconnect(con)

  return(df)
}

#' Get site visit information
#'
#' @param site_codes Optional. A single site code or list of site codes. Default returns all sites.
#' @param start_date Optional. A string with format 'YYYY-MM-DD'. Get visit information from this date forward. Default is all prior dates.
#' @param end_date   Optional. A string with format 'YYYY-MM-DD'. Get visit information up to this date. Default is all dates up to todays date.
#'
#' @return data.frame of site visit information.
#' @export
#'
#' @examples
get_site_visits <- function(site_codes=NULL, start_date=NULL, end_date=NULL){

  if(is.null(start_date)) start_date <- '2000-01-01'
  if(is.null(end_date)) end_date <- Sys.Date()


  con <- db_connect()

  df <- tbl(src =con, 'site_visit') %>%
    filter(DATE >= start_date, DATE <= end_date)

  if(!is.null(site_codes)){
    site_codes <- c(site_codes)
    df <- dplyr::filter(df, SITE_CODE %in% site_codes)
  }

  df <- dplyr::collect(df)

  DBI::dbDisconnect(con)

  return(df)
}

get_plant_phenophase = function(plant_id, start_date = NULL, end_date = NULL){
  # all phenophases for 1 plant

  if(is.null(start_date)) start_date <- '2000-01-01'
  if(is.null(end_date)) end_date <- Sys.Date()


  con <- db_connect()


  DBI::dbDisconnect(con)
}

get_site_phenophase = function(site_code, start_date = NULL, end_date = NULL){
  # all phenophases for all plants at 1 site

  if(is.null(start_date)) start_date <- '2000-01-01'
  if(is.null(end_date)) end_date <- Sys.Date()
}
