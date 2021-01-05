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


    #----- Set workout ---------------------------------------------------------

    # Create reactive values object
    WO_rv <- reactiveValues(length = "", exercises = "")

    # Observe changes to the total length of the main workout
    WO_length = reactive({
        set_length = input$workout_number * (input$workout_ex_length + input$workout_rest_length)
        total_length = (set_length * input$workout_sets) + (input$workout_interim * (input$workout_sets - 1))
        total_length = total_length/60
        total_length
    })
    observe({
        WO_rv$length <- paste0("<h2>", WO_length(), "mins</h2>",
                               "<h4>", input$workout_sets, " sets of ", input$workout_number, " exercises @ ",
                               input$workout_ex_length, "s work : ", input$workout_rest_length, "s rest</h4>")
    })

    # Observe changes to the number of workout exercises
    observe({
        workout <- set_exercises(n_ex = input$workout_number)
        WO_rv$exercises <- paste0("<center><p style='font-size: 17px'><br>", paste0(workout$Exercise, collapse = "<br>"), "<br></p></center>")
    })

    # If user clicks button, reselect workout exercises
    observeEvent(input$workout_go, {
        workout <- set_exercises(n_ex = input$workout_number)
        WO_rv$exercises <- paste0("<center><p style='font-size: 17px'><br>", paste0(workout$Exercise, collapse = "<br>"), "<br></p></center>")
    })

    # Create outputs
    output$workout_header <- renderUI(HTML(WO_rv$length))
    output$workout_list <- renderUI(HTML(WO_rv$exercises))

})
