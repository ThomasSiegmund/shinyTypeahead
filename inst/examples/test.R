# --------------------------------------------------------
# Minimal shiny app testing the typeahead widget

library(shiny)
library(shinyTypeahead)
library(shinythemes)

data(mtcars)
data(islands)

# ui.R
# --------------------------------------------------------
ui <- shinyUI(fluidPage(theme = shinytheme("journal"),
  title = 'shinyTypeahead test app',
  fluidRow(
    textInput('standard', label = "Normal textInput"),
    textOutput("standardoutput"),
    selectInput("choices", "Choices", choices = c("cars", "islands")),
    typeaheadInput('firstTypeaheadInput', label = "My first typeahead", choices = c("eins", "zwei", "drei")),

    textOutput('firstoutput'),

    # see: http://tatiyants.com/how-to-use-json-objects-with-twitter-bootstrap-typeahead/
    typeaheadInput('secondTypeaheadInput', label = "My second typeahead", choices = htmlwidgets::JS('function (query, process) { states = ["California", "Arizona", "New York", "Nevada", "Ohio"];
    process(states);}')),
    textOutput('secondoutput')
  )
))

# server.R
# --------------------------------------------------------
server <- shinyServer(function(input, output, session) {
  output$standardoutput <- renderText(input$standard)
  output$firstoutput <- renderText(input$firstTypeaheadInput)
  output$secondoutput <- renderText(input$secondTypeaheadInput)

  observe( {
    if(input$choices == "cars") {
      choices <- rownames(mtcars)
    } else if (input$choices == "islands") {
      choices <- names(islands)
    } else {
      choices <- c("eins", "zwei", "drei")
    }

    updateTypeaheadInput(session, "firstTypeaheadInput", value = '', choices = choices);
  })

})


runApp(list(ui=ui,server=server))
