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

  df <- dplyr::tbl(src=con, 'site_info')
  df <- dplyr::collect(df)

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

  df <- dplyr::tbl(src =con, 'site_visit')
  df <- dplyr::filter(df, DATE >= start_date, DATE <= end_date)

  if(!is.null(site_codes)){
    site_codes <- c(site_codes)
    df <- dplyr::filter(df, SITE_CODE %in% site_codes)
  }

  df <- dplyr::collect(df)

  DBI::dbDisconnect(con)

  return(df)
}

#' Get all individual plant info
#'
#' @return data.frame of plant_id, site_code, species, functional group, etc.
#' @export
#'
get_plant_info = function(){

  con <- db_connect()

  plant_info <- dplyr::tbl(con, 'focal_plant_info')
  plant_info <- dplyr::collect(plant_info)

  DBI::dbDisconnect(con)

  return(plant_info)
}

#' Get phenophase information for a single plant
#'
#' By default will return a data.frame with phenophase codes as columns (shape = 'wide')
#' With shape='long" columns names will be c('PLANT_ID','DATE','PHENOPHASE','STATUS','NOTE_FLAG','PHOTO_FLAG')
#'
#' @param plant_id string. unique plant identifier
#' @param start_date Optional. A string with format 'YYYY-MM-DD'. Get visit information from this date forward. Default is all prior dates.
#' @param end_date   Optional. A string with format 'YYYY-MM-DD'. Get visit information up to this date. Default is all dates up to todays date.
#' @param shape string. 'wide' or 'long' for a data.frame in the respective format. default 'wide'
#'
#' @return data.frame of phenophases by date
#' @export
#'
#' @examples
#' get_plant_phenophase('CRATCA01')
#' get_plant_phenophase('CRATCA01', start_date = '2012-01-01', end_date = '2012-12-31')
get_plant_phenophase = function(plant_id, start_date = NULL, end_date = NULL, shape = 'wide'){


  if(is.null(start_date)) start_date <- '2000-01-01'
  if(is.null(end_date))   end_date   <- Sys.Date()

  con <- db_connect()

  plant_info <- dplyr::tbl(con, 'focal_plant_info')
  plant_info <- dplyr::filter(plant_info, PLANT_ID == plant_id)
  plant_info <- dplyr::collect(plant_info)

  if(nrow(plant_info) == 0) stop('plant_id not found: ',plant_id)

  # Individual plant info is divided into tables by function group.
  fg <- plant_info$FUNC_GRP_CODE

  plant_table <- dplyr::case_when(
    fg == 'PG' ~ 'pg_pheno', # perennial grass
    fg == 'DS' ~ 'ds_pheno', # deciduous shrub
    fg == 'ES' ~ 'es_pheno', # evergreen shrub
    fg == 'SU' ~ 'su_pheno'  # succulent
  )

  # each function group table has it's own columns
  # representing bbch codes.
  table_column_starts_with <- dplyr::case_when(
    fg == 'PG' ~ 'GR_', # perennial grass
    fg == 'DS' ~ 'DS_', # deciduous shrub
    fg == 'ES' ~ 'BE_', # evergreen shrub
    fg == 'SU' ~ 'CA_'  # succulent
  )

  plant_phenology <- dplyr::tbl(con, plant_table)
  plant_phenology <- dplyr::filter(plant_phenology,
                                   PLANT_ID == plant_id,
                                   DATE >= start_date, DATE <= end_date)
  plant_phenology <- dplyr::collect(plant_phenology)

  DBI::dbDisconnect(con)

  if(shape == 'long'){
    plant_phenology =  tidyr::pivot_longer(plant_phenology,
                                           cols = tidyr::starts_with(table_column_starts_with),
                                           names_to = 'PHENOPHASE',
                                           values_to = 'STATUS')
  }

  return(plant_phenology)
}

get_site_phenophase = function(site_code, start_date = NULL, end_date = NULL){
  # all phenophases for all plants at 1 site

  if(is.null(start_date)) start_date <- '2000-01-01'
  if(is.null(end_date)) end_date <- Sys.Date()
}
