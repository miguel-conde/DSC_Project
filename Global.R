#'
#' MODULE Global.R
#' 

dirModelsSBO <- file.path(".", "models", "modelsSBO")
dirR <- file.path(".", "R")

m.BlogsFile   <- file.path(dirModelsSBO,  "m.Blogs.RData")
m.NewsFile    <- file.path(dirModelsSBO,  "m.News.RData")
m.TwitterFile <- file.path(dirModelsSBO,  "m.Twitter.RData")
m.TotalFile   <- file.path(dirModelsSBO,  "m.Total.RData")

source(file.path(dirR, "predict.R"))
source(file.path(dirR, "makeTFLs.R"))
source(file.path(dirR, "managePunct.R"))
source(file.path(dirR, "splitIntoTokens.R"))

library(RWeka)
library(tm)
library(data.table)

oldSelModel <<- ""

#model <<- loadModelTotal()

#' 
#' @name arrangePred(words)
#' 

arrangePred <- function(words) {
  
  res <- words[1]
  
  nWords <- length(words)
  if (nWords > 1)
  sapply(words[2:nWords], function(x) {
    res <<- paste0(res, ", ", x)
  })
  
  return(res)
}