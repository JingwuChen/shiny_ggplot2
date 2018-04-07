# shiny_ggplot2
## 本文采用rvest库爬取安居客，然后采用shiny库进行网页显示
shiny网页程序中采用ggplot2包进行生成图形，非常方便,想进一步学习，[参见shiny中文教程](http://yanping.me/shiny-tutorial/)
### rvest是hadley大神编程的类似python的beautifulsoup的R包，非常好用，[参见](https://github.com/hadley/rvest)
解析网页采用`read_html`函数，获取指定标签采用`html_nodes()`函数，获取标签里面的内容采用`html_text()`，本文中示例如下：
```R
content<-read_html(url,encoding = "utf-8")
price<-html_nodes(content,css = "#list-content > div > div.zu-side > p > strong") %>% html_text()
price<-as.numeric(price)
area<-html_nodes(content,css = "#list-content > div > div.zu-info > address") %>% html_text()
area<-trimws(area)
district<-substr( trimws(substring(area,20)),1,2)
size<-html_nodes(content,css = "#list-content > div > div.zu-info > p.details-item.tag") %>% html_text()
```

### ggplot2是R中成图的神器，引入图层的元素，有兴趣者可以去阅读《ggplot2:数据分析和图形艺术》，本文中示例如下:
```R
p<-ggplot(data=data_chosen(),aes(x=house_size,y=price))+
      geom_point(aes(color = house_layout),size=5)+
      xlab("房间大小（平方米）")+ylab("月租金（元）")
print(p)
```
