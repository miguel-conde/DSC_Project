#'
#' MODULE Global.R
#' 

dirModelsSBO <- file.path(".", "models", "modelsSBO")
dirR <- file.path(".", "R")

m.BlogsFile   <- file.path(dirModelsSBO, "m.Blogs.RData")
m.NewssFile   <- file.path(dirModelsSBO, "m.News.RData")
m.TwitterFile <- file.path(dirModelsSBO, "m.Twitter.RData")
m.TotalFile   <- file.path(dirModelsSBO, "m.Total.RData")

source(file.path(dirR, "predict.R"))
source(file.path(dirR, "makeTFLs.R"))

model <<- loadModelTotal()