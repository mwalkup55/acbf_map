library(shiny)
df <- read.csv('data/brewery_list.csv',row.names=1)

shinyUI(fluidPage(
  titlePanel('ACBF Route Optimizer'),
  sidebarLayout(
    sidebarPanel(
      selectizeInput(
        'brewlist', 'Select Breweries', choices = rownames(df), multiple = TRUE
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot",plotOutput(outputId = "routeplot", height = "800px")),
        tabPanel("List",tableOutput(outputId = "routetable"))
      )
    )
    )
))