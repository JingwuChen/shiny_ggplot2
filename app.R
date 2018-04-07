library(shiny)

ui<-pageWithSidebar(
  
  #  Application title
  headerPanel("安居客广州租房价格图"),
  
  # Sidebar with sliders that demonstrate various available options
  
  sidebarPanel(
    sliderInput("integer", "Number of page to scrape:", 
                min=0, max=50, value=5),
    br(),
    radioButtons("district", "District of guangzhou:",
                 list("全广州"="Guangzhou",
                      "天河" = "Tianhe",
                      "越秀" = "Yuexiu",
                      "海珠" = "Haizhu",
                      "荔湾" = "Liwan",
                      "黄埔"="Huangpu",
                      "番禺"="Panyu"))
  
  ),
  # Show a plot summarizing the values entered
  mainPanel(
    h3(textOutput("房间大小 vs 月租金")), 
    
    plotOutput("pointPlot") 
  )
)



server<-function(input, output) {
  source("get_data.R",local = T)
  
  # Reactive expression to compose a data frame containing all of the values
  data_chosen <- reactive({
    
    # Compose data frame
    data<-get_data(input$integer)
    index_chosen<- switch(input$district,
                        "Guangzhou"="全广州",
                         "Tianhe" = "天河",
                         "Yuexiu"="越秀",
                         "Haizhu"="海珠" ,
                         "Liwan"="荔湾" ,
                         "Huangpu"="黄埔",
                         "Panyu"="番禺",
                        "全广州")
    if(index_chosen=="全广州"){
      data_use<-data
    } else {
      data_use<-data[data$district==index_chosen,]
    }
  })
  # Show the values using an HTML plot
  output$pointPlot <- reactivePlot(function() {
    ggplot(data=data_chosen(),aes(x=house_size,y=price))+
      geom_point(aes(color = house_layout,size=5))+
      xlab("房间大小（平方米）")+ylab("月租金（元）")
  })
  }

shinyApp(ui=ui,server = server)