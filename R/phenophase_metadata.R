#' @name get_phenophase_metadata
#' 
#' @title Get phenophase metadata
#' 
#' @description Get a data.frame describing all the phenophases codes.
#' 
#' The phenophase metadata includes the columns:
#' functional_group, phenophase_type, phenophase, phenophase_desc
#'
#'
#' @return data.frame of phenophase metadata
#' @export
#'
#' @examples
#' get_phenophase_metadata()
get_phenophase_metadata = function(){
  
  dplyr::tribble(
  ~functional_group,~phenophase_type,~phenophase,~phenophase_desc,
  'ES','status','BE_01','Breaking leaf buds for evergreen shrubs',
  'ES','status','BE_02','Young unfolded leaves for evergreen shrubs',
  'ES','status','BE_03','Flower buds for evergreen shrubs',
  'ES','status','BE_04','Open flowers for deciduous shrubs',
  'ES','status','BE_05','Full flowering for evergreen shrubs',
  'ES','status','BE_06','Unripe fruits for evergreen shrubs',
  'ES','status','BE_07','Ripe fruits for evergreen shrubs',
  'ES','count','BE_203','Number of flower buds for evergreen shrubs',
  'ES','count','BE_204','Number of open flowers for evergreen shrubs',
  'ES','percent','BE_205','Percentage of flowers open for evergreen shrubs',
  'ES','count','BE_206','Number of unripe fruits for evergreen shrubs',
  'ES','count','BE_207','Number of ripe fruits for evergreen shrubs',
  'SU','status','CA_01','Flower buds for cacti',
  'SU','status','CA_02','Open flowers for cacti',
  'SU','status','CA_03','Unripe fruits for cacti',
  'SU','status','CA_04','Ripe fruits for cacti',
  'SU','status','CA_05','Full flowering for cacti',
  'SU','count','CA_201','Number of flower buds for cacti',
  'SU','count','CA_202','Number of open flowers for cacti',
  'SU','count','CA_203','Number of unripe fruits for cacti',
  'SU','count','CA_204','Number of ripe fruits for cacti',
  'SU','percent','CA_205','Percentage of flowers open for cacti',
  'DS','status','DS_01','Breaking leaf buds for deciduous shrubs',
  'DS','status','DS_02','Leaves for deciduous shrubs',
  'DS','status','DS_03','>25% and <75% of full leaf size for deciduous shrubs',
  'DS','status','DS_04','>/=75% of full leaf size for deciduous shrubs',
  'DS','status','DS_05','>50% of leaves fallen for deciduous shrubs',
  'DS','status','DS_06','All leaves fallen for deciduous shrubs',
  'DS','status','DS_07','Flower buds for deciduous shrubs',
  'DS','status','DS_08','Open flowers for deciduous shrubs',
  'DS','status','DS_09','Full flowering for deciduous shrubs',
  'DS','status','DS_10','Unripe fruits for deciduous shrubs',
  'DS','status','DS_11','Ripe fruits for deciduous shrubs',
  'DS','status','DS_12','Recent fruit drop for deciduous shrubs',
  'DS','percent','DS_202','Percentage of leaves green for deciduous shrubs',
  'DS','count','DS_207','Number of flower buds for deciduous shrubs',
  'DS','count','DS_208','Number of open flowers for deciduous shrubs',
  'DS','percent','DS_209','Percentage of flowers open for deciduous shrubs',
  'DS','count','DS_210','Number of unripe fruits for deciduous shrubs',
  'DS','count','DS_211','Number of ripe fruits for deciduous shrubs',
  'DS','status','DS_213','Colored leaves for deciduous shrubs',
  'DS','percent','DS_214','Percentage of canopy full with colored leaves for deciduous shrubs',
  'PG','status','GR_01','Initial growth for perennial grasses',
  'PG','status','GR_02','Leaves for perennial grasses',
  'PG','status','GR_03','All leaves withered for perennial grasses',
  'PG','status','GR_04','Flower heads for perennial grasses',
  'PG','status','GR_05','Open flowers for perennial grasses',
  'PG','status','GR_06','Unripe fruits for perennial grasses',
  'PG','status','GR_07','Ripe fruits for perennial grasses',
  'PG','status','GR_08','More green than brown for perennial grasses',
  'PG','status','GR_09','Full flowering for perennial grasses',
  'PG','percent','GR_202','Percentage of canopy green for perennial grasses',
  'PG','count','GR_204','Number of flower heads for perennial grasses',
  'PG','count','GR_205','Number of open flowers for perennial grasses',
  'PG','count','GR_206','Number of unripe fruits for perennial grasses',
  'PG','count','GR_207','Number of ripe fruits for perennial grasses',
  'PG','percent','GR_209','Percentage of flowers open for perennial grasses'
  )
}