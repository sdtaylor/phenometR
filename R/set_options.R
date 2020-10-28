# ------------------------
# Some global options
# ------------------------

.onLoad = function(libname, pkgname){
  options(phenometR.backend = 'jornada-server',
          phenometR.credential_file   = '~/.phenometR.yaml')
}