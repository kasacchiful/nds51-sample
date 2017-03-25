library(dplyr)

data.library2014 <- read.csv("2014toshokanriyo.csv")
head(rename(select(data.library2014, 図書館名, 開館日数.日.), name=図書館名, open_days=開館日数.日.), 5)

data.library2014 <- read.csv("2014toshokanriyo.csv")
data.library2014 %>%
  select(図書館名, 開館日数.日.) %>%
  rename(name=図書館名, open_days=開館日数.日.) %>%
  head(5)
