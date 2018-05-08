
#' Get R version for Windows from CRAN
#'
#' @return R version string for Windows ("R-x.x.x")
r_cran_version_win <- function() {
  text <- readLines("https://cran.r-project.org/bin/windows/base/")
  r_winver <- unique(stringr::str_extract(text, "R-[0-9]{1}\\.[0-9]{1}\\.[0-9]{1}"))
  r_winver <- r_winver[!is.na(r_winver)]
  return(r_winver[[1]])
}

#' Get link to NEWS of R for Windows
#'
#' @return a string like
#' "https://cran.r-project.org/bin/windows/base/NEWS.R-x.x.x.html"
#' with the last R version (R.x.x.x) for Windows
#'
cran_news_windows <- function() {
  stringr::str_replace(
    "https://cran.r-project.org/bin/windows/base/NEWS.R-x.x.x.html",
    "R-x.x.x",
    r_cran_version_win()
  )
}
