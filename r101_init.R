x <- read.csv("https://raw.githubusercontent.com/healthinnovation/upch_r101/main/list_pckg.csv", stringsAsFactors = F)

pckg <- unlist(x)

install.packages(pckg)

rm(x, pckg)
