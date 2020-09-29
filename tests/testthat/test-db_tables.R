
set_phenometR_backend('testthat-db')

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

test_that('get_site_phenophase site resturns stuff',{
  expect_silent(get_site_phenophase('GI'))
  expect_silent(get_site_phenophase('P9'))
  expect_silent(get_site_phenophase('NO'))
})

test_that('get_fg_phenophase catches invalid functional group',{
  expect_error(get_fg_phenophase('abc'))
})

test_that('get_site_phenophase catches invalid site',{
  expect_error(get_site_phenophase('abc'))
})