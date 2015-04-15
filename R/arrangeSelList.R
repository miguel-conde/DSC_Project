#'
#' MODULE arrangeSelList
#' 

arrangeSelList <- function(pred) {

  p <- pred[[2]]
  colPredict <- grep("WG[1234]", names(p))
  colPredict <- colPredict[length(colPredict)]
  
  Max.Prob  <- as.character(p[p$Freq == max(p$Freq), colPredict])
  Others    <- as.character(p[p$Freq != max(p$Freq), colPredict])
  
  return(list(Max.Prob = Max.Prob, Others = Others))
}