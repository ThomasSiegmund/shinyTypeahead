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
    textInput('standard', label = "normal textinput"),
    bsTypeAhead('firstTypeaheadInput', label = "My first typeahead", choices = c("eins", "zwei", "drei")),
    textOutput('firstoutput')
  )
))

# server.R
# --------------------------------------------------------
server <- shinyServer(function(input, output, session) {
  output$standardoutput <- renderText(input$standard)
  output$firstoutput <- renderText(input$firstTypeaheadInput)

})


runApp(list(ui=ui,server=server))
