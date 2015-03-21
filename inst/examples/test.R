# --------------------------------------------------------
# Minimal shiny app testing the typeahead widget

library(shiny)
library(shinyTypeahead)
data(mtcars)

# ui.R
# --------------------------------------------------------
ui <- shinyUI(fluidPage(
  title = 'Basic usage of D3TableFilter in Shiny',
  fluidRow(
    bsTypeAhead('firstinput', label = "My first typeahead", choices = c("eins", "zwei", "drei")),
    textOutput('firstoutput')
  )
))

# server.R
# --------------------------------------------------------
server <- shinyServer(function(input, output, session) {
  output$firstoutput <- renderText(input$firstinput)

})


runApp(list(ui=ui,server=server))
