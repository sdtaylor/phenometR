# ------------------------
# These functions add various columns to the 
# data.frames returned by the primary functions 
# in db_tables.R
# ------------------------


#' Add info on individual sites
#' 
#' Given a data.frame with columns PLANT_ID, this joins the following:
#' SITE_CODE, SPP_CODE, FUNC_GRP_CODE
#'
#' Meant to be used internally in phenometR
#' 
#' @param df 
#'
#' @return data.frame
#'
#' @examples
add_individual_plant_info = function(df){
  plant_info = get_plant_info()
  plant_info = dplyr::select(plant_info, PLANT_ID, SITE_CODE, SPP_CODE, FUNC_GRP_CODE)
  return(dplyr::left_join(df, plant_info, by='PLANT_ID'))
}


#' Add columns for the year and day of year (DOY)
#' 
#' Given a data.frame with column DATE this adds two
#' columns YEAR and DOY
#'
#' Meant to be used internally in phenometR
#' 
#' @param df a data.frame
#'
#' @return data.frame
add_year_doy_columns = function(df){
  df$DOY = as.numeric(format(as.Date(df$DATE), format='%j'))
  df$YEAR = as.numeric(format(as.Date(df$DATE), format='%Y'))
  return(df)
}


#' @name add_percent_cover_column
#' 
#' @title Add column for the percent cover
#' 
#' @description  Some phenophases are for the percent cover of green leaves
#'     but use an ordinal scale. This adds the column PERCENT_COVER
#'     for when those phenophases are present.
#'     If other phenophases are not present in the data.frame then the percent
#'     cover for those entries will be NA.
#'     
#'     The relavant phenophases are:
#'     'DS_202' - Percentage of leaves green for deciduous shrubs
#'     'DS_214' - Percentage of canopy full with colored leaves for deciduous shrubs
#'     'GR_202' - Percentage of canopy green for perennial grasses
#' 
#' @param df a data.frame from a get_*_phenophase function
#'
#' @return data.frame
#' @export
#'
#' @examples
#' get_fg_phenophase(functional_group = 'DS') %>%
#'     add_percent_cover_column()
add_percent_cover_column = function(df){
  
  percent_cover_values = dplyr::tribble(
    ~STATUS, ~PERCENT_COVER,
     0,       0,
     1,       2.5,
     2,       14.5,
     3,       37,
     4,       57,
     5,       84,
     6,       97.5
  )
  
  valid_phenophases = c('DS_202', # Percentage of leaves green for deciduous shrubs
                        'DS_214', # Percentage of canopy full with colored leaves for deciduous shrubs
                        'GR_202' # Percentage of canopy green for perennial grasses
                        )
  
  all_values = tidyr::expand_grid(percent_cover_values, PHENOPHASE = valid_phenophases)

  df = df %>%
    dplyr::left_join(all_values, by=c('PHENOPHASE','STATUS'))
  
  return(df)
}
