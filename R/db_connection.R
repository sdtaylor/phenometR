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

#' Clear the stored database credentials
#'
#' @return None
#' @export
#'
clear_credentials = function(){
  credential_file = '~/.phenometR.yaml'
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
  credential_file = '~/.phenometR.yaml'

  # Are they stored already?
  c = try(yaml::read_yaml(credential_file), silent=TRUE)

  if(is_error(c)){
    # ask for credentials
    c = list()
    c$db_host <- 'jornada-vdbmy.jrn.nmsu.edu'
    c$db_name <- readline('Enter the phenomet database name: ')
    c$db_user <- readline('Enter the phenomet database username: ')
    c$db_pw   <- readline('Enter the phenomet database password:  ')

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
