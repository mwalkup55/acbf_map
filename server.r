library(shiny)
library(png)
library(TSP)
library(ripa)

img <- readPNG('data/map.PNG')
df <- read.csv('data/brewery_list.csv',row.names=1)
start_point <- data.frame(x=337.2027,y=23.22377,row.names='Start')

shinyServer(function(input, output) {
  final_route <- reactive({
    breweries <- input$brewlist
    my_stops <- rbind(start_point,df[breweries,c('x','y')])
    atsp <- as.ATSP(dist(my_stops))
    st <- which(labels(atsp) == "Start")
    atsp[, st] <- 0
    initial_tour <- solve_TSP(atsp, method="nn")
    tour <- solve_TSP(atsp, method ="two_opt", control = list(tour = initial_tour))
    path <- cut_tour(tour, st, exclude_cut = FALSE)
    rbind(start_point,df[labels(path)[-1],-1])
  })
  output$routeplot <- renderPlot({
    if (length(input$brewlist)<=1) {
      plot(imagematrix(img))
    } else{
      plot(imagematrix(img))
      lines(final_route(),lwd=2)
      text(final_route(),labels=rownames(final_route()))
    }
  })
  output$routetable <- renderTable({
    df[rownames(final_route()[-1,]),-c(2,3),drop=FALSE]
  })
})