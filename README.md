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

## Phenophase Info

Use the codes below to filter for specific phenophases. Note that 'status' phenophases are 0/1 while `count` phenophases are abundances or percentages.

| Functional Group | Phenophase Type | Phenophase Code | Phenophase Description                                             |
|------------------|-----------------|-----------------|--------------------------------------------------------------------|
|**Evergreen Shrub**| status          | BE_01           | Breaking leaf buds for evergreen shrubs                            |
|                  | status          | BE_02           | Young unfolded leaves for evergreen shrubs                         |
|                  | status          | BE_03           | Flower buds for evergreen shrubs                                   |
|                  | status          | BE_04           | Open flowers for deciduous shrubs                                  |
|                  | status          | BE_05           | Full flowering for evergreen shrubs                                |
|                  | status          | BE_06           | Unripe fruits for evergreen shrubs                                 |
|                  | status          | BE_07           | Ripe fruits for evergreen shrubs                                   |
|                  | count           | BE_203          | Number of flower buds for evergreen shrubs                         |
|                  | count           | BE_204          | Number of open flowers for evergreen shrubs                        |
|                  | count           | BE_205          | Percentage of flowers open for evergreen shrubs                    |
|                  | count           | BE_206          | Number of unripe fruits for evergreen shrubs                       |
|                  | count           | BE_207          | Number of ripe fruits for evergreen shrubs                         |
| **Succulent**    | status          | CA_01           | Flower buds for cacti                                              |
|                  | status          | CA_02           | Open flowers for cacti                                             |
|                  | status          | CA_03           | Unripe fruits for cacti                                            |
|                  | status          | CA_04           | Ripe fruits for cacti                                              |
|                  | status          | CA_05           | Full flowering for cacti                                           |
|                  | count           | CA_201          | Number of flower buds for cacti                                    |
|                  | count           | CA_202          | Number of open flowers for cacti                                   |
|                  | count           | CA_203          | Number of unripe fruits for cacti                                  |
|                  | count           | CA_204          | Number of ripe fruits for cacti                                    |
|                  | count           | CA_205          | Percentage of flowers open for cacti                               |
|**Deciduous Shrub**| status          | DS_01           | Breaking leaf buds for deciduous shrubs                            |
|                  | status          | DS_02           | Leaves for deciduous shrubs                                        |
|                  | status          | DS_03           | >25% and <75% of full leaf size for deciduous shrubs               |
|                  | status          | DS_04           | >/=75% of full leaf size for deciduous shrubs                      |
|                  | status          | DS_05           | >50% of leaves fallen for deciduous shrubs                         |
|                  | status          | DS_06           | All leaves fallen for deciduous shrubs                             |
|                  | status          | DS_07           | Flower buds for deciduous shrubs                                   |
|                  | status          | DS_08           | Open flowers for deciduous shrubs                                  |
|                  | status          | DS_09           | Full flowering for deciduous shrubs                                |
|                  | status          | DS_10           | Unripe fruits for deciduous shrubs                                 |
|                  | status          | DS_11           | Ripe fruits for deciduous shrubs                                   |
|                  | status          | DS_12           | Recent fruit drop for deciduous shrubs                             |
|                  | count           | DS_202          | Percentage of leaves green for deciduous shrubs                    |
|                  | count           | DS_207          | Number of flower buds for deciduous shrubs                         |
|                  | count           | DS_208          | Number of open flowers for deciduous shrubs                        |
|                  | count           | DS_209          | Percentage of flowers open for deciduous shrubs                    |
|                  | count           | DS_210          | Number of unripe fruits for deciduous shrubs                       |
|                  | count           | DS_211          | Number of ripe fruits for deciduous shrubs                         |
|                  | count           | DS_213          | Colored leaves for deciduous shrubs                                |
|                  | count           | DS_214          | Percentage of canopy full with colored leaves for deciduous shrubs |
| **Perennial Grass**  | status          | GR_01           | Initial growth for perennial grasses                               |
|                  | status          | GR_02           | Leaves for perennial grasses                                       |
|                  | status          | GR_03           | All leaves withered for perennial grasses                          |
|                  | status          | GR_04           | Flower heads for perennial grasses                                 |
|                  | status          | GR_05           | Open flowers for perennial grasses                                 |
|                  | status          | GR_06           | Unripe fruits for perennial grasses                                |
|                  | status          | GR_07           | Ripe fruits for perennial grasses                                  |
|                  | status          | GR_08           | More green than brown for perennial grasses                        |
|                  | status          | GR_09           | Full flowering for perennial grasses                               |
|                  | count           | GR_202          | Percentage of canopy green for perennial grasses                   |
|                  | count           | GR_204          | Number of flower heads for perennial grasses                       |
|                  | count           | GR_205          | Number of open flowers for perennial grasses                       |
|                  | count           | GR_206          | Number of unripe fruits for perennial grasses                      |
|                  | count           | GR_207          | Number of ripe fruits for perennial grasses                        |
|                  | count           | GR_209          | Percentage of flowers open for perennial grasses                   |