
library(ggplot2)
library(ggmap)
library(dplyr)
library(tidyr)
library(readr)

# 地図の中心地点を指定
niigata <- c(139.0255893, 37.8490611)

## 屋内避難所 & 屋外避難場所
#data.indoor_shelter  <- read_csv("http://www.city.niigata.lg.jp/shisei/seisaku/it/open-data/opendata-gis/od-gis_kurashibosai/od-gis_okunaihinanjo.files/od_gis_10161_okunaihinanjo.csv")
#data.outdoor_shelter <- read_csv("http://www.city.niigata.lg.jp/shisei/seisaku/it/open-data/opendata-gis/od-gis_kurashibosai/od-gis_okugaihinan.files/od_gis_10162_okugaihinanbasho.csv")
data.indoor_shelter  <- read_csv("od_gis_10161_okunaihinanjo.csv")
data.outdoor_shelter <- read_csv("od_gis_10162_okugaihinanbasho.csv")

indoor <- data.indoor_shelter %>%
  rename(lon = longitude, lat = latitude)
outdoor <- data.outdoor_shelter %>%
  rename(lon = longitude, lat = latitude) %>%
  mutate(SAFIELD007 = NA, SAFIELD008 = NA, SAFIELD009 = NA, SAFIELD010 = NA)   # 足りないカラムを追加しなくてもunionは可能
data.shelter <- dplyr::union_all(indoor, outdoor)

# SAFIELD005（地区）の欠損値補完
data.shelter <- data.shelter %>%
  replace_na(list(SAFIELD005 = 'その他'))

# 地図描画
get_googlemap(niigata, zoom = 10, maptype = "roadmap", language = "ja-JP") %>%
  ggmap(extent = "device", darken = c(0.2, "black")) +
  geom_point(data = data.shelter, aes(color = SAFIELD005, shape = SAFIELD006)) +
  theme_bw(base_family = "HiraKakuProN-W3") +
  xlab("") + ylab("") +
  labs(color = "地区", shape = "屋内/屋外", title = "新潟市の屋内/屋外避難所") +
  guides(shape = guide_legend(order = 1), colour = guide_legend(order = 2)) +
  theme(axis.ticks = element_blank(), axis.text = element_blank())
