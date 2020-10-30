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

On the first connection it will prompt for the phenomet database username and  password. These will be saved locally so you don't have to enter them again.

Four main functions are available for accessing the database at different lebels. All of them return a data frame where every row represents the status for a specific plant_id, date, and phenophase. For example:  

```
PLANT_ID DATE       NOTES_FLAG PHOTO_FLAG SITE_CODE SPP_CODE FUNC_GRP_CODE   DOY  YEAR PHENOPHASE STATUS
   <chr>    <chr>           <int>      <int> <chr>     <chr>    <chr>         <dbl> <dbl> <chr>       <int>
 1 CRPRGL01 2010-03-17          0          0 CR        PRGL     DS               76  2010 DS_07           2
 2 CRPRGL02 2010-03-17          0          0 CR        PRGL     DS               76  2010 DS_07           2
 3 CRPRGL03 2010-03-17          0          0 CR        PRGL     DS               76  2010 DS_07           2
 4 CRPRGL04 2010-03-17          0          0 CR        PRGL     DS               76  2010 DS_07           2
 5 CRPRGL05 2010-03-17          0          0 CR        PRGL     DS               76  2010 DS_07           2
 6 GIPRGL01 2010-03-17          0          0 GI        PRGL     DS               76  2010 DS_07           2
 7 GIPRGL02 2010-03-17          0          0 GI        PRGL     DS               76  2010 DS_07           2
```

### The four main functions are:

- [get_plant_phenophase()](reference/get_plant_phenophase.html) returns all phenophase data for a specific `plant_id`.

- [get_site_phenophase()](reference/get_site_phenophase.html) returns all phenophase data for a specific `site_id`.

- [get_fg_phenophase()](reference/get_fg_phenophase.html) returns all phenophase data for a specific `functional_group`.

- [get_species_phenophase()](reference/get_species_phenophase.html) returns all phenophase data for a specific `spp_code`.

Other functions are described in the [reference](reference/index.html).

## Tutorials  

- [An example with mesquite flowering and leaf out](articles/mesquite_phenology.html)  

## Help & Suggestions

If you have any problems or suggestions please open an issue on the [Github repo](https://github.com/sdtaylor/phenometR/issues).