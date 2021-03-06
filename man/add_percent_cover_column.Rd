% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/table_addons.R
\name{add_percent_cover_column}
\alias{add_percent_cover_column}
\title{Add column for the percent cover}
\usage{
add_percent_cover_column(df)
}
\arguments{
\item{df}{a data.frame from a get_*_phenophase function}
}
\value{
data.frame
}
\description{
Some phenophases are for the percent cover of green leaves
    but use an ordinal scale. This adds the column PERCENT_COVER
    for when those phenophases are present.
    If other phenophases are not present in the data.frame then the percent
    cover for those entries will be NA.

    The relavant phenophases are:
    'DS_202' - Percentage of leaves green for deciduous shrubs
    'DS_214' - Percentage of canopy full with colored leaves for deciduous shrubs
    'GR_202' - Percentage of canopy green for perennial grasses
}
\examples{
get_fg_phenophase(functional_group = 'DS') \%>\%
    add_percent_cover_column()
}
