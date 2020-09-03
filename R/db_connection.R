# ------------------------
# Phenomet database connection functions
# ------------------------


#' Clear the stored database credentials
#'
#' @return None
#' @export
#'
clear_credentials = function(){

  Sys.unsetenv('phenomet_db_host')
  Sys.unsetenv('phenomet_db_name')
  Sys.unsetenv('phenomet_db_user')
  Sys.unsetenv('phenomet_db_pw')
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

  # Are they stored already?
  db_name = Sys.getenv('phenomet_db_name')
  if(db_name==''){
    # ask for credentials
    db_host <- 'jornada-vdbmy.jrn.nmsu.edu'
    db_name <- readline('Enter the phenomet database name: ')
    db_user <- readline('Enter the phenomet database username: ')
    db_pw   <- readline('Enter the phenomet database password:  ')

    Sys.setenv(phenomet_db_host = db_host)
    Sys.setenv(phenomet_db_name = db_name)
    Sys.setenv(phenomet_db_user = db_user)
    Sys.setenv(phenomet_db_pw   = db_pw)
  }

  db_host <- Sys.getenv('phenomet_db_host')
  db_name <- Sys.getenv('phenomet_db_name')
  db_user <- Sys.getenv('phenomet_db_user')
  db_pw   <- Sys.getenv('phenomet_db_pw')

  return(list(db_host = db_host, db_name = db_name, db_user = db_user, db_pw = db_pw))
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
  connection_attempts = 3

  is_error      <- function(x) inherits(x, "try-error")

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
