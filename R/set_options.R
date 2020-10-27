# ------------------------
# Some global options
# ------------------------

.onLoad = function(libname, pkgname){
  options(phenometR.backend = 'jornada-server',
          phenometR.test_db_file = './tests/test.db', 
          phenometR.testthat_db_file = '../../tests/test.db', 
          phenometR.credential_file   = '~/.phenometR.yaml')
}