# ------------------------
# Some global options
# ------------------------

.onLoad = function(libname, pkgname){
  options(phenometR.backend = 'jornada-server',
          phenometR.testdb_file = './data/test.db', 
          phenometR.credential_file   = '~/.phenometR.yaml')
}