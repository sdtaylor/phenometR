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