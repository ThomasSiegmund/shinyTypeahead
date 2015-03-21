# --------------------------------------------------------
# Minimal shiny app testing the typeahead widget

library(shiny)
library(shinyTypeahead)
data(mtcars)
data(islands)

# ui.R
# --------------------------------------------------------
ui <- shinyUI(fluidPage(
  title = 'shinyTypeahead test app',
  fluidRow(
    textInput('standard', label = "normal textinput"),
    textOutput("standardoutput"),
    selectInput("choices", "Choices", choices = c("cars", "islands")),
    bsTypeAhead('firstTypeaheadInput', label = "My first typeahead", choices = c("eins", "zwei", "drei")),
    textOutput('firstoutput')
  )
))

# server.R
# --------------------------------------------------------
server <- shinyServer(function(input, output, session) {
  output$standardoutput <- renderText(input$standard)
  output$firstoutput <- renderText(input$firstTypeaheadInput)

  observe( {
    if(input$choices == "cars") {
      choices <- rownames(mtcars)
    } else if (input$choices == "islands") {
      choices <- names(islands)
    } else {
      choices <- c("eins", "zwei", "drei")
    }
    updateTypeAhead(session, "firstTypeaheadInput", value = "vier", label = "Newlabel", choices = choices);
   updateTextInput(session, "standard", value = choices[[1]])
  })

})


runApp(list(ui=ui,server=server))
