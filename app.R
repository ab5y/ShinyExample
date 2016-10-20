library(shiny)
library(shinydashboard)

source("parseCSV.R")
setwd('c:\\Users\\Abhay\\Code\\ShinyExample')

charts <- c(
  "Histogram" = 1,
  "Density Plot" = 2,
  "Dot Plot" = 3,
  "Bar Plot" = 4,
  "Line Chart" = 5,
  "Pie Chart" = 6,
  "Box Plot" = 7,
  "Violin Plot" = 8,
  "Bag Plot" = 9,
  "Scatter Plot" = 10
)

ui <- fluidPage(
  titlePanel("Shiny Example"),
  sidebarLayout(
    sidebarPanel(
      fileInput(
        'inputFile',
        'Choose CSV File',
        accept = c(
          'text/csv',
          'text/comma-separated-values, text/plain',
          '.csv'
          )
        ),
      tags$hr(),
      checkboxInput(
        'cbIsHeader',
        'Header',
        TRUE
      ),
      radioButtons(
        'sep',
        'Separator',
        c(
          Comma=',',
          Semicolon=';',
          Tab='\t'
        ),
        ','
      ),
      radioButtons(
        'quote',
        'Quote',
        c(
          None='',
          'Double Quote'='"',
          'Single Quote'="'"
        ),
        '"'
      )
    ),
    mainPanel(
      fluidRow(
        box(title = "Stats",
            verbatimTextOutput("stats")),
        
        box(
          title = "Controls",
          uiOutput("choose_dataset_x"),
          uiOutput("choose_dataset_y"),
          # uiOutput("choose_chart")
          selectInput(
              "charts",
              "Charts",
              charts
          ),
          actionButton("btnPlot", "Plot!")
        )
      ),
      fluidRow(
        box(
          plotOutput("plot")
        )
      )
    )
  )
)

server <- function(input, output) {
  csvData <- NULL
  observeEvent(
    input$inputFile,
    {
      inFile <- input$inputFile
      csvData <- parseCSV(inFile, input$cbIsHeader, input$sep, input$quote)
      output$choose_dataset_x <- renderUI(
        selectInput(
          "dataset_x",
          "X:",
          as.list(colnames(csvData))
        )
      )
      output$choose_dataset_y <- renderUI(
        selectInput(
          "dataset_y",
          "Y:",
          as.list(colnames(csvData))
        )
      )
    }
  )
  
  observeEvent(
    input$btnPlot,
    {
      plotSelectedChart(input$charts, input$dataset_x, input$dataset_y)
    }
  )
  
  plotSelectedChart <- function(chartNum, datasetName, datasetName_Y=NULL) {
    inFile <- input$inputFile
    data <- parseCSV(inFile, input$cbIsHeader, input$sep, input$quote)[as.character(datasetName)]
    data_y <- parseCSV(inFile, input$cbIsHeader, input$sep, input$quote)[as.character(datasetName_Y)]
    
    output$stats <- renderPrint({
      summary(as.numeric(unlist(data)))
    })
    
    switch(chartNum,
      "1" = {
       output$plot <- renderPlot({ 
         hist(
           as.numeric(unlist(data)),
           main = datasetName,
           xlab = datasetName
         )
       })
      },
      "2" = {
        output$plot <- renderPlot({ 
          plot(
            density(
              as.numeric(unlist(data))
            ),
            main = datasetName,
            xlab = datasetName
          )
        })
      },
      "3" = {
        output$plot <- renderPlot({
          dotchart(
            table(data),
            #labels = row.names(df),
            main = datasetName,
            xlab = datasetName
          )
        })
      },
      "4" = {
        output$plot <- renderPlot({
          barplot(
            table(data),
            main = datasetName,
            xlab = datasetName
          )
        })
      },
      "5" = {
        output$plot <- renderPlot({
          plot(table(data), type="o")
          lines(table(data_y), type="o", col="blue")
          # lines(table(data), count.fields(table(data)))
        })
      },
      "6" = {
        output$plot <- renderPlot({
          pie(
            table(data),
            labels = data,
            main = datasetName
          )
        })
      },
      "7" = {
        output$plot <- renderPlot({
          boxplot(
            df$age~data, data=df, 
            main = datasetName,
            xlab = datasetName
          )
        })
      },
      "8" = {
        output$plot <- renderPlot({
          vioplot(
            table(data),
            col = "gold"
          )
          title(datasetName)
        })
      },
      "9" = {
        output$plot <- renderPlot({
          
        })
      }
    )
  }
}

shinyApp(ui = ui, server = server)