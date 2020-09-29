library(testthat)
library(phenometR)

set_phenometR_backend('test-db')

test_check("phenometR")
