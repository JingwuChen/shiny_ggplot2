library(rvest)
#library(RSelenium)
library(stringr)

get_response<-function(url){
  #pJS <- phantom()
  #remDr <- remoteDriver(browserName = "phantomjs")
  #remDr$open() 
  #remDr$navigate(url)
  #response<- remDr$getPageSource()[[1]]
  #content<-read_html(response,encoding = "utf-8")
  content<-read_html(url,encoding = "utf-8")
  price<-html_nodes(content,css = "#list-content > div > div.zu-side > p > strong") %>% html_text()
  price<-as.numeric(price)
  area<-html_nodes(content,css = "#list-content > div > div.zu-info > address") %>% html_text()
  area<-trimws(area)
  district<-substr( trimws(substring(area,20)),1,2)
  size<-html_nodes(content,css = "#list-content > div > div.zu-info > p.details-item.tag") %>% html_text()
  size<-trimws(size)
  house<-strsplit(size,split = "|",fixed = T)
  house_layout<-sapply(house,"[",1)
  house_size<-sapply(house,"[",2)
  house_size<-as.numeric(str_extract(house_size, "\\d+"))
  data<-data.frame(district,house_layout,house_size,price)
  #remDr$close
  #pJS$stop()
  return(data)
}
get_data<-function(n=10) {
  data<-c()
  if(n<=50){
  for(i in 1:n){
    if(i==1){
      url<-"https://gz.zu.anjuke.com/"
    }
    else {
    url<-sprintf("https://gz.zu.anjuke.com/fangyuan/p%d/",i)
    }
    master<-get_response(url)
    data<-rbind(master,data)
   
  }
    
  }
  data<-data[data$district!="广州",]
  return(data)
}
