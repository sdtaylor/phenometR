# phenometR

## Overview

phenometR is an interface to the phenomet phenology database at the Jornada Experimental Range. 


## Installation

Install directly from Github:

```
devtools::install_github('sdtaylor/phenometR')
```

If you don't have devtools installed, install it with:

```
install.packages('devtools')
```

## Overview

This package works only onsite at the Jornada office, or via the VPN. Otherwise it will fail to connect to the database.  

Three primary functions allow access to the database. 

#### get_plant_phenophase()

This function returns a data.frame of phenophase data for a specific `plant_id`.

#### get_site_phenophase()