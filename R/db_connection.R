# ------------------------
# Phenomet database connection functions
# ------------------------


#' Helper function
#'
#' Use with try to detect and handle errors
#'
#' con = try(DBIConnect(..))
#' if(is_error(con)){
#'   handle error...
#' }
#'
#' @return bool
is_error <- function(x){
  inherits(x, "try-error")
}

#' Set the database backend.
#' 
#' Set by default to the primary jornada server. 
#' Use this to set to a local sqlite db
#' for testing only
#'
#' @param backend string. one of 'jornada-server' or 'test-db'
#'
#' @export
set_phenometR_backend = function(backend){
  if(!backend %in% c('jornada-server','test-db')){
    stop('Invalid backend: ',backend)
  }
  options(phenometR.backend = backend)
}

#' @name clear_credentials
#' 
#' @title Clear the stored database credentials
#' 
#' @description Clear the saved login information stored on your local machine. Try
#'     using this if your having trouble connecting to the database.
#'
#' @return None
#' @export
#'
clear_credentials = function(){
  credential_file = getOption('phenometR.credential_file')
  if(file.exists(credential_file)){
    a = file.remove(credential_file)
  }
}

#' Get database credentials
#'
#' This will prompt for credentials first and store them, so
#' it only needs to ask for credentials once per session.
#'
#' @return list of credential info
#' @export
#'
get_credentials = function(){
  credential_file = getOption('phenometR.credential_file')

  # Are they stored already?
  if(file.exists(credential_file)){
    c = yaml::read_yaml(credential_file)
  } else {
    # ask for credentials
    c = list()
    c$db_host <- 'jornada-vdbmy.jrn.nmsu.edu'
    c$db_user <- readline('Enter the phenomet database USERNAME: ')
    c$db_pw   <- readline('Enter the phenomet database PASSWORD:  ')
    c$db_name <- readline('Enter the phenomet database NAME: ')

    yaml::write_yaml(c, credential_file)
  }

  return(c)
}

#' Connect to the database
#'
#' Will prompt for credentials via get_credentials() if they are
#' not already stored.
#'
#' @return DBI Connecion object
#' @export
#'
db_connect <- function(){
  # Use a local sqlite db for testing purposes
  backend <- getOption('phenometR.backend')
  if(backend == 'test-db'){
    db_file = system.file("extdata", "test.db", package = "phenometR")
    con = try(DBI::dbConnect(RSQLite::SQLite(), dbname = db_file))
    if(is_error(con)) stop('Error load test.db database')
    return(con)
  } 
  
  # Otherwise connect to the primary mysql db
  connection_attempts = 3

  for(connection_i in 1:connection_attempts){
    c <- get_credentials()

    con = try(DBI::dbConnect(RMariaDB::MariaDB(),
                             host     = c$db_host,
                             dbname   = c$db_name,
                             user     = c$db_user,
                             password = c$db_pw))

    if(is_error(con)){
      if(grepl("Can't connect", con[1])){
        stop('Cannot connect to server: ',c$db_host, ', are you on the Jornada network?')

      } else if(grepl("Access denied for user", con[1])){
        clear_credentials()
        print('Login failed. Re-enter login info')

      } else {
        stop('Unknown connection error')
      }
    } else {
      return(con)
    }

    if(connection_i == connection_attempts){
      stop('Failed connecting to the database after ',connection_attemps, ' tries')
    }
  }
}
