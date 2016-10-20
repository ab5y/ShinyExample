setwd('c:\\Users\\Abhay\\Code\\ShinyExample')
parseCSV <- function(inFile, header, sep, quote) {
  # if (is.null(inFile))
  #   return(NULL)
  # 
  return(read.csv("data.csv", header=header, sep=sep))
}