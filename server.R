shinyServer(function(input, output) {

    #----- Set warm-up ---------------------------------------------------------

    # Create reactive values object
    WU_rv <- reactiveValues(length = "", exercises = "")

    # Observe changes to the length of the warm-up
    observe({
        WU_rv$length <- paste0("Exercises (", input$warmup_length, "mins)")
    })

    # Observe changes to the number of warm-up exercises
    observe({
        warmup <- set_exercises(n_ex = as.numeric(input$warmup_number), warmup = TRUE, type = NULL)
        WU_rv$exercises <- paste0("<center><br>", paste0(warmup$Exercise, collapse = "<br>"), "<center>")
    })

    # If length of warm-up is set to 0, reset exercise list
    observeEvent(input$warmup_length == 0, {
        WU_rv$exercises <- ""
    })

    # If user clicks button, reselect warm-up exercises
    observeEvent(input$warmup_go, {
        warmup <- set_exercises(n_ex = as.numeric(input$warmup_number), warmup = TRUE, type = NULL)
        WU_rv$exercises <- paste0("<center><br>", paste0(warmup$Exercise, collapse = "<br>"), "<center>")
    })

    # Create outputs
    output$warmup_header <- renderText(WU_rv$length)
    output$warmup_list <- renderUI(HTML(WU_rv$exercises))


})
