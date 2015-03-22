.onAttach <- function(...) {

  # Create link to javascript and css files for package
  shiny::addResourcePath("typeahead", system.file('typeahead',
                                     package='shinyTypeahead'))

}

deps <- htmltools::htmlDependency("shinyTypeahead", packageVersion("shinyTypeahead"),
                                        src = c("href" = "typeahead"),
                                        script = c("bootstrap3-typeahead.js", "typeahead_inputbinding.js"));

#'typeaheadInput
#'
#'\code{typeaheadInput} creates a textinput with type ahead function buttons.
#'
#'@param inputId Input variable to assign the control's value to
#'@param label Display label for the control
#'@param value Initial value
#'@param choices Array of strings to match against. Can also be JavaScript
#'  function. Use htmlwidgets::JS() to indicate JavaScript.
#'@param items The max number of items to display in the dropdown. Can also be
#'  set to 'all'
#'@param minLength The minimum character length needed before triggering
#'  autocomplete suggestions. You can set it to 0 so suggestion are shown even
#'  when there is no text when lookup function is called.
#'@seealso \code{\link{updateTypeaheadInput}}
#'@export
typeaheadInput <- function(inputId, label, value = "", choices, items = 8, minLength = 1) {

  if(!'JS_EVAL' %in% class(choices)) {
    choices <- jsonlite::toJSON(choices);
  }

  typeahead <- shiny::tagList(
            shiny::div(class = 'form-group shiny-input-container',
                shiny::tags$label(label, `for` = inputId),
                  shiny::tags$input(id = inputId, type="text",
                             class="form-control shiny-bound-input typeahead",
                             "data-provide" = "typeahead", autocomplete="off",
                             value = value),
                  shiny::tags$script(paste0("$('#", inputId, "').typeahead({source: ", choices, ",
                                     items: ", items, ",
                                      minLength: ", minLength, "})"))
                  )
          )
  htmltools::attachDependencies(typeahead, deps)
}


#'updateTypeaheadInput
#'
#'\code{updateTypeaheadInput} Update a typeaheadInput buttons.
#'@param session The session object passed to function given to shinyServer.
#'@param inputId Input variable to assign the control's value to
#'@param label Display label for the control
#'@param value Initial value
#'@param choices Array of strings to match against. Can also be JavaScript
#'  function. Use htmlwidgets::JS() to indicate JavaScript.
#'@seealso \code{\link{typeaheadInput}}
#'@export
updateTypeaheadInput <- function(session, inputId, label=NULL, value=NULL, choices=NULL) {
  data <- dropNulls(list(id = inputId, label=label, value=value, choices=choices))
  session$sendCustomMessage("typeaheadUpdate", data)
}


# Copy of dropNulls function for shiny to avoid using shiny:::dropNulls
dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE = logical(1))]
}
