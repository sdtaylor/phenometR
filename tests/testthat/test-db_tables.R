

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

test_that('Phenophase functional group returns',{
  expect_silent(get_fg_phenophase('PG'))
  expect_silent(get_fg_phenophase('DS'))
  expect_silent(get_fg_phenophase('ES'))
  expect_silent(get_fg_phenophase('SU'))
})