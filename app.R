library(shiny)

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
    mainPanel()
  )
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)