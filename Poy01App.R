# load packages
library(shiny)
library(tidyverse)
library(readxl)

ui <- fluidPage(
  titlePanel("Data Visualization App"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("datafile", "Upload Excel Data (.xlsx)", accept = ".xlsx"),
    ),
    
    mainPanel(
      plotOutput("dataPlot")
    )
  )
  
)

server <- function(input, output){
  output$dataPlot <- renderPlot({
    req(input$datafile) # Ensure a file is uploaded
    
    dat <- read_excel(input$datafile$datapath, sheet = 1)
    
    Fig_out <- ggplot(dat,
                      aes(x = dilution,
                          y = OD,
                          group = Sample,
                          color = Sample)) +
      geom_point() +
      stat_smooth(geom = "smooth", method = "loess", se = FALSE) +
      scale_x_continuous(breaks = seq(1,10,1)) +
      theme_bw() +
      labs(x = "log10(dilution)")
    
    Fig_out
  })
  
}

shinyApp(ui,server)