install.packages("readxl") # 엑셀을 읽어주는 패키지
install.packages("ggmap") # 구글 지도 활용 패키지
install.packages("ggplot2") # 다양한 그래프를 그릴 수 있는 패키지
install.packages("dplyr") #데이터 전처리용 패키지

library(readxl)
library(ggmap)
library(dplyr)
library(ggplot2)

getwd()
readxl::read_excel("C:/Users/Master/Desktop/제주시 충전소 리스트(수정).xlsx")
my.file.path <- ("C:/Users/Master/Desktop/제주시 충전소 리스트(수정).xlsx")
electirc_car <- readxl::read_excel(my.file.path)


str(electirc_car)

jeju.data <- electirc_car%>%
  dplyr::select(충전소, 주소, 분류) 
jeju.data

APIKEY <- "AIzaSyDt-5Ph1-50HchgHjrHNtSEPVhrqHjvUiU"
ggmap::register_google(key = APIKEY)


scwg <- ggmap::mutate_geocode(data = 제주시 충전소 리스트(수정), location = 주소, source = "google")
str(scwg)
View(scwg)

scwg1 <- scwg%>%
  dplyr::filter(!is.na(lon))

jjmap <- get_googlemap("JEJU-DO", maptype = "roadmap", zoom = 10)

jeju <- ggmap(jjmap)+geom_point(data = scwg1, aes(x = lon , y = lat, colour = factor(분류)), size = 1)
jeju

