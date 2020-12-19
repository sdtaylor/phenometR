# ------------------------
# Phenomet database table functions
# ------------------------

#' @name get_site_list
#' 
#' @title Get site information
#' 
#' @description Retrieve information on all the sites.
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

#' @name get_plant_info
#' 
#' @title Get all individual plant info
#'
#' @description Retrieve information on all indvidual plants.
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

#' Parse date options
#' 
#' Used internally to parse the date arguments and return a start/end date to use in the db filter.
#' 
#' If years is set then create a start/end date for the db query. In this case start_date/end_date args will be ignored.
#' If all is NULL then set end_date to the current date and start_date at the earliest possible date. 
#'
#' @param years int or vector of ints for the years desired. years must be consecutive.
#' @param start_date str in the form 'YYYY-MM-DD'
#' @param end_date str in the form 'YYYY-MM-DD'
#'
#' @return list with start_date end_date options.
#'
parse_dates = function(years, start_date, end_date){
  if(!is.null(years)){
    if(any(!grepl('\\d{4}', years))) stop('years must be 4 digits, got these: ',paste(years, collapse = ','))
    
    start_year = min(years)
    end_year   = max(years)
    start_date = as.Date(paste0(start_year,'-01-01'))
    end_date   = as.Date(paste0(end_year,'-12-31'))
  } else {
    if(is.null(start_date)){
      start_date <- '2000-01-01'
    } else {
      if(!grepl('\\d{4}-\\d{2}-\\d{2}',start_date)) stop('start_date must be in the format YYYY-MM-DD, got: ',start_date)
    }
    
    if(is.null(end_date)){
      end_date <- Sys.Date()
    } else {
      if(!grepl('\\d{4}-\\d{2}-\\d{2}',end_date)) stop('end_date must be in the format YYYY-MM-DD, got: ',end_date)
    }
  }
  
  if(as.Date(end_date) <= as.Date(start_date)) stop('start_date must come before end_date')
  
  return(list(start_date = start_date, end_date = end_date))
}


#' @name get_plant_phenophase
#' 
#' @title Get phenophase information for a single plant
#'
#' @description This function retrieves all phenophase data for a single plant_id. Can be subset to specific years,
#'     or specific start and end dates. 
#'     
#'      If shape = 'long' (the default) then columns will be:   
#'      c('PLANT_ID','DATE','PHENOPHASE','STATUS','NOTE_FLAG','PHOTO_FLAG','SITE_CODE', 'SPP_CODE', 'FUNC_GRP_CODE')  
#'      
#'      If shape = 'wide' then all thephenophase codes will be columns.
#'     
#'
#' @param plant_id string. unique plant identifier
#' @param years Optional. integer or vector of integer for the years desired. years must be consecutive.
#' @param start_date Optional. A string with format 'YYYY-MM-DD'. Get visit information from this date forward. Default is all prior dates.
#' @param end_date   Optional. A string with format 'YYYY-MM-DD'. Get visit information up to this date. Default is all dates up to todays date.
#' @param shape string. 'wide' or 'long' for a data.frame in the respective format. default 'long'
#'
#' @return data.frame of phenophases by date
#' @export
#'
#' @examples
#' get_plant_phenophase('CRATCA01')
#' get_plant_phenophase('CRATCA01', start_date = '2012-01-01', end_date = '2012-12-31')
get_plant_phenophase = function(plant_id, years = NULL, start_date = NULL, end_date = NULL, shape = 'long'){
  date_info = parse_dates(years = years, start_date = start_date, end_date = end_date)
  start_date = date_info$start_date
  end_date   = date_info$end_date

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

  plant_phenology = add_individual_plant_info(plant_phenology)
  plant_phenology = add_year_doy_columns(plant_phenology)
  
  if(shape == 'long'){
    plant_phenology =  tidyr::pivot_longer(plant_phenology,
                                           cols = tidyr::starts_with(table_column_starts_with),
                                           names_to = 'PHENOPHASE',
                                           values_to = 'STATUS')
  }

  return(plant_phenology)
}

#' @name get_species_phenophase
#' 
#' @title Get phenophase information for a single species.
#'
#' @description This function retrieves all phenophase data for a single species. All individual at all sites for the
#'      species will be return. Can be subset to specific years, or specific start and end dates. 
#'      
#'      See the output from get_plant_info() for valid species codes. 
#'     
#'      If shape = 'long' (the default) then columns will be:   
#'      c('PLANT_ID','DATE','PHENOPHASE','STATUS','NOTE_FLAG','PHOTO_FLAG','SITE_CODE', 'SPP_CODE', 'FUNC_GRP_CODE')  
#'      
#'      If shape = 'wide' then all thephenophase codes will be columns.
#'     
#'
#' @param spp_code string. unique species identifier
#' @param years Optional. integer or vector of integer for the years desired. years must be consecutive.
#' @param start_date Optional. A string with format 'YYYY-MM-DD'. Get visit information from this date forward. Default is all prior dates.
#' @param end_date   Optional. A string with format 'YYYY-MM-DD'. Get visit information up to this date. Default is all dates up to todays date.
#' @param shape string. 'wide' or 'long' for a data.frame in the respective format. default 'long'
#'
#' @return data.frame of phenophases by date
#' @export
#'
#' @examples
#' get_species_phenophase('PRGL')
#' get_species_phenophase('PRGL', start_date = '2012-01-01', end_date = '2012-12-31')
get_species_phenophase = function(spp_code, years = NULL, start_date = NULL, end_date = NULL, shape = 'long'){
  date_info = parse_dates(years = years, start_date = start_date, end_date = end_date)
  start_date = date_info$start_date
  end_date   = date_info$end_date
  
  con <- db_connect()
  
  plant_info <- dplyr::tbl(con, 'focal_plant_info')
  plant_info <- dplyr::filter(plant_info, SPP_CODE == spp_code)
  plant_info <- dplyr::collect(plant_info)
  
  if(nrow(plant_info) == 0) stop('spp_code not found: ',plant_id)
  
  # Individual plant info is divided into tables by function group.
  # All individuals for 1 species will be located in the same 
  # functional group table.
  fg <- unique(plant_info$FUNC_GRP_CODE)
  
  if(length(fg)>1){stop('Great than 1 functional group found for spp code: ',spp_code)}
  
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
                                   DATE >= start_date, DATE <= end_date)
  plant_phenology <- dplyr::collect(plant_phenology)
  
  DBI::dbDisconnect(con)
  
  plant_phenology <- add_individual_plant_info(plant_phenology)
  plant_phenology <- add_year_doy_columns(plant_phenology)
  
  plant_phenology <- dplyr::filter(plant_phenology, SPP_CODE == spp_code)
  
  if(shape == 'long'){
    plant_phenology =  tidyr::pivot_longer(plant_phenology,
                                           cols = tidyr::starts_with(table_column_starts_with),
                                           names_to = 'PHENOPHASE',
                                           values_to = 'STATUS')
  }
  
  return(plant_phenology)
}


#' @name get_site_phenophase
#' 
#' @title Get all plant phenophases for a site. 
#' 
#' @description Retrieve phenophase data for all plants at a specific site. Can be subset to specific years,
#'     or specific start and end dates. Since sites include multiple functional groups, 
#'     this only returns in the long format with columns:
#'     
#'      c('PLANT_ID','DATE','PHENOPHASE','STATUS','NOTE_FLAG','PHOTO_FLAG','SITE_CODE', 'SPP_CODE', 'FUNC_GRP_CODE')
#'
#' @param site_code string. 2 letter site code
#' @param years Optional. integer or vector of integer for the years desired. years must be consecutive.
#' @param start_date Optional. A string with format 'YYYY-MM-DD'. Get visit information from this date forward. Default is all prior dates.
#' @param end_date   Optional. A string with format 'YYYY-MM-DD'. Get visit information up to this date. Default is all dates up to todays date.
#'
#' @return data.frame
#' @export
#'
#' @examples
#' get_site_phenophase(site_code = 'NO')
get_site_phenophase = function(site_code, years = NULL, start_date = NULL, end_date = NULL){
  # TODO: If this becomes too slow it can be sped up by doing everything in 
  # just a few connection calls isntead of using get_plant_phenophase for every 
  # individual. 
  
  date_info = parse_dates(years = years, start_date = start_date, end_date = end_date)
  start_date = date_info$start_date
  end_date   = date_info$end_date
  
  site_info = get_site_list()
  if(!site_code %in% site_info$SITE_CODE) stop('Unknown site code: ', site_code)
  
  con <- db_connect()
  plant_info <- dplyr::tbl(con, 'focal_plant_info')
  plant_info <- dplyr::filter(plant_info, SITE_CODE == site_code)
  plant_info <- dplyr::collect(plant_info)
  
  all_phenophases = data.frame()
  for(plant_id in plant_info$PLANT_ID){
    p = get_plant_phenophase(plant_id = plant_id,
                             start_date = start_date,
                             end_date   = end_date,
                             shape = 'long')
    all_phenophases = dplyr::bind_rows(all_phenophases, p)
  }
  
  DBI::dbDisconnect(con)
  
  return(all_phenophases)
}


#' @name get_fg_phenophase
#' 
#' @title Get all plant phenophases for a functional group.
#' 
#' @description This retrieves all phenophase data for a specific functional group at all sites. This can be subset to specific years,
#'     or specific start and end dates.
#'     
#'     Functional Groups are:  
#'     'PG' - perennial grass
#'     'DS' - deciduous shrubs
#'     'ES' - evergreen shrubs
#'     'SU' - succulents
#'     
#'      If shape = 'long' (the default) then columns will be:   
#'      c('PLANT_ID','DATE','PHENOPHASE','STATUS','NOTE_FLAG','PHOTO_FLAG','SITE_CODE', 'SPP_CODE', 'FUNC_GRP_CODE')  
#'      
#'      If shape = 'wide' then all thephenophase codes will be columns.
#'
#' @param site_code string 2 letter site code
#' @param years Optional. integer or vector of integer for the years desired. years must be consecutive.
#' @param start_date Optional. A string with format 'YYYY-MM-DD'. Get visit information from this date forward. Default is all prior dates.
#' @param end_date   Optional. A string with format 'YYYY-MM-DD'. Get visit information up to this date. Default is all dates up to todays date.
#' @param shape string. 'wide' or 'long' for a data.frame in the respective format. default 'long'
#'
#' @return data.frame
#' @export
#'
#' @examples
#' get_fg_phenophase(site_code = 'NO')
get_fg_phenophase = function(functional_group, years = NULL, start_date = NULL, end_date = NULL, shape='long'){
  if(!functional_group %in% c('PG','DS','ES','SU')) stop('Unknown functional group: ', functional_group)
  
  date_info = parse_dates(years = years, start_date = start_date, end_date = end_date)
  start_date = date_info$start_date
  end_date   = date_info$end_date
  
  plant_table <- dplyr::case_when(
    functional_group == 'PG' ~ 'pg_pheno', # perennial grass
    functional_group == 'DS' ~ 'ds_pheno', # deciduous shrub
    functional_group == 'ES' ~ 'es_pheno', # evergreen shrub
    functional_group == 'SU' ~ 'su_pheno'  # succulent
  )
  
  # each function group table has it's own columns
  # representing bbch codes.
  table_column_starts_with <- dplyr::case_when(
    functional_group == 'PG' ~ 'GR_', # perennial grass
    functional_group == 'DS' ~ 'DS_', # deciduous shrub
    functional_group == 'ES' ~ 'BE_', # evergreen shrub
    functional_group == 'SU' ~ 'CA_'  # succulent
  )
  
  con <- db_connect()
  all_phenophases <- dplyr::tbl(con, plant_table)
  all_phenophases <- dplyr::filter(all_phenophases, DATE >= start_date & DATE <= end_date)
  all_phenophases <- dplyr::collect(all_phenophases)
  
  DBI::dbDisconnect(con)
  
  all_phenophases = add_individual_plant_info(all_phenophases)
  all_phenophases = add_year_doy_columns(all_phenophases)
  
  if(shape == 'long'){
    all_phenophases =  tidyr::pivot_longer(all_phenophases,
                                            cols = tidyr::starts_with(table_column_starts_with),
                                            names_to = 'PHENOPHASE',
                                            values_to = 'STATUS')
  }
  
  return(all_phenophases)
}
