
set_phenometR_backend('test-db')

test_that('Dates must be sequental', {
  expect_error(parse_dates(years=NULL, start_date='2015-01-01', end_date='2014-01-01'))
})

test_that('Dates must be YYYY-MM-DD',{
  expect_error(parse_dates(years=NULL, start_date=NULL, end_date='201-01-01'))
  expect_error(parse_dates(years=NULL, start_date='2012-1-1', end_date=NULL))
  expect_error(parse_dates(years=NULL, start_date=NULL, end_date='2012-1-01'))
  expect_silent(parse_dates(years=NULL, start_date='2010-01-01', end_date='2014-01-01'))
  expect_silent(parse_dates(years=NULL, start_date=NULL, end_date=NULL))
})

test_that('get_fg_phenophase returns stuff',{
  expect_silent(get_fg_phenophase('PG'))
  expect_silent(get_fg_phenophase('DS'))
  expect_silent(get_fg_phenophase('ES'))
  expect_silent(get_fg_phenophase('SU'))
})

# Must remove entires from plant_info that are no longer 
# in the main phenophase tables.
# test_that('get_site_phenophase site resturns stuff',{
#   expect_silent(get_site_phenophase('GI'))
#   expect_silent(get_site_phenophase('P9'))
#   expect_silent(get_site_phenophase('NO'))
# })

test_that('get_species_phenophase returns stuff',{
  expect_silent(get_species_phenophase('SPCO'))
  expect_silent(get_species_phenophase('MUPO'))
  expect_silent(get_species_phenophase('PRGL'))
})

test_that('get_fg_phenophase catches invalid functional group',{
  expect_error(get_fg_phenophase('abc'))
})

test_that('get_site_phenophase catches invalid site',{
  expect_error(get_site_phenophase('abc'))
})

test_that('get_species_phenophase catches invalid speces',{
  expect_error(get_site_phenophase('abc'))
})

test_that('add_percent_cover_column() working correctly for PRGL',{
  has_cover_values = add_percent_cover_column(get_species_phenophase('PRGL'))
  has_cover_values = dplyr::filter(has_cover_values, PHENOPHASE %in% c('DS_202','DS_214'))
  expect_true(all(!is.na(has_cover_values$PERCENT_COVER)))
  expect_true(all((has_cover_values$PERCENT_COVER >= 0) & (has_cover_values$PERCENT_COVER <= 100)))
})

test_that('add_percent_cover_column() working correctly for perennial grasses',{
  has_cover_values = add_percent_cover_column(get_fg_phenophase('PG'))
  has_cover_values = dplyr::filter(has_cover_values, PHENOPHASE %in% c('GR_202'))
  expect_true(all(!is.na(has_cover_values$PERCENT_COVER)))
  expect_true(all((has_cover_values$PERCENT_COVER >= 0) & (has_cover_values$PERCENT_COVER <= 100)))
})

test_that('add_percent_cover_column() adding NA to non-relavant phenophases',{
  # All PG phenophases except GR_202 should be NA
  has_cover_values = add_percent_cover_column(get_fg_phenophase('PG'))
  has_cover_values = dplyr::filter(has_cover_values, PHENOPHASE !='GR_202')
  expect_true(all(is.na(has_cover_values$PERCENT_COVER)))
})
